import torch
import brevitas
import numpy as np
# import matplotlib.pyplot as plt
import time
import sys
import os
import cv2 as cv
import argparse


if __name__ == '__main__':
    print("Train script started...")
    # command line args
    parser = argparse.ArgumentParser()
    parser.add_argument('--DATASET_DIR', required=True)
    parser.add_argument('--FOLD_STATE_PATH', required=True)
    parser.add_argument('--PROJECT_DIR', required=True)
    parser.add_argument('--MODELS_DIR', required=True) # in project
    parser.add_argument('--CIOU_SWITCH_ON', type=int, required=True)
    parser.add_argument('--USE_QUANT', type=int, required=True)
    parser.add_argument('--BN_QUANT', type=int, required=True)
    parser.add_argument('--MODEL_TYPE', required=True)
    parser.add_argument('--BATCH_SIZE', type=int, default=10)
    
    # get args
    args = parser.parse_args()
    # type of model / it's history
    # models_path = 'models_LN6'
    # models_path = 'models_LN7'
    # models_path = 'models_LN7_ciou'
    models_path = args.MODELS_DIR
    
    # assign cmd args to variables
    dataset_local_path = args.DATASET_DIR
    path_to_folds_state = args.FOLD_STATE_PATH
    project_dir = args.PROJECT_DIR
    

    drive_path = project_dir
    # subdirectory with models
    models_path = os.path.join(drive_path, models_path)
    
    """add path to allow import!!!"""
    sys.path.append(drive_path)

    # get device to execute 
    use_cuda = torch.cuda.is_available()
    # use_cuda = False
    device = torch.device("cuda" if use_cuda else "cpu")
    print(device)

    import callbacks
    import criterions
    import preprocessing
    import training
    import utils
    import metrics
    import quantizers as quant
    import networks
    import schedulers
    
    # apply ciou switch
    metrics.CONSTANTS.CIOU_SWITCH = True if args.CIOU_SWITCH_ON else False 
    
    image_shape = (112, 208, 3)

    after_load = preprocessing.numpy_to_torch_iou_params(device)
    to_anchors_single = lambda *x: preprocessing.to_anchors_for_iou_loss(*x,False,False)
    to_anchors_multi = lambda *x: preprocessing.to_anchors_for_iou_loss(*x,True,False)
    
    anchors = np.array([22,33, 5,10, 15,5 ], np.float32).reshape((-1,2))
    anchors *= np.array([[image_shape[0]/340, image_shape[1]/640]])
    
    if args.USE_QUANT:
        qwi8 = quant.generalized_auto_fxp(bit_width=8, frac_part=6, signed=0.1, 
                                        max_bit_width=8, min_bit_width=8, round_mode='floor',
                                        trainable_signed=False, trainable_bit_width=False,
                                        trainable_scale=False, dst='act')
        qw8 = quant.generalized_auto_fxp(bit_width=8,frac_part=5, signed=0.9,
                                        min_bit_width=4, max_bit_width=8, 
                                        trainable_signed=False, trainable_bit_width=False,
                                        dst='weight',)
        qb8 = quant.generalized_auto_fxp(bit_width=8,frac_part=5, signed=0.9,
                                        min_bit_width=4, max_bit_width=8, 
                                        trainable_signed=False, trainable_bit_width=False,
                                        dst='bias',)
        qa = quant.generalized_auto_fxp(bit_width=8,frac_part=4, signed=0.9,
                                        min_bit_width=2, max_bit_width=8, 
                                        trainable_signed=False, trainable_bit_width=False,
                                        dst='act',)
        quant_input = qwi8
        quant_medium = (qw8,
                        None,
                        qa, # inter quant - before bn
                        qa,# out quant - afeter 
                        qb8)
        quant_out = (qw8,None,qa,qa,qb8)
    else:
        quant_input = None
        quant_medium = (None,None,None,None)
        quant_out = (None,None,None,None)
    
    networks.SeparableConv2D.QUANT_BEFORE_BN = True
    if args.BN_QUANT:
        networks.QuantBatchNorm.ALLOW_QUANTIZATION = True
    # net = networks.LittleNet5(anchors.shape[0], None, (None,None,None,None), (None,None,None,None), device=device)
    # net = networks.LittleNet6(anchors.shape[0], None, (None,None,None,None), (None,None,None,None), device=device)
    
    if args.MODEL_TYPE == 'LN7':
        net = networks.LittleNet7(anchors.shape[0], quant_input, quant_medium, quant_out, device=device)

    # pass example tensor
    torch.cuda.empty_cache()
    tensor = torch.rand((8,3,)+image_shape[:2]).to(device)
    print("Input shape =",tensor.shape)
    with torch.no_grad():
        result = net(tensor)

    print("Result shape =",result.shape)

    # get yolo paremeters
    output_sizes = np.array(result.shape[2:][::-1])
    p_num = networks.get_number_of_params(net)
    
    del tensor
    del result

    print("Anchors: ")
    print(anchors) 
    print("Output sizes: ")
    print(output_sizes) 
    print("Number of parameters: ")
    print(p_num) 

    # CREATE GENERATORS
    def numpy_to_tensor(X,y,device=device):
        return utils.data_to_tensor_v3(X,y,device)

    grid_WH2 = image_shape[:2][::-1] // (2*output_sizes)
    # create Transformer object
    transform = preprocessing.Transformer(generator=np.random.default_rng(), 
                                noise=0.02, 
                                horizontal_flip=(), 
                                vertical_flip=(), 
                                rotate=(-15,15), 
                                # equalize_hist=0.05, 
                                blur=7,
                                scale=(0.8, 1.5),
                                translate=((-grid_WH2[0], grid_WH2[0]),
                                        (-grid_WH2[1], grid_WH2[1])),
                                HSV=0.005,
                                LAB=0.005,
                                YCrCb=0.005,
                                )
    # create generators without data => generators templates
    train_generator = preprocessing.YoloDataGenerator(
                                dataset_local_path,
                                input_shape=image_shape,
                                anchors=anchors,
                                images_labes=[],# [(img_path, bbox_path),] 
                                batch_size=64,
                                name='TrainGenerator', 
                                augmentator=transform,
                                output_size=output_sizes,
                                after_load=after_load,
                                # depends on model
                                bbox_to_anchors=to_anchors_multi,
                                )
    val_generator = preprocessing.YoloDataGenerator(
                                dataset_local_path,
                                input_shape=image_shape,
                                anchors=anchors,
                                images_labes=[], 
                                batch_size=64,
                                name='ValGenerator', 
                                augmentator=None,
                                output_size=output_sizes,
                                after_load=after_load,
                                # bbox_to_anchors=to_anchors_single,
                                bbox_to_anchors=to_anchors_multi,
                                )
    test_generator = preprocessing.YoloDataGenerator(
                                dataset_local_path,
                                input_shape=image_shape,
                                anchors=anchors,
                                images_labes=[], 
                                batch_size=64,
                                name='TestGenerator', 
                                augmentator=None,
                                output_size=output_sizes,
                                after_load=after_load,
                                # bbox_to_anchors=to_anchors_single,
                                bbox_to_anchors=to_anchors_multi,
                                )

    # PATHS FORMATS
    # paths format is (fold_idx, '{}') - to be possible next format
    checkpoint_format_path = models_path+'/model_chp_fold_{}_epoch_{}.pt'
    best_format_path = models_path+'/model_best_fold_{}.pt'
    best_iou_format_path = models_path+'/model_best_iou_fold_{}.pt'
    last_format_path = models_path+'/model_last_fold_{}.pt'
    global_last_path = models_path+'/network_model_last.pt' 

    ########
    ## HW RESOURCES USAGE
    print("Num of params:", networks.get_number_of_params(net))

    # get layers outputs
    with torch.no_grad():
        t = torch.rand(1,3,*image_shape[:2], device=device)
        ans = net.multioutput_forward(t)[:-1]

    layers_outputs = np.array([list(a.size()) for a in ans])

    # get params as [ ([filters, filter_len],is_dw, paralellism),...]
    params = []
    layers = net.layers[1:-1]

    for i, L in enumerate(layers):
        p = networks.get_number_of_params(L)
        is_dw = type(L) is networks.DWConv2d
        ch_out = L.out_channels
        
        if is_dw:
            paralellism = 1
        elif i+1 == len(layers):
            paralellism = 5
        else:
            ceil = lambda *x: int((x[0]-1)/x[1] +1)
            paralellism = 16 if ceil(ch_out,16) == ceil(ch_out,18) else 18

        paralellism = min(ch_out, paralellism)

        params.append(([ch_out, p//ch_out], is_dw, paralellism))

    # get buffers BRAMs and assigned layers
    in_layer,\
    blocks_buffers,\
    out_layer,\
    assignments = utils.buffers_brams_usage(layers_outputs,
                                            layers_per2buffers=4, 
                                        #    separate_out=False
                                            separate_out=True
                                            )
    # get ROMs BRAMs
    blocks_roms = utils.roms_usage(params,bit_width=8)

    # print buffers
    name = "{}_{:02}_{:1}: {:3.0f} BRAMS layers={} shapes={}"
    shapes = np.array(layers_outputs)[:,1:]
    print(name.format("In_", 0, 0, in_layer, [0], shapes[0,:].tolist()))
    for blk_idx, blk in enumerate(blocks_buffers):
        for buff_idx, buff in enumerate(blk):
            layers_idx = assignments[blk_idx][buff_idx]
            print(name.format("Blk",blk_idx+1, buff_idx, buff, layers_idx, shapes[layers_idx,:].tolist()))
    print(name.format("Out", len(blocks_buffers)+1, 0, out_layer, [len(layers_outputs)-1],shapes[-1,:].tolist()))

    # print ROMS
    templ = 'P_{:2}: shape={:10} type={:2} parallelism={:2} => {:3}'
    for i, ((shape,is_dw, paralellism),(brams)) in enumerate(zip(params,blocks_roms)):
        print(templ.format(i,str(shape),'dw' if is_dw else 'pw', paralellism, brams))

    tot_roms_bram = sum(blocks_roms)
    tot_buff_bram = in_layer+np.sum(blocks_buffers) # out_layer

    print("Total {} BRAM used by BUFFERs".format(tot_buff_bram))
    print("Total {} BRAM used by ROMs".format(tot_roms_bram))
    print("Total {} BRAM usage".format(tot_roms_bram+tot_buff_bram))
    print("Total {} DSP48 usage".format(utils.DSP_cout(params)))
    ####################
    
    # optimizer
    lr = 0.1
    momentum = 0.9
    optimizer = torch.optim.SGD(net.parameters(), lr=lr, momentum=momentum)
    folds_state = training.load_folds(path_to_folds_state)
    state_dict = torch.load(global_last_path, map_location=torch.device(device))
    trainer = training.load_trainer(net, optimizer, state_dict, device)
    trainer.to(device)
    
    # ADD run settings
    opt = 'Epoche '+str(trainer.epoch)+':'
    
    for k,v in vars(args).items():
        opt += "\nkey='{}' : value='{}'".format(str(k),str(v))
    
    trainer.additional_state['info'].append(opt)
    
    print(trainer.additional_state.keys())
    print(trainer.additional_state['info'])
    
    # HERE IS MAIN CROSS-VALIDATION LOOP
    epochs_limit = 350
    
    multiplier = 7 if args.USE_QUANT else 10
    multiplier = args.BATCH_SIZE
    train_generator.batch_size = 48*multiplier
    val_generator.batch_size = 48*multiplier
    test_generator.batch_size = 48*multiplier

    update_period = 1 + 48*10 // train_generator.batch_size
    
    # get fold state
    current_fold = folds_state.state

    for fold_idx in range(current_fold, len(folds_state)):
        # if new fold
        if fold_idx != trainer.additional_state['fold_state']:
            print("FOLD", fold_idx, "begin ")
            # set fold state
            trainer.additional_state['fold_state'] = fold_idx
            trainer.reset()
            # save reseted model
            torch.save(trainer.get_state(), global_last_path)
        else:
            print("FOLD", fold_idx, "continue")

        # get fold data split
        train_data, val_data = folds_state.__getitem__(fold_idx, train_folds=4)
        # set callbacks path apropriate to current fold
        trainer.additional_state['checkpoint_clb'].formatable_path = checkpoint_format_path.format(fold_idx, '{}')
        trainer.additional_state['best_clb'].path = best_format_path.format(fold_idx)
        trainer.additional_state['best_iou_clb'].path = best_iou_format_path.format(fold_idx)
        trainer.additional_state['last_clb'].path = last_format_path.format(fold_idx)
        trainer.additional_state['last_global_clb'].path = global_last_path
        
        train_generator.images_labes = train_data
        val_generator.images_labes = val_data

        # train model up to epochs limit
        hist = trainer.continue_fit(train_generator=train_generator, 
                                    epochs=epochs_limit, 
                                    val_generator=val_generator,
                                    update_period=update_period)
        
        # evaluate
        test_generator.images_labes = folds_state.test_set
        loss, metrics = trainer.score(test_generator)
        print("Test evaluation:",loss, metrics)
        # update fold state and save
        folds_state.state += 1
        training.save_folds(folds_state, path_to_folds_state)
        # save model
        torch.save(trainer.get_state(), global_last_path)
        print("FOLD", fold_idx, "finished")
