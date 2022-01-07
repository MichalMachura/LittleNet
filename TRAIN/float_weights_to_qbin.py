import brevitas
from numpy.core.numeric import indices
import torch
import numpy as np
from brevitas.inject import ExtendedInjector
import brevitas.core as bv_core
import brevitas.core.quant as bv_quant
import brevitas.core.scaling as bv_scaling
import brevitas.core.zero_point as bv_zp
import brevitas.core.bit_width as bv_bw
import brevitas.core.function_wrapper.ops_ste as bv_os


round_modes = { 'floor':bv_os.FloorSte,
                'round':bv_os.RoundSte,
                'ceil':bv_os.CeilSte}

def array_to_bin_str(a, parallelism=1, sep='\n'):
    pixels = a.flatten().tolist()
    s = ''
    for i,v in enumerate(pixels):
        s += format(v, 'b').zfill(8)
        if ((i+1)%parallelism) == 0:
            s += sep
    
    return s


def parallelize_weights(w, parallelism):
    # each row is a filter/out_channel
    out_channels = w.shape[0]
    ch_per_thread = (out_channels -1) // parallelism +1
    filled_out_channels = ch_per_thread*parallelism
    
    filled_w = np.zeros((filled_out_channels, w.shape[1]), dtype=w.dtype)
    # beginning as original weights, rest as zeros
    filled_w[:w.shape[0],:] = w
    
    parallel_parts = []
    for p in range(parallelism):
        parallel_parts.append(filled_w[p*ch_per_thread:(p+1)*ch_per_thread, 
                                       :].reshape((-1,1)))
    
    parallelized = np.concatenate(parallel_parts, axis=1)
    parallelized = parallelized.reshape((ch_per_thread,-1))

    return parallelized


def create_int_quant(scale=1, bit_width=8, _narrow_range=False, _signed=True, round_mode='round'):
    """
    Create integer quantizer class
    :param scale: max. abs. value of quantized value
    :param bit_width: bit width of quantized value
    :param narrow range: if True binary coding type U2, else U1 
    :param narrow signed: code with sign
    :param round_mode: type of float to int implementation, alloed are ['floor', 'ceil', 'round']
    """
    bw = bit_width
    sc = scale
    float_to_int = round_modes[round_mode]

    class IntQuant(ExtendedInjector):
        tensor_quant = bv_quant.int.RescalingIntQuant
        int_quant = bv_quant.IntQuant#(narrow_range=narrow_range, signed=signed)
                                                #  quant_delay_steps=10,)
        scaling_impl = bv_scaling.ConstScaling
        int_scaling_impl = bv_scaling.IntScaling#(signed=signed, narrow_range=narrow_range)
        zero_point_impl = bv_zp.ZeroZeroPoint
        bit_width_impl = bv_bw.BitWidthConst
        
        requires_input_scale = False
        requires_input_bit_width = False
        requires_output_scale = False
        requires_output_bit_width = False
        
        float_to_int_impl = float_to_int

        signed = _signed
        narrow_range = _narrow_range
        scaling_init = torch.tensor([sc])
        bit_width = bw
        zero_point = torch.tensor([0])
        # zero_point = 0

    return IntQuant


def create_fixed_point_quant(bit_width, 
                             int_width=1, 
                             narrow_range=False, 
                             signed=True,
                             round_mode='round'):
    """
    Create fixed point qunatizer class
    :param bit_width: bit width of quantized value
    :param int_width: integer part bit width of quantized value
    :param narrow range: if True: binary coding type U2, else U1 
    :param narrow signed: code with sign
    :param round_mode: type of float to int implementation, allowed are ['floor', 'ceil', 'round']
    :return: class of fixed point quantization    
    """
    # scale = 2**(int_width-signed)
    scale = (2**(bit_width-signed)-narrow_range-(1-signed)) / 2**(bit_width-int_width)
    
    return create_int_quant(scale=scale, 
                            bit_width=bit_width, 
                            _narrow_range=narrow_range, 
                            _signed=signed,
                            round_mode=round_mode)

def float_to_qbin(dst_coe_file_path, 
                  qunatizer, 
                  weight, 
                  bias=None, 
                  bn_weight=None, 
                  bn_bias=None, 
                  inverse_order=False, 
                  parallelism=1, 
                  signed_quantizer=True,
                  file_format="memory_initialization_radix=2;\nmemory_initialization_vector={};",
                  groups=1
                  ):
    """
    :param weight: of float tensor of shape (num_of_filers, ...)
    :param bias: of float tensor of shape (num_of_filers, 1)
    :param bn_weight: of float tensor of shape (num_of_filers, 1)
    :param bn_bias: of float tensor of shape (num_of_filers, 1)
    """
    nof = weight.shape[0]
    # flatten filter weights
    weight = weight.reshape((nof,-1))
    
    # inverse order for dw conv
    if inverse_order:
        weight = torch.tensor(weight.numpy()[:,::-1].copy())
    # reorder weights in pw filter
    else:
        now = weight.shape[1]
        mul = now // groups
        indices = torch.arange(0,now)*mul
        indices = indices//now + indices % now
        # reorder (only for pw) weights not filters !!!
        weight[:,torch.arange(0,now)] = weight[:,indices]
        
    
    # merge all weight type tensors
    t = weight
    if bias is not None:
        t = torch.cat([bias.reshape(nof,1), t],dim=1)
    if bn_weight is not None:
        t = torch.cat([bn_weight.reshape(nof,1), t],dim=1)
    if bn_bias is not None:
        t = torch.cat([bn_bias.reshape(nof,1), t],dim=1)
    
    # for dw reorder filters by groups
    if inverse_order:
        mul = nof // groups
        indices = torch.arange(0,nof)*mul
        indices = indices//nof + indices % nof
        # reorder filter with weight,bias and bn
        t[torch.arange(0,nof),:] = t[indices,:]
    
    # quantize
    q = qunatizer.tensor_quant(t)
    
    # qunatized float / scale
    qt = q[0]/q[1]
    qt = qt.numpy()
    
    # to int type
    if signed_quantizer:
        qt_int = qt.astype(np.int8)
    else:
        qt_int = qt.astype(np.uint8)
    
    qt_int = parallelize_weights(qt_int, parallelism)
    s = array_to_bin_str(qt_int.astype(np.uint8), parallelism=parallelism, sep='\n')
    
    # coe format with prefix
    s = file_format.format(s)
    
    # save to file
    f = open(dst_coe_file_path, 'w')
    f.write(s)
    f.close()


def regroup_weights(weights):
    d = {}
    mapper = {'weight':0, 'bias':1, 'bn_weight':2, 'bn_bias':3}
    
    for k,v in weights.items():
        splitted = k.split('.')
        
        sep_idx = splitted[0]
        conv_type = 'dw' if 'dw' in k else 'pw'
        is_bn = 'bn' in k
        is_w = 'weight' in k
        is_b = 'bias' in k
        
        if sep_idx not in d.keys():
            d[sep_idx] = {}
        if conv_type not in d[sep_idx].keys():
            d[sep_idx][conv_type] = {}
        
        name = ''
        if is_bn:
            name += 'bn_'
        if is_w:
            name += 'weight'
        if is_b:
            name += 'bias'
        
        # add entry
        d[sep_idx][conv_type][name] = v
    
    # layers packages 
    LP = []
    for _, dd in d.items():
        for conv_type, pack_params in dd.items():
            # list of 5 elements
            LP.append([None]*5)
            # first elem. is conv type
            LP[-1][0] = conv_type
            
            for k, v in pack_params.items():
                # get idx of element type
                mapped_idx = mapper[k]+1
                LP[-1][mapped_idx] = v
    
    groups = []
    in_ch = 3
    rom_names = []
    parallelisms = []
    for i,P in enumerate(LP):
        rom_names.append('rom_{}_{}_{}.coe'.format(P[0], str(1+i//3), str(i%3)))
        parallelisms.append(1 if P[0] == 'dw' else 5*1 if i == 12 else 2*8)
        
        # grouping 
        # last pw
        if i+1 == len(LP):
            groups.append(1)
        elif( P[0] == 'dw'):
            groups.append(in_ch)
        elif( P[0] == 'pw'):
            groups.append(in_ch)
            # next separable conv2d groups is number of output channels from this layer
            in_ch = P[1].shape[0]
    
    for i, P in enumerate(LP):
        for j, el in enumerate(P):
            if j == 0:
                print(i,j,el, " => "+rom_names[i], 'p =', parallelisms[i], "g =", groups[i])
            else:
                print(i,j,list(mapper.keys())[j-1],el.shape if el is not None else el)
    
    
    return rom_names, LP, parallelisms, groups


def convert_to_hw(base_dir, quantizer, signed_quantizer, rom_names, weight_packages, parallelisms,groups):
    for rn, wp, p, g in zip(rom_names, weight_packages, parallelisms,groups):
        dst = base_dir + '/'+rn
        io = wp[0] == 'dw'
        w = wp[1]
        b = wp[2]
        bn_w = wp[3]
        bn_b = wp[4]
        float_to_qbin(dst,quantizer, 
                      w,b,bn_w,bn_b,
                      inverse_order=io, 
                      parallelism=p,
                      signed_quantizer=signed_quantizer,
                      groups=g)
        print("Updated file: "+dst)
    

def weights_to_hw_dirs(weights, dirs:list):
    
    rom_names, LP, parallelisms, groups = regroup_weights(weights)
    Q8_3R = create_fixed_point_quant(8,3,False,True, 'round')
    
    coe_dirs = dirs
    for coe_dir in coe_dirs:
        convert_to_hw(coe_dir,
                    Q8_3R,
                    True,
                    rom_names,
                    LP,
                    parallelisms,
                    groups)

if __name__ == "__main__":
    src_dict_path = 'weights_only.pth'
    
    weights = torch.load(src_dict_path, map_location='cpu')
    for i,k in enumerate(weights.keys()):
        print(i,k)
    
    coe_dir1 = 'F:\\LittleNet_ACC_verilog\\LittleNetAcc_2019_1\\LittleNetAcc_2019_1.srcs\\sources_1\\ip\\rom_init'
    coe_dir2 = '''F:\LittleNet_ACC_verilog\LittleNetAcc_2019_1\LittleNetAcc_2019_1.ip_user_files\mem_init_files'''
    coe_dir3 = '''F:\LittleNet_ACC_verilog\LittleNetAcc_2019_1\LittleNetAcc_2019_1.srcs\sources_1\imports\LittleNet_ACC\memory_init'''
    
    coe_dirs = [coe_dir1, coe_dir2, coe_dir3]
    
    weights_to_hw_dirs(weights, coe_dirs)



