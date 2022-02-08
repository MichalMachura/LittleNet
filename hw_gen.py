import math
from turtle import width
from matplotlib.pyplot import axis
from nbformat import write
import torch, brevitas
import brevitas.nn as qnn
from typing import List
import os, sys
sys.path.append('TRAIN')

import TRAIN
from TRAIN import networks
from TRAIN.networks import LittleNet7, PWConv2d, DWConv2d
from TRAIN import quantizers 
import numpy as np
import cv2 as cv


class LayerBlock:
    
    WEIGHT_DIR = 'HW/LittleNetAcc_2019_1/memories/'
    CURRENT_ORDER = torch.arange(0,3, dtype=torch.long)
        
    def __init__(self, 
                 name, 
                 in_shape, 
                 out_shape, 
                 in_quant, 
                 out_quant,
                 config={}) -> None:
        super().__init__()
        self.name = name
        self.in_shape = in_shape
        self.in_quant = in_quant
        self.out_shape = out_shape
        self.out_quant = out_quant
        self.config = config
        self.config['name'] = self.name
    
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        return order
    
    @property
    def in_channels(self):
        return self.in_shape[-3]
    
    @property
    def out_channels(self):
        return self.out_shape[-3]
    
    def update_parallelism(self,p):
        pass
    
    def DSP(self):
        return 0
    
    def BRAM(self):
        return 0
    
    def PARALLELISM(self):
        return 1
    
    def TYPE(self):
        return 'NO'
    
    @property
    def CHANGABLE(self):
        return 0
    
    def PIXEL_PER_CLK(self):
        return 1
    
    def MAP_CLKS(self):
        return self.in_shape[0]*self.in_shape[1]*self.in_shape[2]
    
    def DEFAULT_MAP_CLK(self):
        return self.in_shape[0]*self.in_shape[1]*self.in_shape[2]
        
    def get_torch_state(self, p):
        return torch.tensor(self.BRAM()), torch.tensor(self.DSP()), torch.tensor(self.MAP_CLKS())


class PWBlock(LayerBlock):

    def __init__(self, name:str, prev_layer:LayerBlock, m:PWConv2d, is_last=False) -> None:
        config = self.extract_config(prev_layer, m, is_last, name)
        super().__init__(name,
                         config['in_shape'],
                         config['out_shape'],
                         config['in_quant'],
                         config['out_quant'],
                         config
                         )
        
    def extract_config(self,prev_layer:LayerBlock, m:PWConv2d,is_last, name):
        
        in_shape = prev_layer.out_shape
        in_quant = prev_layer.out_quant
        weight = m.conv_pw.weight
        weight_quantizer = m.conv_pw.weight_quant.tensor_quant if m.conv_pw.weight_quant else None
        weight_fp = weight_quantizer.get_repr()
        bias = m.conv_pw.bias
        use_bias = bias is not None
        bias_quantizer = m.conv_pw.bias_quant.tensor_quant if use_bias else weight_quantizer
        bias_fp = bias_quantizer.get_repr() if use_bias else weight_fp
        
        use_relu = isinstance(m.pw_out, qnn.QuantReLU)
        use_mp = hasattr(m,'pw_mp')
        ceil_mode = m.pw_mp.ceil_mode if use_mp else False
        out_quantizer = m.pw_out.act_quant.fused_activation_quant_proxy.tensor_quant
        out_fp = out_quantizer.get_repr()
        
        out_ch = weight.shape[0]
        out_w =  in_shape[-1] if not use_mp else (in_shape[-1] - ceil_mode)//2 + ceil_mode 
        out_h =  in_shape[-2] if not use_mp else (in_shape[-2] - ceil_mode)//2 + ceil_mode 
        out_shape = (out_ch,out_h,out_w)
        
        if 'pw_bn' in dir(m):
            use_bn = True
            inter_quantizer = m.quant_pw_bn.act_quant.fused_activation_quant_proxy.tensor_quant
            inter_fp = inter_quantizer.get_repr()
            bn = m.pw_bn.bn
            bn_w = bn.weight
            bn_w_quantizer = bn.weight_quant.tensor_quant if bn.weight_quant else None
            bn_w_fp = bn_w_quantizer.get_repr()
            bn_b = bn.bias
            bn_b_quantizer = bn.bias_quant.tensor_quant if bn.bias_quant else None
            bn_b_fp = bn_b_quantizer.get_repr()
        else:
            use_bn = False
            inter_quantizer = out_quantizer
            inter_fp = out_fp
            bn_w = None
            bn_w_quantizer = None
            bn_w_fp = weight_fp
            bn_b = None
            bn_b_quantizer = None
            bn_b_fp = weight_fp
        
        # if out feature map is not aligned to multiplicity of 4
        if out_ch*out_w*out_h % 4 != 0:
            # align out channels and weights
            ch_to_add = 4 - (out_ch % 4)
            weight = torch.cat([weight,torch.zeros((ch_to_add,)+weight.shape[1:],dtype=weight.dtype)],dim=0)
            if use_bias:
                bias = torch.cat([bias,torch.zeros((ch_to_add,)+bias.shape[1:],dtype=bias.dtype)],dim=0)
            if use_bn:
                bn_w = torch.cat([bn_w,torch.zeros((ch_to_add,)+bn_w.shape[1:],dtype=bn_w.dtype)],dim=0)
                bn_b = torch.cat([bn_b,torch.zeros((ch_to_add,)+bn_b.shape[1:],dtype=bn_b.dtype)],dim=0)
            
            out_ch += ch_to_add
            out_shape = (out_ch,) + out_shape[1:] 
        
        parallelism = 32 if in_shape[-3] > 500 else 22 if out_ch > 250 else 18 if out_ch > 120 else  16 if out_ch < 60 else 18
        parallelism = 2 if is_last else parallelism
        parallelism = max(1,min(parallelism, out_ch))
        parallelism = max(1, parallelism //  2)
        
        map_size = in_shape[-1]*in_shape[-2]
        if use_mp:
            ww = (in_shape[-2]-ceil_mode)//2 + ceil_mode
            hh = (in_shape[-2]-ceil_mode)//2 + ceil_mode
            map_size = ww*hh
            
        args = self.parallelism_dependencies(parallelism,in_shape[-3],out_ch,map_size,use_bias,use_bn,weight_fp[0])
        parallelism, rom_type, rom_latency, single_brom_len, blocks_num, rom_len = args
        
        config = {
            'in_shape':in_shape,
            'in_quant':in_quant,
            'out_shape':out_shape,
            'out_quant':out_fp,
            
            'width':in_shape[-1],
            'height':in_shape[-2],
            'ch_in':in_shape[-3],
            'ch_out':out_shape[-3],
            
            'in_bw':in_quant[0],
            'in_int':in_quant[1],
            'in_s':in_quant[2]*1,
            
            'weight':weight,
            'weight_q':weight_quantizer,
            'weight_bw':weight_fp[0],
            'weight_int':weight_fp[1],
            'weight_s':weight_fp[2]*1,
            
            'bias':bias,
            'bias_q':bias_quantizer,
            'bias_bw':bias_fp[0],
            'bias_int':bias_fp[1],
            'bias_s':bias_fp[2]*1,
            
            'inter_q':inter_quantizer,
            'inter_bw':inter_fp[0],
            'inter_int':inter_fp[1],
            'inter_s':inter_fp[2]*1,
            
            'bn_weight':bn_w,
            'bn_weight_q':bn_w_quantizer,
            'bn_weight_bw':bn_w_fp[0],
            'bn_weight_int':bn_w_fp[1],
            'bn_weight_s':bn_w_fp[2]*1,
            
            'bn_bias':bn_b,
            'bn_bias_q':bn_b_quantizer,
            'bn_bias_bw':bn_b_fp[0],
            'bn_bias_int':bn_b_fp[1],
            'bn_bias_s':bn_b_fp[2]*1,
            
            'out_q': out_quantizer,
            'out_bw':out_fp[0],
            'out_int':out_fp[1],
            'out_s':out_fp[2]*1,
            
            'use_bias': use_bias*1,
            'use_bn': use_bn*1,
            'use_relu': use_relu*1,
            'use_mp': use_mp*1,
            'ceil_mode': ceil_mode*1,
            'parallelism':parallelism,
            'use_maxfinder': int(is_last),
            'anchors': out_ch//5,
            'read_weight_latency': rom_latency,
            'single_brom_len': single_brom_len,
            'blocks_num': blocks_num,
            'rom_file_format': 'rom_'+name+'_%01d.mem',
            'groups':  32//out_fp[0],
            'rom_len': rom_len,
            'rom_type':rom_type,
            'type':'PWConv2d',
        }
        
        return config
    
    def get_torch_state(self,p):
        from brevitas.core.function_wrapper.ops_ste import ceil_ste, floor_ste, round_ste, binary_sign_ste
        parallelism = p
        
        out_ch = self.config['ch_out']
        ch_in = self.config['ch_in']
        use_bias = self.config['use_bias']
        use_bn = self.config['use_bn']
        weight_bw = self.config['weight_bw']
        
        parallelism = min(parallelism, torch.tensor(out_ch, dtype=torch.float32))
        parallelism = floor_ste(parallelism)
        
        width = self.config['width']
        height = self.config['height']
        map_size = width*height
        ch_per_th = (out_ch-1)//parallelism+1 if (map_size % 4) == 0 else ((out_ch-1)//(parallelism*4)+1)*4 
        rom_len = (ch_in+use_bias+2*use_bn)*ch_per_th
        
        rom_width = parallelism*weight_bw
        
        # num of half brams per width
        half_brams = ceil_ste(rom_width/18)
        # single_brom_len = 1024
        single_brom_len = 1024*2 if rom_width < 10 else 1024

        brom_per_width = half_brams / 2
        blocks_num = floor_ste(rom_len / single_brom_len)*brom_per_width
        
        BRAMs = blocks_num
        DSPs = 1 + parallelism*(1+use_bn)
        MAP_CLKs = (self.in_shape[0]*self.in_shape[1]*self.in_shape[2])*ceil_ste(self.out_channels/parallelism)
        
        return BRAMs, DSPs, MAP_CLKs
    
    def parallelism_dependencies(self,p,ch_in, ch_out, map_size, use_bias,use_bn, weight_bw):
        parallelism = p
        out_ch = ch_out
        parallelism = min(parallelism, out_ch)
        ch_per_th = (out_ch-1)//parallelism+1 if (map_size % 4) == 0 else ((out_ch-1)//(parallelism*4)+1)*4 
        rom_len = (ch_in+use_bias+2*use_bn)*ch_per_th
        rom_width = parallelism*weight_bw
        # rom_type = "distributed" if rom_len < 2*256 else "block"
        # rom_type = "auto"
        rom_type = "block"
        brom_per_width = (rom_width-1) // 36 +1
        single_brom_len = 1024*(36 // rom_width) if brom_per_width == 1 else 1024
        blocks_num = (rom_len-1) // single_brom_len +1
        blocks_num_addr = np.ceil(np.log2(blocks_num)).astype(int)
        rom_latency = 2 + blocks_num_addr
        
        return parallelism, rom_type, rom_latency, single_brom_len, blocks_num, rom_len
        
    def update_parallelism(self, p):
        if self.config['use_maxfinder']:
            return
        
        ch_out = self.config['ch_out']
        ch_in = self.config['ch_in']
        width = self.config['width']
        height = self.config['height']
        map_size = width*height
        use_bias = self.config['use_bias']
        use_bn = self.config['use_bn']
        weight_bw = self.config['weight_bw']
        args = self.parallelism_dependencies(p,ch_in,ch_out,map_size,use_bias,use_bn,weight_bw)
        p, rom_type, rom_latency, single_brom_len, blocks_num, rom_len = args
         
        # update config
        self.config['parallelism'] = p
        self.config['read_weight_latency'] = rom_latency
        self.config['single_brom_len'] = single_brom_len
        self.config['rom_type'] = rom_type
        self.config['blocks_num'] = blocks_num
        self.config['rom_len'] = rom_len
    
    def DSP(self):
        use_bn = self.config['use_bn']
        return 1 + self.PARALLELISM()*(1+use_bn)
    
    def BRAM(self):
        rom_width = self.PARALLELISM()*8
        brom_per_width = (rom_width-1) // 36 + 1
        single_brom_len = 1024*(36 // rom_width) if brom_per_width == 1 else 1024
        blocks_num = int(self.config['rom_len']/single_brom_len + 0.5)
        
        # return self.config['blocks_num']
        return blocks_num*brom_per_width
    
    def PARALLELISM(self):
        return self.config['parallelism']
    
    @property
    def CHANGABLE(self):
        return not self.config['use_maxfinder']
    
    def PIXEL_PER_CLK(self):
        return 1 / self.in_channels
    
    def MAP_CLKS(self):
        return (self.in_shape[0]*self.in_shape[1]*self.in_shape[2]*self.out_channels-1)//self.PARALLELISM() + 1
    
    def DEFAULT_MAP_CLK(self):
        return self.in_shape[0]*self.in_shape[1]*self.in_shape[2]*self.out_channels
    
    def TYPE(self):
        return 'PW'
        
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        nof = self.config['ch_out'] # num of filters
        now = self.config['ch_in'] # num of weights in filter
        indices_nof = torch.arange(0,nof)
        indices_now = torch.arange(0,now)
        
        w = self.config['weight'].clone().reshape(nof,-1)
        w_q = self.config['weight_q']
        w_s = self.config['weight_s']
        qt = w_q(w)
        t = (qt[0]/qt[1]).to(torch.int8 if w_s else torch.uint8).to(torch.uint8)
        # change weights order
        t[:,indices_now] = t[:,order]
        
        if self.config['use_bias']:
            b = self.config['bias'].clone().reshape(nof,1)
            b_q = self.config['bias_q']
            b_s = self.config['bias_s']
            qb = b_q(b)
            b = (qb[0]/qb[1]).to(torch.int8 if b_s else torch.uint8).to(torch.uint8)
            t = torch.cat([b, t],dim=1)
        if self.config['use_bn']:
            bn_w = self.config['bn_weight'].clone().reshape(nof,1)
            bn_w_q = self.config['bn_weight_q']
            bn_w_s = self.config['bn_weight_s']
            qbn_w = bn_w_q(bn_w)
            bn_w = (qbn_w[0]/qbn_w[1]).to(torch.int8 if bn_w_s else torch.uint8).to(torch.uint8)
            t = torch.cat([bn_w, t],dim=1)
        if self.config['use_bn']:
            bn_b = self.config['bn_bias'].clone().reshape(nof,1)
            bn_b_q = self.config['bn_bias_q']
            bn_b_s = self.config['bn_bias_s']
            qbn_b = bn_b_q(bn_b)
            bn_b = (qbn_b[0]/qbn_b[1]).to(torch.int8 if bn_b_s else torch.uint8).to(torch.uint8)
            t = torch.cat([bn_b, t],dim=1)
        
        p = self.config['parallelism']
        mp = self.config['use_mp']
        mpc = self.config['ceil_mode']
        map_size = self.config['height']*self.config['width']
        if mp:
            hh = (self.config['height'] - mpc) // 2 + mpc
            ww = (self.config['width'] - mpc) // 2 + mpc
            map_size = hh*ww
        
        t_p = parallelize_weights(t.numpy(),
                                  parallelism=p, 
                                  map_size=map_size)
        
        # s = array_to_str(t_p,parallelism=p,sep='\n',width=2,f='%02x')[:-1]
        s = array_to_str(t_p,parallelism=p,sep='\n',width=2,f='%02x')
        sbr = self.config['single_brom_len']
        batch_size = sbr*(p*2+1) # 2-hex chars, 1- newline
        
        for i in range(self.config['blocks_num']):
            batch_of_weights = s[i*batch_size:(i+1)*batch_size]
            # save to file
            with open(os.path.join(path,self.config['rom_file_format']%i),'w') as f:
                f.write(batch_of_weights)
                print("Saved memory file under:",
                    self.config['rom_file_format']%i)
        
        out_order = indices_nof 
        return out_order


def array_to_str(a, parallelism=1, sep='\n', width=8, f='b'):
    pixels = a.flatten().tolist()
    s = ''
    for i,v in enumerate(pixels):
        # s += format(v, f).zfill(bit_width)
        s += (f % v).zfill(width)
        if ((i+1)%parallelism) == 0:
            s += sep
    
    return s


def parallelize_weights(w, parallelism, map_size=4):
    # each row is a filter/out_channel
    out_channels = w.shape[0]
    ch_per_thread = (out_channels -1) // parallelism +1 if (map_size%4) == 0 else ((out_channels -1) // (parallelism*4) +1)*4
    filled_out_channels = ch_per_thread*parallelism
    
    filled_w = np.zeros((filled_out_channels, w.shape[1]), dtype=w.dtype)
    # beginning as original weights, rest as zeros
    filled_w[:w.shape[0],:] = w
    
    parallel_parts = []
    for p in range(parallelism):
        f_beg = p*ch_per_thread
        f_end = (p+1)*ch_per_thread
        f_w = filled_w[f_beg:f_end,:]
        parallel_parts.append(f_w.reshape((-1,1)))
    
    parallelized = np.concatenate(parallel_parts, axis=1)
    parallelized = parallelized.reshape((-1,parallelism))

    return parallelized


class DWBlock(LayerBlock):
    
    def __init__(self, name:str, prev_layer:LayerBlock, m:DWConv2d) -> None:
        config = self.extract_config(prev_layer, m, name)
        super().__init__(name,
                         config['in_shape'],
                         config['out_shape'],
                         config['in_quant'],
                         config['out_quant'],
                         config
                         )
    
    def extract_config(self,prev_layer:LayerBlock, m:DWConv2d, name):

        in_shape = prev_layer.out_shape
        in_quant = prev_layer.out_quant
        k_size = m.conv_dw.kernel_size
        padding = m.conv_dw.padding
        weight = m.conv_dw.weight
        weight_quantizer = m.conv_dw.weight_quant.tensor_quant if m.conv_dw.weight_quant else None
        weight_fp = weight_quantizer.get_repr()
        bias = m.conv_dw.bias
        use_bias = bias is not None
        bias_quantizer = m.conv_dw.bias_quant.tensor_quant if use_bias else weight_quantizer
        bias_fp = bias_quantizer.get_repr() if use_bias else weight_fp
        
        use_relu = isinstance(m.dw_out, qnn.QuantReLU)
        out_quantizer = m.dw_out.act_quant.fused_activation_quant_proxy.tensor_quant
        out_fp = out_quantizer.get_repr()
        
        out_ch = weight.shape[0]
        out_h =  in_shape[-2] - k_size[-2] // 2 + padding[-2]
        out_w =  in_shape[-1] - k_size[-1] // 2 + padding[-1]
        out_shape = (out_ch,out_h,out_w)
        
        if 'dw_bn' in dir(m):
            use_bn = True
            inter_quantizer = m.quant_dw_bn.act_quant.fused_activation_quant_proxy.tensor_quant
            inter_fp = inter_quantizer.get_repr()
            bn = m.dw_bn.bn
            bn_w = bn.weight
            bn_w_quantizer = bn.weight_quant.tensor_quant if bn.weight_quant else None
            bn_w_fp = bn_w_quantizer.get_repr()
            bn_b = bn.bias
            bn_b_quantizer = bn.bias_quant.tensor_quant if bn.bias_quant else None
            bn_b_fp = bn_b_quantizer.get_repr()
        else:
            use_bn = False
            inter_quantizer = out_quantizer
            # inter_fp = (8,8,1)
            inter_fp = out_fp
            print(inter_fp,'vs', '(8,8,1)')
            bn_w = None
            bn_w_quantizer = None
            bn_w_fp = weight_fp
            bn_b = None
            bn_b_quantizer = None
            bn_b_fp = weight_fp
                
        rom_len = out_ch*(k_size[0]*k_size[1] + 2*use_bn + use_bias)
        rom_width = weight_fp[0]
        rom_size = rom_len*rom_width/8
        # rom_type = "distributed" if rom_size < 2*256 else "auto"
        # rom_type = "distributed" if rom_size < 2*256 else "block"
        # rom_type = "auto"
        rom_type = "block"
        # rom_type = "auto" if rom_size < 2*256 else "block"
        # rom_type = "auto"
        brom_per_width = (rom_width-1) // 36 +1
        single_brom_len = 1024*(36 // rom_width) if brom_per_width == 1 else 1024
        blocks_num = (rom_len-1) // single_brom_len +1
        blocks_num_addr = np.ceil(np.log2(blocks_num)).astype(int)
        rom_latency = 2 + blocks_num_addr
        
        config = {
            'in_shape':in_shape,
            'in_quant':in_quant,
            'out_shape':out_shape,
            'out_quant':out_fp,
            
            'width':in_shape[-1],
            'height':in_shape[-2],
            'ch_in':in_shape[-3],
            'ch_mul':out_shape[-3] // in_shape[-3],
            'padding_w':padding[0],
            'padding_h':padding[1],
            
            'in_bw':in_quant[0],
            'in_int':in_quant[1],
            'in_s':in_quant[2]*1,
            
            'weight':weight,
            'weight_q':weight_quantizer,
            'weight_bw':weight_fp[0],
            'weight_int':weight_fp[1],
            'weight_s':weight_fp[2]*1,
            
            'bias':bias,
            'bias_q':bias_quantizer,
            'bias_bw':bias_fp[0],
            'bias_int':bias_fp[1],
            'bias_s':bias_fp[2]*1,
            
            'inter_q':inter_quantizer,
            'inter_bw':inter_fp[0],
            'inter_int':inter_fp[1],
            'inter_s':inter_fp[2]*1,
            
            'bn_weight':bn_w,
            'bn_weight_q':bn_w_quantizer,
            'bn_weight_bw':bn_w_fp[0],
            'bn_weight_int':bn_w_fp[1],
            'bn_weight_s':bn_w_fp[2]*1,
            
            'bn_bias':bn_b,
            'bn_bias_q':bn_b_quantizer,
            'bn_bias_bw':bn_b_fp[0],
            'bn_bias_int':bn_b_fp[1],
            'bn_bias_s':bn_b_fp[2]*1,
            
            'out_q': out_quantizer,
            'out_bw':out_fp[0],
            'out_int':out_fp[1],
            'out_s':out_fp[2]*1,
            
            'use_bias': use_bias*1,
            'use_bn': use_bn*1,
            'use_relu': use_relu*1,
            
            # 'read_latency': 3,
            # 'write_latency': 3,
            # 'read_weight_latency': 5,
            # 'read_weight_latency': 2,
            'read_weight_latency': rom_latency,
            'single_brom_len': single_brom_len,
            'blocks_num': blocks_num,
            'rom_file_format': 'rom_'+name+'_%01d.mem',
            'groups': 32//out_fp[0],
            'rom_len': rom_len,
            'rom_type': rom_type,
            'type':'DWConv2d',
        }
        
        return config
    
    def update_parallelism(self, p):
        pass
        
    def DSP(self):
        use_bn = self.config['use_bn']
        return 9 + use_bn
    
    def BRAM(self):
        rom_len = self.config['rom_len']
        # rom_width = self.config['weight_bw']
        
        single_brom_len = 1024*2
        # blocks_num = int(math.floor(rom_len / single_brom_len + 0.5))
        blocks_num = int(math.floor(rom_len / single_brom_len))
        
        return blocks_num / 2
        # return self.config['blocks_num']
    
    def PARALLELISM(self):
        return 1    
    
    def MAP_CLKS(self):
        return self.out_channels*self.in_shape[1]*self.in_shape[2]

    def DEFAULT_MAP_CLK(self):
        return self.MAP_CLKS()

    def TYPE(self):
        return 'DW'
        
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        nof = self.out_shape[0] # num of filters
        now = 9 # num of weights in filter
        indices_nof = torch.arange(0,nof)
        indices_now = torch.arange(0,now)
        
        w = self.config['weight'].clone().reshape(nof,-1)
        w_q = self.config['weight_q']
        w_s = self.config['weight_s']
        qt = w_q(w)
        t = (qt[0]/qt[1]).to(torch.int8 if w_s else torch.uint8).to(torch.uint8)
        # inverse weights order
        t[:,indices_now] = torch.tensor(t.numpy()[:,::-1].copy())
        
        if self.config['use_bias']:
            b = self.config['bias'].clone().reshape(nof,1)
            b_q = self.config['bias_q']
            b_s = self.config['bias_s']
            qb = b_q(b)
            b = (qb[0]/qb[1]).to(torch.int8 if b_s else torch.uint8).to(torch.uint8)
            t = torch.cat([b, t],dim=1)
        if self.config['use_bn']:
            bn_w = self.config['bn_weight'].clone().reshape(nof,1)
            bn_w_q = self.config['bn_weight_q']
            bn_w_s = self.config['bn_weight_s']
            qbn_w = bn_w_q(bn_w)
            bn_w = (qbn_w[0]/qbn_w[1]).to(torch.int8 if bn_w_s else torch.uint8).to(torch.uint8)
            t = torch.cat([bn_w, t],dim=1)
        if self.config['use_bn']:
            bn_b = self.config['bn_bias'].clone().reshape(nof,1)
            bn_b_q = self.config['bn_bias_q']
            bn_b_s = self.config['bn_bias_s']
            qbn_b = bn_b_q(bn_b)
            bn_b = (qbn_b[0]/qbn_b[1]).to(torch.int8 if bn_b_s else torch.uint8).to(torch.uint8)
            t = torch.cat([bn_b, t],dim=1)
                
        ch_mul = self.config['ch_mul']
        mul_order = torch.cat([order.reshape(-1,1)*ch_mul+i for i in range(ch_mul)],
                              dim=1).reshape(-1)
        # change filters order to corelated with input channels order
        t[indices_nof,:] = t[mul_order,:]
        
        # reorder filters, because of multi-dw 
        ind_mul = indices_nof*ch_mul
        out_order = ind_mul // nof + ind_mul % nof
        t[indices_nof,:] = t[out_order,:]
        
        p = 1
        t_p = parallelize_weights(t.numpy(),
                                  parallelism=p,
                                  map_size=4)
        
        s = array_to_str(t_p,parallelism=p,sep='\n',width=2,f='%02x')[:-1]
        sbr = self.config['single_brom_len']
        batch_size = sbr*(p*2+1) # 2-hex chars, 1- newline
        
        for i in range(self.config['blocks_num']):
            batch_of_weights = s[i*batch_size:(i+1)*batch_size]
            # save to file
            with open(os.path.join(path,self.config['rom_file_format']%i),'w') as f:
                f.write(batch_of_weights)
                print("Saved memory file under:",
                    self.config['rom_file_format']%i)
        
        return out_order[mul_order] # apply also input order


class MFBlock(LayerBlock):

    def __init__(self, name:str, prev:LayerBlock) -> None:
        # align to multiplicity of 5 - single anchor description size
        in_sh = ((prev.out_shape[0] // 5) * 5,) + prev.out_shape[1:]
        
        super().__init__(name, 
                         in_sh, 
                         (1,1,8), 
                         prev.out_quant,
                         prev.out_quant,
                         {}
                         )
        cfg = self.extract_config()
        self.config.update(cfg)
    
    def extract_config(self):
        return {
                'ch_in':self.in_shape[0],
                'height':self.in_shape[1],
                'width':self.in_shape[2],
                'bit_width':self.in_quant[0],
                'signed':self.in_quant[2],
                'type':'MaxFinder'
                }

    def update_parallelism(self, p):
        pass
        
    def DSP(self):
        return 0
    
    def BRAM(self):
        return 0
    
    def PARALLELISM(self):
        return 1
    
    def DEFAULT_MAP_CLK(self):
        return self.MAP_CLKS()
    
    def TYPE(self):
        return 'MF'
        
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        return torch.arange(0,self.out_shape[0])


class OLBlock(LayerBlock):

    def __init__(self, name:str, prev:LayerBlock) -> None:
        
        super().__init__(name, 
                         prev.out_shape, 
                         prev.out_shape, 
                         prev.out_quant,
                         prev.out_quant,
                         {}
                         )
        cfg = self.extract_config()
        self.config.update(cfg)
    
    def extract_config(self):
        return {'size':self.in_shape[0]*self.in_shape[1]*self.in_shape[2],
                'type':'OutputLayer'
                }

    def update_parallelism(self, p):
        pass
        
    def DSP(self):
        return 0
    
    def BRAM(self):
        return 0
    
    def PARALLELISM(self):
        return 1

    def DEFAULT_MAP_CLK(self):
        return self.MAP_CLKS()
    
    def TYPE(self):
        return 'OL'
        
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        # return torch.arange(0,self.out_shape[0])
        return None


class ILBlock(LayerBlock):

    def __init__(self, name:str, input_shape, m:qnn.QuantIdentity) -> None:
        
        q_out = m.act_quant.fused_activation_quant_proxy.tensor_quant
        
        super().__init__(name, 
                         input_shape[-3:], 
                         input_shape[-3:], 
                         (8,0,False),
                        #  q_out.get_repr()
                         (8,0,False)
                         )
        self.config.update(self.extract_config(m))
    
    def extract_config(self, m:qnn.QuantIdentity):
        return {'groups':4,
                'width':self.in_shape[2],
                'height':self.in_shape[1],
                'channels':self.in_shape[0],
                'bit_width':self.in_quant[0],
                'type':'InputLayer'
                }

    def update_parallelism(self, p):
        pass
        
    def DSP(self):
        return 0
    
    def BRAM(self):
        return 0
    
    def PARALLELISM(self):
        return 1
    
    def DEFAULT_MAP_CLK(self):
        # one clk -> 4 values
        return self.MAP_CLKS() // 4

    def TYPE(self):
        return 'IL'
        
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        return torch.arange(0,self.out_shape[0])


# jinja filters
def layers_for_state(layers, state:int):
    ls = []
    for i, L in enumerate(layers):
        if  i%4 == state:
            ls.append(i)
    return ls

def as_array_elems(indices, array:str, ind=None, sig=None):# array - formatable str
    a = [array.format(i) for i in indices]
    if ind is not None and ind in indices:
        a.append(sig)
    
    return a
    
def join_elems(elems, connector:str=' && ', alternative='1'):
    if len(elems) == 0:
        return alternative
    return connector.join(elems)


def get_rams_config(layers_blocks):
    # in_sh = layers_blocks[0].out_shape
    # in_ram = {
    #          "BYTE_LEN":in_sh[0]*in_sh[1]*in_sh[2],
    #          "name":"in_ram",
    #          "BLOCKS_NUM":((in_sh[0]*in_sh[1]*in_sh[2]-1)//4+1-1)//1024+1,
    #          "file_format":"RAM_in_ram_%0d.mem"
    #          }
    rams = []
    # iterate over every 4 layers without last one
    cntr = 0
    for i in range(0, len(layers_blocks)-1,4):
        min_L = i
        max_L = min(min_L+4,len(layers_blocks)-1)
        LL = layers_blocks[min_L:max_L]
        # get layers out sizes
        ll = [l.out_shape for l in LL]
        ll = [sh[0]*sh[1]*sh[2] for sh in ll]
        # get even sizes
        l0 = ll[::2]
        l1 = ll[1::2]
        
        if l0:
            s0 = max(l0)
            rams.append({
             "BYTE_LEN":s0,
             "name":"ram_"+str(cntr)+'_0',
             "BLOCKS_NUM":((s0-1)//4+1-1)//1024+1,
             "file_format":"RAM_"+str(cntr)+"_0_%0d.mem"
             })
        if l1:
            s1 = max(l1) if l1 else 0
            rams.append({
             "BYTE_LEN":s1,
             "BLOCKS_NUM":((s1-1)//4+1-1)//1024+1,
             "name":"ram_"+str(cntr)+'_1',
             "file_format":"RAM_"+str(cntr)+"_1_%0d.mem"
             })

        cntr += 1
    
    rams_lenghts = [(R['BYTE_LEN']-1)//4+1 for R in rams]
    rams_brams = [(l-1)//1024+1 for l in rams_lenghts]
    rams_tree_depth = [ int(math.ceil(math.log2(brams))) for brams in rams_brams]
    print("RAMs BRAMs",rams_brams)
    print("SUM OF RAMs BRAMS",sum(rams_brams))
    write_latency = max(rams_tree_depth) + 2 + 1 # 2-in BRAM, 1- port mux
    read_latency = write_latency+2
    print("Write latency =",write_latency)
    print("Read latency =",read_latency)
    
    return rams, write_latency, read_latency, rams_brams


def get_layers_config(model:torch.nn.Module, input_shape:tuple):
    # modules without anchor mul
    layers = []
    for m in model.modules():
        # take only first instance
        if not layers and isinstance(m, qnn.QuantIdentity):
            layers.append(m)
        # one of these cannot be first
        elif layers and isinstance(m, (PWConv2d, DWConv2d)):
            layers.append(m)
    
    limit_of_layers = len(layers)
    layers_blocks = []
    dsp_sum = 0
    bram_sum = 0
    t = torch.rand(input_shape)
    # iterate over all layers
    for i, L in enumerate(layers[:limit_of_layers]):
        is_last = i+1 == len(layers)
        # get nput shape
        in_shape = t.shape
        # pass through layer
        t = L(t)[0]
        
        if isinstance(L, qnn.QuantIdentity):
            prev = ILBlock("layer_"+str(i)+"_il", in_shape, L)
        elif isinstance(L, PWConv2d):
            prev = PWBlock("layer_"+str(i)+"_pw",prev, L, is_last)    
        elif isinstance(L, DWConv2d):
            prev = DWBlock("layer_"+str(i)+"_dw",prev,  L)
        else:
            raise RuntimeError("Unsupported type")

        layers_blocks.append(prev)
        print(prev.name, '-> DSP:', prev.DSP(), 'BRAM:', prev.BRAM(), 'P:', prev.PARALLELISM())
        dsp_sum += prev.DSP()
        bram_sum += prev.BRAM()
    
    # max finder layer
    prev = MFBlock("layer_"+str(len(layers_blocks))+'_mf', prev)
    layers_blocks.append(prev)
    print(prev.name, '-> DSP:', prev.DSP(), 'BRAM:', prev.BRAM(), 'P:', prev.PARALLELISM())
    # final output layer
    prev = OLBlock("layer_"+str(len(layers_blocks))+'_ol',prev)
    layers_blocks.append(prev)
    print(prev.name, '-> DSP:', prev.DSP(), 'BRAM:', prev.BRAM(), 'P:', prev.PARALLELISM())
    
    print('SUM of DSP48E2:', dsp_sum)
    print('SUM of BRAM36:', bram_sum)
    
    for b in layers_blocks:
        print(b.config['name'],b.config['type'])
    
    return layers_blocks


def EXEC_LEN(CLKS):
    FILL = np.array([0 for i in range((4-(len(CLKS)-1)%4)%4)])
    L = np.concatenate([CLKS[0:1],np.array([0,0,0]),CLKS[1:],FILL])
    L = L.reshape((-1,4))
    T = np.max(L,axis=1)
    return np.sum(T)


def torch_loss(iter,prev_p, parallelism, layers_blocks, DSPS, BRAMS, CLKS, PARALLELISM, indices_p, changable, dsp_limit, bram_limit):
    B = []
    D = []
    C = []
    cntr = 0
    for i, l in enumerate(layers_blocks):
        if changable[i]:
            bram, dsp, clks = l.get_torch_state(parallelism[cntr])
            B.append(bram)
            D.append(dsp)
            C.append(clks)
            with torch.no_grad():
                PARALLELISM[i] = parallelism[cntr].to(torch.int).item()
            cntr += 1

        else:
            B.append(BRAMS[i])
            D.append(DSPS[i])
            C.append(CLKS[i])
    
    FILL = torch.tensor(0.0)
    CC = [FILL]
    CC.extend(C[0:1])
    CC.append(FILL)
    CC.append(FILL)
    CC.extend(C[1:])
    end_fill_len = 4 - len(CC)%4
    for i in range(end_fill_len):
        CC.append(FILL)
        
    CC = torch.stack(CC).reshape(-1,4)
    CC_norm = CC / torch.max(CC,dim=0)[0]
    M = torch.softmax(CC_norm,dim=0)
    M = torch.softmax(M,dim=0)
    M = torch.sum(CC_norm*M)
    # time loss
    t_e = M
    
    dsp_num = torch.sum(torch.stack(D))
    bram_num = torch.sum(torch.stack(B))
    
    dsp_mul = 5
    bram_mul = 5
    dsp_over = torch.exp(dsp_mul*(dsp_num/dsp_limit - 1.0))
    bram_over = torch.exp(bram_mul*(bram_num/bram_limit - 1.0))
    # dsp_under = 0.1*torch.exp(dsp_mul*(1.0 - dsp_num/dsp_limit))
    # bram_under = 0.1*torch.exp(bram_mul*(1.0 - bram_num/bram_limit))
    dsp_under = 0.0
    bram_under = 0.0
    
    loss = 5*t_e + (dsp_over + dsp_under + bram_over + bram_under)/4
    
    with torch.no_grad():
        DELTA = [p1-p2 for p1,p2 in zip(PARALLELISM,prev_p)]
        preaty_print("Iter "+str(iter),
                    DELTA=DELTA,
                    PARALLELISM=PARALLELISM,
                    BRAMS=B,
                    DSPS=D,
                    CHANGABLE=changable,
                    CLKS=[c/100 for c in C],
                    DSPs=[dsp_num],
                    BRAMs=[bram_num],
                    DSP_under=[dsp_under],
                    DSP_over=[dsp_over],
                    BRAM_under=[bram_under],
                    BRAM_over=[bram_over],
                    BRAM_limit=[bram_limit],
                    T=[M],
                    T_e=[t_e],
                    LOSS=[loss],
                    )
        
    return loss


def torch_optim(layers_blocks, bram_limit=51, dsp_limit=360, iter_max=50):
    with torch.no_grad():
        DSP = [] # [torch.tensor(l.DSP(), dtype=torch.float32) for l in layers_blocks]
        BRAM = [] # [torch.tensor(l.BRAM(), dtype=torch.float32) for l in layers_blocks]
        CLKS = [] # [torch.tensor(l.MAP_CLKS(), dtype=torch.float32) for l in layers_blocks]
        PARALLELISM = [] # [torch.tensor(l.PARALLELISM(),dtype=torch.float32) for l in layers_blocks]
        
        for L in layers_blocks:
            p = L.PARALLELISM()
            p = torch.tensor(p, dtype=torch.float32)
            b, d, c = L.get_torch_state(p)
            DSP.append(d.to(torch.float32))
            BRAM.append(b.to(torch.float32))
            CLKS.append(c.to(torch.float32))
            PARALLELISM.append(p.to(torch.float32))
    
    indices_p = [i for i, l in enumerate(layers_blocks) if l.CHANGABLE]
    changable = [l.CHANGABLE for l in layers_blocks]
    
    from brevitas.core.function_wrapper.ops_ste import ceil_ste
    p = [torch.nn.Parameter(torch.log(PARALLELISM[i]), requires_grad=True) for i in indices_p]
    opt = torch.optim.Adam(p,lr=0.01)
    prev_p = PARALLELISM.copy()
    for i in range(iter_max):
        # prev_p = PARALLELISM.copy()
        loss = torch_loss(i,prev_p, [ceil_ste(torch.exp(pp)) for pp in p], layers_blocks, DSP, BRAM, CLKS, PARALLELISM, indices_p, changable, dsp_limit, bram_limit)
        loss.backward(retain_graph=True)
        opt.step()
        for pp in p:
            print(pp.grad, end='')
        print()
        opt.zero_grad()
        prev_p = PARALLELISM.copy()
        input("NEXT...\n")
        
    with torch.no_grad():
        loss = torch_loss(i,prev_p, [ceil_ste(torch.exp(pp)) for pp in p], layers_blocks, DSP, BRAM, CLKS, PARALLELISM, indices_p, changable, dsp_limit, bram_limit)


def preaty_print(title,**kwargs):
    ml = 0
    mn = 0
    
    for n,a in kwargs.items():
        mn = max(mn,len(n))
        ml = max(ml,len(a))
    
    entry_f = '|{:^8.3f}'
    entry_filler = '|{:8}'
    key_f = ' {:'+str(mn)+'} '
    line = '-'*((8+1)*ml+mn+1+2+1)
    T = ('|{:^'+str(len(line))+'}|').format(title)
    
    print(line)
    print(T)
    print(line)
    for n,a in kwargs.items():
        s = '|'
        s += key_f.format(n)
        for i in a:
            v = i.cpu().item() if isinstance(i, torch.torch.Tensor) else i
            s += entry_f.format(i)
        
        for i in range(ml-len(a)):
            s += entry_filler.format('')
        
        s += '|'
        print(s)
        print(line)
    

def optimize(layers_blocks:List[LayerBlock], rams_brams, iter=500):
    
    # torch_optim(layers_blocks,
    #             213-sum(rams_brams),
    #             360,
    #             iter)
    
    layers_configs = [L.config for L in layers_blocks]
    
    return layers_configs


def cycles_time(layers_blocks:List[LayerBlock]):
    times = [L.DEFAULT_MAP_CLK() for L in layers_blocks]
    # types = [L.TYPE() for L in layers_blocks]
    print("Normalized times of execution")
    M = max(times)
    f = '{:2} {:5.4f}'
    for i,L in enumerate(layers_blocks):
        end = '\\\\\\hline\n' if (i+1)%4 == 0 else ' & '
        s = f.format(L.TYPE(),L.DEFAULT_MAP_CLK()/M)
        if i%4 == 0:
            print(i//4,'& ', end='')
        print(s, end=end)
    
    print()
    

from jinja2 import Environment, select_autoescape, FileSystemLoader


def create_hw_from_sw(model:torch.nn.Module,
                      input_shape = (1,3,112,208),
                      init_state=1,
                      rom_dir='./',
                      dst_file_path='./LN.sv',
                      update=True,
                      debug=False
                      ):
    model = model.eval()
    
    layers_blocks = get_layers_config(model, input_shape)
    rams, write_latency, read_latency, rams_brams = get_rams_config(layers_blocks)
    
    layers_configs = optimize(layers_blocks, rams_brams)
    rams, write_latency, read_latency, rams_brams = get_rams_config(layers_blocks)
    
    cycles_time(layers_blocks)
    
    # exit()
    env = Environment(
                      loader = FileSystemLoader('.'),
                      autoescape = select_autoescape()
                      )
    
    env.filters['len'] = len
    env.filters['enumerate'] = enumerate
    env.filters['for_state'] = layers_for_state
    env.filters['as_array_elems'] = as_array_elems
    env.filters['join_elems'] = join_elems
    
    template = env.get_template("LN_template.sv-jinja")
    LN_acc = template.render(layers=layers_configs,
                             rams=rams, 
                             DEBUG=debug, 
                             write_latency=write_latency, 
                             read_latency=read_latency,
                             init_state=init_state)
    
    if not update:
        return rams
    
    # create file with code
    with open(dst_file_path,'w') as f:
        f.write(LN_acc)
    
    with torch.no_grad():
        # create files with memories
        order = torch.arange(0,3, dtype=torch.long)
        path = rom_dir
        for L in layers_blocks:
            L:LayerBlock = L
            order = L.generate(path, order)
    
    return rams

if __name__ == "__main__":
    
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--weights', required=True)
    parser.add_argument('--rom_dir', default='./HW/LittleNetAcc/LittleNetAcc.srcs/sources_1/imports/memories')
    parser.add_argument('--dst_sv_file', default='./HW/LittleNetAcc/LittleNetAcc.srcs/sources_1/imports/new/little_net_acc.sv')
    
    args = parser.parse_args()
    sd = torch.load(args.weights, map_location=torch.device('cpu'))
    
    networks.SeparableConv2D.QUANT_BEFORE_BN = True

    qin = quantizers.generalized_auto_fxp(8,8,0.1,
                                          round_mode='floor',
                                          max_bit_width=8,
                                          min_bit_width=7.6,
                                          trainable_bit_width=False,
                                          trainable_scale=False,
                                          trainable_signed=False, 
                                          dst='act')
    
    qw = quantizers.generalized_auto_fxp(8,7,0.7,
                                          round_mode='round',
                                          max_bit_width=8,
                                          min_bit_width=4,
                                          trainable_bit_width=True,
                                          trainable_scale=True,
                                          trainable_signed=True, 
                                          dst='weight')
    
    qb = quantizers.generalized_auto_fxp(8,7,0.7,
                                          round_mode='round',
                                          max_bit_width=8,
                                          min_bit_width=4,
                                          trainable_bit_width=True,
                                          trainable_scale=True,
                                          trainable_signed=True, 
                                          dst='bias')
    
    qa = quantizers.generalized_auto_fxp(8,7,0.7,
                                          round_mode='floor',
                                          max_bit_width=8,
                                          min_bit_width=4,
                                          trainable_bit_width=True,
                                          trainable_scale=True,
                                          trainable_signed=True, 
                                          dst='act')
    
    model = LittleNet7(3,qin,(qw,None,qa,qb),(qw,None,qa,qb))
    model.load_state_dict(sd)
    model.layers[0].act_quant.fused_activation_quant_proxy.tensor_quant = qin.tensor_quant
    
    # debug=False
    debug=True
    update = True
    # update = False
    in_sh = (112,208,3)
    # in_sh = (1*16,3*16,3)
    init_state = '10'
    
    rams_config = create_hw_from_sw(model, (1,3,)+in_sh[:2],
    # create_hw_from_sw(model, (1,3,32,32),
                      rom_dir=args.rom_dir,
                      init_state=init_state,
                      dst_file_path=args.dst_sv_file,
                      update=update,
                      debug=debug
                      )
    # exit()
    
    # update = True
    
    data = cv.imread("img_0000.png")    
    # data = cv.imread("img_0001.png")
    # data = cv.imread("img_0002.png")
    data_ch_last = data.copy()
    
    torch.set_printoptions(edgeitems=512,linewidth=2000)
    np.set_printoptions(edgeitems=112*208//2,linewidth=5*2000)
    data = data.reshape((-1,3)).T.copy()
    data = data.reshape((1,3)+in_sh[:2])
    print(data.flatten()[:10])
    data = torch.from_numpy(data).clone()
    # print(data)
    data = data.to(torch.float32) / 256
    
    t = data
    tt = torch.uint8
    state_offset = {"1":0, "4":1, "7":2, "10":3}[init_state]
    rams_inits = []
    layers_outputs = []
        
    print_orignal = print
    cn = 0
    def p(*args,**kw):
        pass
    
    print = p
    order = np.arange(0,3)
    for i, m in enumerate(model.layers):
        cn += 1
        sd = dir(model.layers[i])
        sdc = None
        if 'conv_dw' in sd: 
            sdc = m.conv_dw
        if 'conv_pw' in sd: 
            sdc = m.conv_pw
        
        sdbn = None
        if 'dw_bn' in sd: 
            sdbn = m.dw_bn.bn
        if 'pw_bn' in sd: 
            sdbn = m.pw_bn.bn
        
        if sdc:
                print("weight")
                q = sdc.quant_weight()
                if q:
                    print((q[0]/q[1]).to(torch.int).numpy().reshape((q.shape[0],-1)))
                print("bias")
                q = sdc.quant_bias()
                if q:
                    print((q[0]/q[1]).to(torch.int).numpy().reshape((q.shape[0],-1)))
        if sdbn:
                print("bn")
                print("weight")
                q = sdbn.quant_weight()
                if q:
                    print((q[0]/q[1]).to(torch.int).numpy().reshape((q.shape[0],-1)))
                print("bias")
                q = sdbn.quant_bias()
                if q:
                    print((q[0]/q[1]).to(torch.int).numpy().reshape((q.shape[0],-1)))
        
        if 'layers' in dir(m):
            for L in m.layers:
                t = L(t)
                print(type(L), i, "INTERMEDIATE")
                print((t[0]/t[1]).to(torch.int64))
        else:
            t = m(t)
        
        qt = t[0] / t[1]
        qt = qt.to(tt)
        tt = torch.int8
        if isinstance(m,networks.DWConv2d):
            mul = m.out_channels // m.in_channels
            tmp = [order*mul+i for i in range(mul)]
            order = np.concatenate(tmp,axis=0)
        
        elif isinstance(m,networks.PWConv2d):
            order = np.arange(m.out_channels)
            
        
        inter_map = qt.clone().to(torch.int8).to(torch.uint8).numpy()[0,...]
        if isinstance(m,networks.DWConv2d):
            inter_map = inter_map[order,...]
        
        layers_outputs.append(inter_map)
        
        print("OUTPUT", i)
        rqt = qt.numpy().reshape((qt.shape[1],-1))
        rqt = rqt[order,...]
        with open("ref/layer_"+str(i)+".txt", 'w') as f:
            templ = '{:}, {:}\n'
            for a,v in enumerate(rqt.flatten()):
                f.write(templ.format(a,v))
            
        print("OUTPUT END", i)
        print()
        
        if isinstance(m, networks.PWConv2d) and m.out_channels == 15:
            qt = qt.reshape(5,-1)
            pos = torch.argmax(qt[0,:])
            desc = qt[:,pos].numpy()
            print_orignal(pos,desc)
            print_orignal(t[0].reshape(5,-1)[:,pos].detach().numpy())
            pos = np.uint32(pos)
            # print(pos >> 8, pos >> 16, pos >> 24)
            pos = np.unravel_index(pos,(3, 7, 13))
            print_orignal(pos)
            mf_out = np.array([*(desc.flatten()[1:].tolist()),desc.flatten()[0],*pos])
            layers_outputs.append(mf_out.astype(np.uint8))
            break
            
        print()
    print = print_orignal
    
    
    writer = [0 for i in range(len(rams_config))]
    # one processing cycle
    for s in range(4):
        cs = (4 + s+state_offset) %4 # start from init state 
        for i, l in enumerate(layers_outputs):
            if cs == i%4:
                macro_blk = i//4
                in_blk = i%2
                ram_idx = macro_blk*2+in_blk
                writer[ram_idx] = i
            
    rams_inits = []
    for src in writer:
        rams_inits.append(layers_outputs[src])
    
    if not update:
        exit()
    d = args.rom_dir
    for R, V in zip(rams_config,rams_inits):
        V = V.flatten().copy()
        vv = np.concatenate([V,np.zeros((4-V.size % 4,),dtype=V.dtype)],axis=0)
        ram_data = vv.reshape((-1,4))[:,::-1]
        p = 4
        s = array_to_str(ram_data,parallelism=p,sep='\n',width=2,f='%02x')
        sbr = 1024
        batch_size = sbr*(p*2+1) # 2-hex chars, 1- newline
        
        print(R)
        for i in range(R['BLOCKS_NUM']):
            batch_of_ram_data = s[i*batch_size:(i+1)*batch_size]
            # save to file
            with open(os.path.join(d,R['file_format']%i),'w') as f:
                f.write(batch_of_ram_data)
                print("Saved memory file under:",
                    R['file_format']%i)
    
    data = data_ch_last
    data = data.reshape((-1,4)).astype(np.uint32)
    data = data[:,3] << 3*8 | data[:,2] << 2*8 | data[:,1] << 8 | data[:,0]
    ds = array_to_str(data,parallelism=1,sep='\n',width=8,f='%08x')[:-1]
    
    with open(os.path.join(d,'../../../../sim_memory_input.mem'),'w') as f:
        f.write(ds)