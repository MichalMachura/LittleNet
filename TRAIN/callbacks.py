import torch
import numpy as np
from data_types import Types
from utils import plot_history


class BaseCallback:
    """
    Base of callbacks - each callback method takes 
    as argument dictionary with state of model and training process
    """
    def __init__(self, device='cpu'):
        self.early_stop = False
        self.device = device
    
    def to(self, device):
        if Types.is_device(device):
            self.device = device
        for k,v in self.__dict__.items():
            if type(v) is torch.Tensor:
                v.to(device)
    
    def on_fit_begin(self, state, model): pass
    def on_epoch_begin(self, state, model): pass
    
    def on_training_begin(self, state, model): pass
    def on_training_end(self, state, model): pass
    
    def on_validation_begin(self, state, model): pass
    def on_validation_end(self, state, model): pass
    
    def on_epoch_end(self, state, model): pass
    def on_fit_end(self, state, model): pass
    
    def check_stop(self) -> bool:
        return self.early_stop
    
    def reset(self):
        self.early_stop = False


class ProxyCallback(BaseCallback):

    def __init__(self, obj):
        super().__init__()
        self.obj = obj

    def on_fit_begin(self, state, model): 
        if hasattr(self.obj, 'on_fit_begin') \
           and callable(self.obj.on_fit_begin):
            self.obj.on_fit_begin(state, model)

    def on_epoch_begin(self, state, model): 
        if hasattr(self.obj, 'on_epoch_begin') \
           and callable(self.obj.on_epoch_begin):
            self.obj.on_epoch_begin(state, model)

    def on_training_begin(self, state, model):
        if hasattr(self.obj, 'on_training_begin') \
           and callable(self.obj.on_training_begin):
            self.obj.on_training_begin(state, model)                

    def on_training_end(self, state, model):
        if hasattr(self.obj, 'on_training_end') \
           and callable(self.obj.on_training_end):
            self.obj.on_training_end(state, model)                    

    def on_validation_begin(self, state, model):
        if hasattr(self.obj, 'on_validation_begin') \
           and callable(self.obj.on_validation_begin):
            self.obj.on_validation_begin(state, model)                

    def on_validation_end(self, state, model):
        if hasattr(self.obj, 'on_validation_end') \
           and callable(self.obj.on_validation_end):
            self.obj.on_validation_end(state, model)                

    def on_epoch_end(self, state, model):
        if hasattr(self.obj, 'on_epoch_end') \
           and callable(self.obj.on_epoch_end):
            self.obj.on_epoch_end(state, model)                

    def on_fit_end(self, state, model):
        if hasattr(self.obj, 'on_fit_end') \
           and callable(self.obj.on_fit_end):
            self.obj.on_fit_end(state, model)                


class ListCallback(BaseCallback):
    
    def __init__(self, callbacks=[]):
        super().__init__()
        self.callbacks = callbacks
    
    def on_fit_begin(self, state, model):
        for clb in self.callbacks:
            clb.on_fit_begin(state, model)
    
    def on_epoch_begin(self, state, model): 
        for clb in self.callbacks:
            clb.on_epoch_begin(state, model)
    
    def on_training_begin(self, state, model):
        for clb in self.callbacks:
            clb.on_training_begin(state, model)
    
    def on_training_end(self, state, model):
        for clb in self.callbacks:
            clb.on_training_end(state, model)
    
    def on_validation_begin(self, state, model):
        for clb in self.callbacks:
            clb.on_validation_begin(state, model)
    
    def on_validation_end(self, state, model):
        for clb in self.callbacks:
            clb.on_validation_end(state, model)
    
    def on_epoch_end(self, state, model):
        for clb in self.callbacks:
            clb.on_epoch_end(state, model)
    
    def on_fit_end(self, state, model):
        for clb in self.callbacks:
            clb.on_fit_end(state, model)
    
    def reset(self):
        for clb in self.callbacks:
            clb.reset()
    
    def check_stop(self) -> bool:
        
        for clb in self.callbacks:
            if clb.check_stop():
                return True
        
        return False


class ProxyListCallback(ListCallback):

    def __init__(self, obj_list):
        obj_list = [ProxyCallback(obj) for obj in obj_list]
        super().__init__(obj_list)


class Checkpoint(BaseCallback):
    
    def __init__(self, formatable_path):
        """
        Save state every epoch.
        :param formatable_path: formatable path which takes one parameter 
        by format() method as epoch number
        """
        super().__init__()
        self.formatable_path = formatable_path
    
    def on_epoch_end(self, state, model):
        path = self.formatable_path.format(state['epoch'])
        
        torch.save(state, path)
        print("Checkpoint saved as:", path)


class SaveLast(BaseCallback):
    
    def __init__(self, path):
        """
        Save state every epoch.
        :param path: path
        """
        super().__init__()
        self.path = path
    
    def on_epoch_end(self, state, model):
        path = self.path
        
        torch.save(state, path)
        print("Last saved as:", path)


class SaveBest(BaseCallback):
    def __init__(self, path, monitored=[], multipliers=1):
        super().__init__()
        self.path = path
        self.monitored = monitored
        
        # if lists lengths are different
        if type(multipliers) is list and len(multipliers) != len(monitored):
            raise Exception('Different numer of monitored vars and multipliers')
            
        elif multipliers is not None and type(multipliers) is not list: # is number
            multipliers = [multipliers]*len(monitored)
        
        self.multipliers = np.array(multipliers, dtype=Types.NP_F_DEFAULT)
        self.best = -np.inf*self.multipliers
        
    def on_epoch_end(self, state, model):
        hist = state['history']
        current_value = np.array([hist[m][-1] for m in self.monitored], Types.NP_F_DEFAULT)
        # compute change of monitored value
        delta = (current_value - self.best)*self.multipliers
        # check for change in worse direction
        # is_worse = np.sum(delta < 0) == delta.shape[0]
        is_worse = np.sum(delta < 0) > 0
        # if worse -> not save
        if is_worse:
            return
        
        # all monitored values are better => are new best
        self.best = current_value
        
        # save state
        torch.save(state, self.path)
        print("Best model saved as:", self.path, ", with ", dict(zip(self.monitored, self.best.tolist())))


class EarlyStopping(BaseCallback):
    def __init__(self, filter_size=3, threshold=0):
        super().__init__()

        self.filter_size = filter_size
        self.mask = [1/filter_size]*filter_size
        self.threshold = threshold

    def filter_series(self, data):
        pre = [data[0]]*(self.filter_size//2)
        post = [data[-1]]*(self.filter_size//2)
        # merge lists
        extednded = pre
        extednded.extend(data.copy())
        extednded.extend(post)
        # conv 1d
        out = np.convolve(extednded, self.mask, 'valid')
        
        return out

    def on_epoch_end(self, state, model):
        if state['epoch'] <= self.filter_size:
            return
        import matplotlib.pyplot as plt
        
        # filter data before analysis
        loss = self.filter_series(state['history']['loss'])
        val_loss = self.filter_series(state['history']['val_loss'])

        # derrivatives
        d_loss = loss[1:] -  loss[:-1]
        d_val_loss = val_loss[1:] -  val_loss[:-1]
        # get iter. where sign of val and training losses are different
        different_sign = np.logical_and((d_loss * d_val_loss) < 0, d_val_loss < 0)
        # get val loss at different pos
        d_val_up = d_val_loss*different_sign
        sum_of_changes = np.sum(d_val_up)
        
        # if sum of positive changes of val der.
        # stop training 
        if sum_of_changes > self.threshold:
            self.early_stop = True
            print("Early stopping")
        else:
            self.early_stop = False
            
        return loss, val_loss, d_loss, d_val_loss, different_sign, sum_of_changes

        
class PlotHistory(BaseCallback):

    def __init__(self, period=10):
        super().__init__()
        self.period = period

    def on_fit_begin(self, state, model):
        epoch = state['epoch']
        if epoch > 0:
            plot_history(state['history'].copy())

    def on_fit_end(self, state, model):
        plot_history(state['history'].copy())

    def on_epoch_end(self, state, model):
        epoch = state['epoch'] + 1

        if (epoch % self.period) == 0:
            plot_history(state['history'].copy())




