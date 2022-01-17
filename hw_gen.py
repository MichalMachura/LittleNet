import torch, brevitas
import brevitas.nn as qnn
from typing import List
import os, sys
sys.path.append('TRAIN')

import TRAIN
from TRAIN import networks
from TRAIN.networks import LittleNet7, PWConv2d, DWConv2d
from TRAIN import quantizers 


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
    

class PWBlock(LayerBlock):

    def __init__(self, name:str, prev_layer:LayerBlock, m:PWConv2d) -> None:
        config = self.extract_config(prev_layer, m)
        super().__init__(name,
                         config['in_shape'],
                         config['out_shape'],
                         config['in_quant'],
                         config['out_quant'],
                         config
                         )
        
    def extract_config(self,prev_layer:LayerBlock, m:PWConv2d):
        
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
            inter_fp = (8,8,1)
            bn_w = None
            bn_w_quantizer = None
            bn_w_fp = (8,8,1)
            bn_b = None
            bn_b_quantizer = None
            bn_b_fp = (8,8,1)
        
        # paralellism for smaller iterations and better bram utilization
        parallelism = 18 if (out_ch-1)//18+1 < (out_ch-1)//16+1 else 16
        parallelism = min(parallelism, out_ch)
        
        rom_len = (in_shape[0]+use_bias+2*use_bn)*((out_ch-1)//parallelism+1)
        rom_width = parallelism*weight_fp[0]
        rom_size = rom_len*rom_width/8
        rom_type = "distributed" if rom_size < 129 else "block"
        
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
            'in_s':in_quant[2],
            
            'weight':weight,
            'weight_q':weight_quantizer,
            'weight_bw':weight_fp[0],
            'weight_int':weight_fp[1],
            'weight_s':weight_fp[2],
            
            'bias':bias,
            'bias_q':bias_quantizer,
            'bias_bw':bias_fp[0],
            'bias_int':bias_fp[1],
            'bias_s':bias_fp[2],
            
            'inter_q':inter_quantizer,
            'inter_bw':inter_fp[0],
            'inter_int':inter_fp[1],
            'inter_s':inter_fp[2],
            
            'bn_weight':bn_w,
            'bn_weight_q':bn_w_quantizer,
            'bn_weight_bw':bn_w_fp[0],
            'bn_weight_int':bn_w_fp[1],
            'bn_weight_s':bn_w_fp[2],
            
            'bn_bias':bn_b,
            'bn_bias_q':bn_b_quantizer,
            'bn_bias_bw':bn_b_fp[0],
            'bn_bias_int':bn_b_fp[1],
            'bn_bias_s':bn_b_fp[2],
            
            'out_q': out_quantizer,
            'out_bw':out_fp[0],
            'out_int':out_fp[1],
            'out_s':out_fp[2],
            
            'use_bias': use_bias*1,
            'use_bn': use_bn*1,
            'use_relu': use_relu*1,
            'use_mp': use_mp*1,
            'ceil_mode': ceil_mode*1,
            'parallelism':parallelism,
            'use_maxfinder': 0,
            'anchors': out_ch//5,
            'read_latency': 2,
            'read_weight_latency': 2,
            'write_latency': 2,
            'groups': 32//out_fp[0],
            'rom_len': rom_len,
            'rom_type':rom_type,
            'type':'PWConv2d',
        }
        
        return config
    
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        return order

class DWBlock(LayerBlock):
    
    def __init__(self, name:str, prev_layer:LayerBlock, m:DWConv2d) -> None:
        config = self.extract_config(prev_layer, m)
        super().__init__(name,
                         config['in_shape'],
                         config['out_shape'],
                         config['in_quant'],
                         config['out_quant'],
                         config
                         )
    
    def extract_config(self,prev_layer:LayerBlock, m:DWConv2d):

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
            inter_fp = (8,8,1)
            bn_w = None
            bn_w_quantizer = None
            bn_w_fp = (8,8,1)
            bn_b = None
            bn_b_quantizer = None
            bn_b_fp = (8,8,1)
                
        rom_len = out_ch*(k_size[0]*k_size[1] + 2*use_bn + use_bias)
        rom_width = weight_fp[0]
        rom_size = rom_len*rom_width/8
        rom_type = "distributed" if rom_size < 129 else "block"
        
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
            'in_s':in_quant[2],
            
            'weight':weight,
            'weight_q':weight_quantizer,
            'weight_bw':weight_fp[0],
            'weight_int':weight_fp[1],
            'weight_s':weight_fp[2],
            
            'bias':bias,
            'bias_q':bias_quantizer,
            'bias_bw':bias_fp[0],
            'bias_int':bias_fp[1],
            'bias_s':bias_fp[2],
            
            'inter_q':inter_quantizer,
            'inter_bw':inter_fp[0],
            'inter_int':inter_fp[1],
            'inter_s':inter_fp[2],
            
            'bn_weight':bn_w,
            'bn_weight_q':bn_w_quantizer,
            'bn_weight_bw':bn_w_fp[0],
            'bn_weight_int':bn_w_fp[1],
            'bn_weight_s':bn_w_fp[2],
            
            'bn_bias':bn_b,
            'bn_bias_q':bn_b_quantizer,
            'bn_bias_bw':bn_b_fp[0],
            'bn_bias_int':bn_b_fp[1],
            'bn_bias_s':bn_b_fp[2],
            
            'out_q': out_quantizer,
            'out_bw':out_fp[0],
            'out_int':out_fp[1],
            'out_s':out_fp[2],
            
            'use_bias': use_bias*1,
            'use_bn': use_bn*1,
            'use_relu': use_relu*1,
            
            'read_latency': 2,
            'read_weight_latency': 2,
            'write_latency': 2,
            'groups': 32//out_fp[0],
            'rom_len': rom_len,
            'rom_type': rom_type,
            'type':'DWConv2d',
        }
        
        return config
    
    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        return order


class ILBlock(LayerBlock):

    def __init__(self, name:str, input_shape, m:qnn.QuantIdentity) -> None:
        
        q_out = m.act_quant.fused_activation_quant_proxy.tensor_quant
        
        super().__init__(name, 
                         input_shape[-3:], 
                         input_shape[-3:], 
                         (8,8,False),
                         q_out.get_repr())
        self.config = self.extract_config(m)
    
    def extract_config(self, m:qnn.QuantIdentity):
        return {'groups':4,
                'write_latency':2,
                'width':self.in_shape[2],
                'height':self.in_shape[1],
                'channels':self.in_shape[0],
                'bit_width':self.in_quant[0],
                'type':'InputLayer'
                }

    def generate(self, path:str, order:torch.tensor) -> torch.tensor:
        return torch.arange(0,self.out_shape[0])

# jinja filters
def layers_for_state(layers, state:int):
    ls = []
    for i, L in enumerate(layers):
        if  (i+(1-3)*(i!=0))%4 == state:
            ls.append(i)
    return ls

def as_array_elems(indeces, array:str, ind=None, sig=None):# array - formatable str
    a = [array.format(i) for i in indeces]
    if ind is not None and ind in indeces:
        a.append(sig)
    
    return a
    
def join_elems(elems, connector:str=' && ', alternative='1'):
    if len(elems) == 0:
        return alternative
    return connector.join(elems)


def get_rams_config(layers_blocks):
    in_sh = layers_blocks[0].out_shape
    in_ram = {
             "BYTE_LEN":in_sh[0]*in_sh[1]*in_sh[2],
             "name":"in_ram",
             "layers_write":[0],
             "layers_read":[1],
             }
    rams = [in_ram]
    # iterate over every 4 layers without last one
    cntr = 1
    for i in range(0, len(layers_blocks)-1,4):
        min_L = i+1
        max_L = min(min_L+4,len(layers_blocks)-1)
        LL = layers_blocks[min_L:max_L]
        # get layers out sizes
        ll = [l.out_shape for l in LL]
        ll = [sh[0]*sh[1]*sh[2] for sh in ll]
        # get even sizes
        l0 = ll[::2]
        l1 = ll[1::2]
        
        l_num = max_L-min_L
        out_from = (l_num+1) % 2
        if l0:
            s0 = max(l0)
            rams.append({
             "BYTE_LEN":s0,
             "name":"ram_"+str(cntr)+'_0',
             "layers_write":[j for j in range(min_L,max_L,2)],
             "layers_read":[j for j in range(min_L+1,max_L,2)],
             })
            if out_from == 0:
                rams[-1]['layers_read'].append(max_L)
        if l1:
            s1 = max(l1) if l1 else 0
            rams.append({
             "BYTE_LEN":s1,
             "name":"ram_"+str(cntr)+'_1',
             "layers_write":[j for j in range(min_L+1,max_L,2)],
             "layers_read":[j for j in range(min_L+2,max_L,2)],
             })
            if out_from == 1:
                rams[-1]['layers_read'].append(max_L)

        cntr += 1
    
    return rams


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
    
    layers_blocks = []
    t = torch.rand(input_shape)
    # itreate over all layers
    for i, L in enumerate(layers):
        # get nput shape
        in_shape = t.shape
        # pass through layer
        t = L(t)[0]
        
        if isinstance(L, qnn.QuantIdentity):
            prev = ILBlock("il_"+str(i), in_shape, L)
        elif isinstance(L, PWConv2d):
            prev = PWBlock("pw_"+str(i),prev, L)    
        elif isinstance(L, DWConv2d):
            prev = DWBlock("dw_"+str(i),prev,  L)
        else:
            raise RuntimeError("Unsupported type")
        
        layers_blocks.append(prev)

    # yolo layer config    
    layers_blocks[-1].config['use_maxfinder'] = 1
    layers_blocks[-1].config['parallelism'] = 5
    layers_blocks[-1].config['groups'] = 1
    
    layers_configs = [L.config for L in layers_blocks]
    
    return layers_blocks, layers_configs


from jinja2 import Environment, select_autoescape, FileSystemLoader


def create_hw_from_sw(model:torch.nn.Module,
                      input_shape = (1,3,112,208),
                      rom_dir='./',
                      dst_file_path='./LN.sv',
                      ):
    layers_blocks, layers_configs = get_layers_config(model, input_shape)
    
    rams = get_rams_config(layers_blocks)
    
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
    LN_acc = template.render(layers=layers_configs,rams=rams)
    
    # create file with code
    with open(dst_file_path,'w') as f:
        f.write(LN_acc)
    
    # create files with memories
    order = torch.arange(0,3, dtype=torch.long)
    path = rom_dir
    for L in layers_blocks:
        L:LayerBlock = L
        order = L.generate(order, path)

if __name__ == "__main__":

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
    create_hw_from_sw(model, (1,3,112,208))
    