import utils
import numpy as np
import time
import callbacks as clb
import torch
import pickle
# import matplotlib.pyplot as plt
import schedulers
from data_types import Types
from utils import seconds_to_hmsms


def compute_metrics(metrics, y_predict, labels):
    metrics_values = {}
    
    for k, f in metrics.items():
        metrics_values[k] = f(y_predict, labels)
        
    return metrics_values

def adjust_sizes(lists, filler=None):
    """
    Fill smaller lists by filler at the end 
    to obtain the same size of all lists.
    """
    L = [len(L) for L in lists]
    dst_size = np.max(L)
    
    for it in lists:
        # number of elements to achieve dst_size 
        filler_list = [filler]*(dst_size-len(it))
        it.extend(filler_list)


def mult_dict_scalar(dict_, scalar):
    return {k:scalar*v for k,v in dict_.items()}


def set_pos_list(list_, pos, value, filler=None):
    # fill to pos if out of range 
    if pos >= len(list_):
        list_.extend([filler]*(pos+1-len(list_)))
        
    # and set value
    list_[pos] = value


def set_pos_dict(dict_of_lists, pos, dict_values, filler=None):
    for k in dict_values.keys():
        set_pos_list(dict_of_lists[k], pos, dict_values[k], filler=filler)


def dict_values_from_items(dict_values):
    return {k:v.item() if isinstance(v,torch.Tensor) else v for k,v in dict_values.items()}


def dict_add(d1, d2):
    d3 = {}
    
    for k in d2.keys():
        d3[k] = d1[k] + d2[k]
        
    return d3
    

def mean_dict(d1, d2, mul1, mul2):
    d1_ = mult_dict_scalar(d1, mul1)
    d2_ = mult_dict_scalar(d2, mul2)
    
    d_out = mult_dict_scalar(dict_add(d1_, d2_), 1.0/(mul1+mul2))
    
    return d_out


def mean_loss(loss1, loss2, mul1, mul2):
    loss1 = loss1 * mul1
    loss2 = loss2 * mul2
    
    loss_out =(loss1+loss2)/(mul1+mul2)
    
    return loss_out


def dict_to_str(d):
    s = ' '
    for k,v in d.items():
        s += k +' = '+str(v)+' '
    return s


def keys_to_str_format(keys, notation='.5f'):
    s = ''
    for k in keys:
        s += str(k)+'={:'+notation+'} '
    
    return s


class Trainer:
    
    def __init__(self, model, criterion, optimizer, name='Trainer', metrics={}, callbacks=[], **kwargs):
        self.model = model
        self.name = name

        self.metrics = metrics
        self.optimizer = optimizer
        self.callbacks = callbacks
        self.epoch = 0
        self.current_epoch = 0
        self.criterion = criterion
        
        keys = ['loss', 'val_loss']
        keys.extend(self.metrics.keys())
        keys.extend(['val_'+k for k in self.metrics.keys()])
        self.history = {}
        for k in keys:
            self.history[k] = []
        
        self.additional_state = kwargs
        
    def to(self, device):
        self.model.to(device)
        
        for c in self.callbacks:
            c.to(device)

        for m in self.metrics.values():
            m.to(device)
        
        return self

    def get_state(self):
        state = self.__dict__.copy()
        # replace object by their state dicts
        state['model'] = self.model.state_dict()
        state['optimizer'] = self.optimizer.state_dict()
        return state

    def _get_scheduler(self):
        """
        param self:
        :return scheduler object: if scheduler from additional state is available  
                  else BaseScheduler with optimizer lr 
        """
        if 'scheduler' in self.additional_state.keys():
            return self.additional_state['scheduler']
        else:
            return schedulers.BaseScheduler()  
    
    def adjust_history_sizes(self):
        """
        Make all history entries of the same length 
        - max len present in history by fill of None
        :param self:
        """
        adjust_sizes([v for v in self.history.values()])

    def reset(self):
        """
        Delete history, set epoch to 0 and reset callbacks.
        Model is not reinitialized !!!
        :param self: -
        """
        self.epoch = 0
        self.current_epoch = 0
        # history reset
        keys = ['loss', 'val_loss']
        keys.extend(self.metrics.keys())
        keys.extend(['val_'+k for k in self.metrics.keys()])
        self.history = {}
        for k in keys:
            self.history[k] = []
        # reset callback's
        for c in self.callbacks:
            c.reset()

    def score(self, generator, quiet=False):
        """
        :param self: -
        :param generator: generator with data of type X, y
        :param quiet: flag, if false, progress is printed, else not 
        :return mean loss, mean metrics:
        """
        # set evaluation mode
        self.model = self.model.eval()
        # get model device
        dev = next(self.model.parameters()).device
        # visual params
        bar_len = 20
        score_txt = 'loss={:.5f} '+keys_to_str_format(self.metrics.keys())+'time={}'
        # display bar
        if not quiet:
            utils.bar(0,len(generator), length=bar_len, pre_text='Score', post_text='start')
        
        # init loss and metrics
        running_loss = 0.0
        running_metrics = dict.fromkeys(self.metrics.keys(), 0.0)

        # score begin event
        generator.on_score_begin()
        
        # time measurement
        t0 = time.time()
        with torch.no_grad():
            for i in range(len(generator)):
                # get data and labels
                inputs, labels = generator[i]
                # number of samples
                batch_size = inputs.shape[0]
                # get outputs
                outputs = self.model(inputs)
                # get sum of output losses 
                loss = self.criterion(outputs, labels)
                # calculate metrics
                metrics_dict = compute_metrics(self.metrics, outputs, labels)
                # compute mean loss and metrics
                running_loss = mean_loss(running_loss, loss.item(), i*generator.batch_size, 1.0*batch_size)
                running_metrics = mean_dict(running_metrics, metrics_dict, i*generator.batch_size, 1.0*batch_size)
                running_metrics = dict_values_from_items(running_metrics)
                
                # exec. time
                dt = time.time() - t0
                # display bar
                if not quiet:
                    utils.bar(i,
                              len(generator), 
                              pre_text='Score', 
                              length=bar_len,
                              post_text=score_txt.format(running_loss, 
                                                         *tuple(running_metrics.values()), 
                                                         seconds_to_hmsms(dt)))
        
        # release memory
        torch.cuda.empty_cache()
        # exec. time
        dt = time.time() - t0
        # display finsh epoch bar
        if not quiet:
            utils.bar(len(generator), 
                        len(generator), 
                        pre_text='Score', 
                        length=bar_len,
                        post_text=score_txt.format(running_loss, 
                                                   *tuple(running_metrics.values()), 
                                                   seconds_to_hmsms(dt)),
                        end='\n')
        
        # score end event
        generator.on_score_end()
            
        return running_loss, running_metrics
    
    def fit(self, train_generator, epochs, val_generator=None):
        """
        Run training for epochs epochs. History is not reset.
        Training is continue for next epochs epochs.

        :param self: -
        :param train_generator: training data generator
        :param epochs: number of epochs
        :param val_generator: validation data generator
        :return history: dictionary with values of loss and metrics for 
                        whole training process, 
                        for both train and validation data
        """
        return self.continue_fit(train_generator, 
                                 self.epoch+epochs, 
                                 val_generator=val_generator)

    def continue_fit(self, train_generator, epochs, val_generator=None, update_period=25):
        # get model device
        dev = next(self.model.parameters()).device
        self.model.to(Types.T_WEIGHT)
        
        # get scheduler object
        scheduler = self._get_scheduler()
        # copy list of original callbacks
        tmp_callbacks = self.callbacks.copy()
        # add generator as callback to tmp list to prevent generator save to file
        tmp_callbacks.append(train_generator)
        # add proxy callbacks for criterion, scheduler, optimizer and metrics
        tmp_callbacks.append(clb.ProxyCallback(self.criterion))
        tmp_callbacks.append(clb.ProxyCallback(self.optimizer))
        tmp_callbacks.append(clb.ProxyCallback(scheduler))
        tmp_callbacks.append(clb.ProxyListCallback(self.metrics.values()))
        # create proxy callback to call all callback
        callback = clb.ListCallback(tmp_callbacks)
        # bar post text schemes
        bar_len = 20
        train_txt = 'loss={:.5f} '+keys_to_str_format(self.metrics.keys())+'time={}'
        val_txt = 'loss={:.5f} '+keys_to_str_format(self.metrics.keys()) \
                  +'| val_loss={:.5f} '+keys_to_str_format(['val_'+k for k in self.metrics.keys()])+'time={}'
        
        # adjust history sizes e.g. previously net trained without validation
        self.adjust_history_sizes()

        #  fit begin event
        callback.on_fit_begin(self.get_state(),model=self.model)
        
        # start from the trainer's epoch state
        for epoch in range(self.epoch+1, epochs+1):
            # set current epoch
            self.current_epoch = epoch
            pre_text = 'Epoche '+str(self.current_epoch) + '/' + str(epochs)
            # display bar
            utils.bar(0,len(train_generator), length=bar_len,pre_text=pre_text, post_text='start')
            # reset loss and metrics
            running_loss = 0.0
            running_metrics = dict.fromkeys(self.metrics.keys(), 0.0)
            # set training mode
            self.model.train()
            # epoche begin event
            callback.on_epoch_begin(self.get_state(),model=self.model)
            
            # training begin event
            callback.on_training_begin(self.get_state(),model=self.model)
            
            # time measurement
            t0 = time.time()
            # reset gradient
            self.optimizer.zero_grad()
            batches_time = 0.0
            for i in range(len(train_generator)):
                # get data and labels
                inputs, labels = train_generator[i]
                batch_size = inputs.shape[0]
                # get outputs
                outputs = self.model(inputs)
                # get sum of output losses 
                loss = self.criterion(outputs, labels) / update_period
                # backward propagation
                loss.backward()
                
                if ((i+1)%update_period) == 0:
                    # update model params
                    self.optimizer.step()
                    # reset gradient
                    self.optimizer.zero_grad()
                    
                # calculate metrics
                metrics_dict = compute_metrics(self.metrics, outputs, labels)
                # compute mean loss and metrics
                running_loss = mean_loss(running_loss, loss.item()*update_period, i*train_generator.batch_size, 1.0*batch_size)
                running_metrics = mean_dict(running_metrics, metrics_dict, i*train_generator.batch_size, 1.0*batch_size)
                # exec. time 
                batches_time = time.time() - t0
                # display bar
                utils.bar(i,
                          len(train_generator),
                          pre_text=pre_text,
                          length=bar_len,
                          post_text=train_txt.format(running_loss, 
                                                     *tuple(running_metrics.values()), 
                                                     seconds_to_hmsms(batches_time)))
        
            # update model params for last uncompleted period
            self.optimizer.step()
            self.optimizer.zero_grad(True)
            # update optimizer lr
            scheduler.step(self.optimizer, running_loss, epoch)
            
            # release memory
            torch.cuda.empty_cache()
            # training time
            train_time = time.time() - t0

            # insert loss and metrics into history
            set_pos_list(self.history['loss'], self.current_epoch-1, running_loss)
            set_pos_dict(self.history, self.current_epoch-1, dict_values_from_items(running_metrics))
            
            # training end event
            callback.on_training_end(self.get_state(),model=self.model)
            
            # display finish epoch bar
            utils.bar(len(train_generator),
                      len(train_generator), 
                      pre_text=pre_text, 
                      length=bar_len,
                      post_text=train_txt.format(running_loss, 
                                                 *tuple(running_metrics.values()), 
                                                 seconds_to_hmsms(batches_time)),
                      end='' if val_generator is not None else '\n')
            
            # validation
            if val_generator is not None:
                # validation begin event
                callback.on_validation_begin(self.get_state(),model=self.model)
                
                val_loss, val_metrics = self.score(val_generator, quiet=True)
                # reformat val_metrics keys 
                val_metrics = {'val_'+k : v for k,v in val_metrics.items()}
                
                # release memory
                torch.cuda.empty_cache()
                
                train_and_val_time = time.time() - t0
                # insert loss and metrics into history
                set_pos_list(self.history['val_loss'], self.current_epoch-1, val_loss)
                set_pos_dict(self.history, self.current_epoch-1, val_metrics)
                
                # validation end event
                callback.on_validation_end(self.get_state(),model=self.model)
                
                # display finish epoch barval_metrics
                utils.bar(len(train_generator),
                          len(train_generator), 
                          pre_text=pre_text, 
                          length=bar_len,
                          post_text=val_txt.format(running_loss, 
                                                   *tuple(running_metrics.values()), 
                                                   val_loss, 
                                                   *tuple(val_metrics.values()), 
                                                   seconds_to_hmsms(train_and_val_time)),
                          end='\n')
            
            # update epoch
            self.epoch = self.current_epoch
            
            # epoche end event
            callback.on_epoch_end(self.get_state(),model=self.model)
            
            if callback.check_stop():
                break
        
        # fit end event
        callback.on_fit_end(self.get_state(),model=self.model)
        
        print('Training finished')
        
        return self.history.copy()
    
    
def load_trainer(model, optimizer, state_dict, device='cpu', strict=False):
    strict_ans = model.load_state_dict(state_dict['model'], strict=strict)
    print(strict_ans)
    model.to(device)
    
    try:
        optimizer.load_state_dict(state_dict['optimizer'])
    except Exception as e:
        if strict:
            raise e
            
    # optimizer.to(device)
    
    criterion = state_dict['criterion']
    
    metrics = state_dict['metrics']
    name = state_dict['name']
    callbacks = state_dict['callbacks']
    epoch = state_dict['epoch']
    current_epoch = state_dict['current_epoch']
    history = state_dict['history']
    additional_state = state_dict['additional_state']
    
    trainer = Trainer(model=model, 
                      criterion=criterion, 
                      optimizer=optimizer, 
                      name=name, 
                      metrics=metrics, 
                      callbacks=callbacks,
                      **additional_state)
    
    trainer.epoch = epoch
    trainer.current_epoch = current_epoch
    trainer.history = history
    trainer.to(device)
    
    return trainer


class FoldsState:
    def __init__(self, folds=[], state=0, test_set=[]):
        self.folds = folds
        self.state = state
        self.test_set = test_set
        
    def __getitem__(self, state, train_folds=-1):
        """
        :param state: idx of fold as validation set
        :return: 2 lists: train and validation
        """
        # get train folds
        train_sets = [self.folds[i] for i in range(len(self.folds)) if i != state]
        
        if train_folds != -1 and train_folds < len(self.folds)-1:
            # change order to atchieve list started with fold before validate fold
            idx_start = state-1 if state != 0 else len(train_sets)-1
            aux = train_sets[idx_start:]
            aux.extend(train_sets[:idx_start])
            # limit number of folds
            train_sets = aux[-train_folds:]
        
        # join train folds
        train_set = []
        [train_set.extend(f) for f in train_sets]
        # get validation fold
        val_set = self.folds[state]
        
        self.state = state
        
        return train_set, val_set
        
    def __len__(self):
        return len(self.folds)


def save_folds(folds_state, path):
    with open(path, 'wb') as f:
        pickle.dump(folds_state, f)
    
    
def load_folds(path):
    with open(path, 'rb') as f:
        folds_state = pickle.load(f)
        return folds_state
    
    raise Exception("cannot load file:"+path)


# def cross_validation_training(trainer, 
#                               folds_state,
#                               train_generator, 
#                               val_generator, 
#                               test_generator, 
#                               epochs_limit, 
#                               train_folds=1):
#     # get fold state
#     current_fold = folds_state.state

#     for fold_idx in range(current_fold, len(folds_state)):
#         # if new fold
#         if fold_idx != trainer.additional_state['fold_state']:
#             print("FOLD", fold_idx, "begin ")
#             # set fold state
#             trainer.additional_state['fold_state'] = fold_idx
#             trainer.reset()
#             # save reseted model
#             torch.save(trainer.get_state(), global_last_path)
#         else:
#             print("FOLD", fold_idx, "continue")
    
#         # get fold data split
#         train_data, val_data = folds_state.__getitem__(fold_idx, train_folds=1)
#         # set callbacks path apropriate to current fold
#         trainer.additional_state['checkpoint_clb'].formatable_path = checkpoint_format_path.format(fold_idx, '{}')
#         trainer.additional_state['best_clb'].path = best_format_path.format(fold_idx)
#         trainer.additional_state['best_iou_clb'].path = best_iou_format_path.format(fold_idx)
#         trainer.additional_state['best_iou_quant_clb'].path = best_quant_iou_format_path.format(fold_idx)
#         trainer.additional_state['last_clb'].path = last_format_path.format(fold_idx)
        
#         train_generator.images_labes = train_data
#         val_generator.images_labes = val_data

#         # train model up to epochs limit
#         hist = trainer.continue_fit(train_generator=train_generator, 
#                                     epochs=epochs_limit, 
#                                     val_generator=val_generator,
#                                     update_period=update_period)

#         # evaluate
#         test_generator.images_labes = folds_state.test_set
#         loss, metrics = trainer.score(test_generator)
#         print("Test evaluation:",loss, metrics)
        
#         # update fold state and save
#         folds_state.state += 1
#         training.save_folds(folds_state, path_to_folds_state)
#         # save model
#         torch.save(trainer.get_state(), global_last_path)
#         print("FOLD", fold_idx, "finished")

