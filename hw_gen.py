import torch, brevitas
import brevitas.nn as qnn
from typing import List
import os, sys
sys.path.append('TRAIN')

import TRAIN
from TRAIN import networks
from TRAIN.networks import LittleNet7, PWConv2d, DWConv2d
from TRAIN import quantizers 


"""
external_signals = {
                    'in':{
                        'sig_name':WIDTH,
                        },
                    'out':{
                        'sig_name':WIDTH,
                        },
                    }
"""


modules_names = []
signals_names = []


class GenBlk:
    
    def external_signals(self)->dict:
        ...
    
    def generate(self) -> str:
        ...
    
    def get_suffix(self):
        ...
        
    def get_memory_read(self, key_prefix=''):
        "{clk:'',address:'',data:'', en:''}"
        raise RuntimeError('Not implemented - should return memory interface ports')
    
    def get_memory_write(self, key_prefix=''):
        "{clk:'',address:'',data:'', wen:'', en:''}"
        raise RuntimeError('Not implemented - should return memory interface ports')


class LayerBlock(GenBlk):
    
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
    
    def get_suffix(self):
        return '_'+self.name

    def get_memory_write(self, key_prefix=''):
        sx = self.get_suffix()
        signals = {
            key_prefix+'en': 'write_en'+sx,
            key_prefix+'address': 'write_address'+sx,
            key_prefix+'data': 'write_data'+sx,
            key_prefix+'wen': 'write_wen'+sx,
        }
        return signals

    def get_memory_read(self, key_prefix=''):
        sx = self.get_suffix()
        signals = {
            key_prefix+'en': 'read_en'+sx,
            key_prefix+'address': 'read_address'+sx,
            key_prefix+'data': 'read_data'+sx,
        }
        return signals
        
    def get_weight_memory_read(self, key_prefix=''):
        sx = self.get_suffix()
        signals = {
            # key_prefix+'clk': 'rom_clk'+sx,
            key_prefix+'en': 'rom_en'+sx,
            key_prefix+'address': 'rom_address'+sx,
            key_prefix+'data': 'rom_data'+sx,
        }
        return signals


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
            'rom_type':rom_type
        }
        
        return config
        
    TEMPL = """
    wire {clk}, {reset}, {enable}, {finished};
    wire [7:0] {read_data};
    wire [{parallelism}*{weight_bw}:0] {rom_data};
    wire [31:0] {write_data};
    wire [32-1:0] {read_address},{rom_address},{write_address};
    wire {read_en},{rom_en},{write_en} = {enable},{write_wen};
    
    PointwiseConv2dUnit#(
        .IN_WIDTH({width}),
        .IN_HEIGHT({height}),
        .IN_CHANNELS({ch_in}),
        .OUT_CHANNELS({ch_out}),
        .USE_BIAS({use_bias}),
        .USE_BN({use_bn}),
        .USE_RELU({use_relu}),
        .USE_MAXPOOL({use_mp}),
        .USE_MAXPOOL_CEIL_MODE({ceil_mode}),
        .PARALLELISM({parallelism}),
        .GROUPS({groups}),
        .USE_MAX_FINDER({use_maxfinder}),
        .ANCHORS({anchors}),
        .IN_DATA_BIT_WIDTH({in_bw}),
        .IN_DATA_INT_WIDTH({in_int}),
        .IN_DATA_SIGN({in_s}),
        .WEIGHT_DATA_BIT_WIDTH({weight_bw}),
        .WEIGHT_DATA_INT_WIDTH({weight_int}),
        .WEIGHT_DATA_SIGN({weight_s}),
        .BIAS_DATA_BIT_WIDTH({bias_bw}),
        .BIAS_DATA_INT_WIDTH({bias_int}),
        .BIAS_DATA_SIGN({bias_s}),
        .INTER_DATA_BIT_WIDTH({inter_bw}),
        .INTER_DATA_INT_WIDTH({inter_int}),
        .INTER_DATA_SIGN({inter_s}),
        .BN_W_DATA_BIT_WIDTH({bn_weight_bw}),
        .BN_W_DATA_INT_WIDTH({bn_weight_int}),
        .BN_W_DATA_SIGN({bn_weight_s}),
        .BN_B_DATA_BIT_WIDTH({bn_bias_bw}),
        .BN_B_DATA_INT_WIDTH({bn_bias_int}),
        .BN_B_DATA_SIGN({bn_bias_s}),
        .OUT_DATA_BIT_WIDTH({out_bw}),
        .OUT_DATA_INT_WIDTH({out_int}),
        .OUT_DATA_SIGN({out_s}),
        .READ_MEMORY_LATENCY({read_latency}),
        .READ_WEIGHT_MEMORY_LATENCY({read_weight_latency}),
        .WRITE_MEMORY_LATENCY({write_latency})
        )
        {name}
        (
        .clk({clk}),
        .reset({reset}),
        .enable({enable}),
        .finished({finished}),
        .in_data_memory_out({read_data}),
        .in_data_memory_address({read_address}),
        .in_data_memory_read_enable({read_en}),
        .weights_memory_out({rom_data}),
        .weights_memory_address({rom_address}),
        .weights_memory_read_enable({rom_en}),
        .out_data_memory_in({write_data}),
        .out_data_memory_address({write_address}),
        .out_data_memory_write_enable({write_wen})
        );
    ROM
        #(
        .LEN({rom_len}),
        .DATA_WIDTH({parallelism}*{weight_bw}),
        .init_file_name("rom_{name}.mem"),
        .LATENCY({read_weight_latency}),
        .USE_SLEEP("{rom_type}" != "distributed"),
        .PRIMITIVE_TYPE("{rom_type}")
        )
        rom_{name}
        (
        .sleep({rom_sleep}),
        .clka({clk}),
        .ena({rom_en}),
        .addra({rom_address}),
        .douta({rom_data})
        );

"""
    
    def external_signals(self):
        suffix = self.get_suffix()
        
        signals = {
                  'clk':'clk'+suffix,
                  'enable':'enable'+suffix,
                  'reset':'reset'+suffix,
                  'finished':'finished'+suffix,
                  'rom_sleep':'rom_sleep'+suffix,
                  }
        
        return signals
    
    def generate(self) -> str:
        T = PWBlock.TEMPL
        
        signals = self.get_memory_write('write_')
        signals.update(self.get_weight_memory_read('rom_'))
        signals.update(self.get_memory_read('read_'))
        signals.update(self.external_signals())
        
        T = T.format(name=self.name,**signals, **self.config)
        return T
        
    def __repr__(self) -> str:
        return str(self.config)
        
    
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
        }
        
        return config
    
    TEMPL = """
    wire {clk}, {reset}, {enable}, {finished};
    wire [7:0] {read_data};
    wire [{weight_bw}:0] {rom_data};
    wire [31:0] {write_data};
    wire [32-1:0] {read_address},{rom_address},{write_address};
    wire {read_en},{rom_en},{write_en} = {enable},{write_wen};
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH({width}),
        .IN_HEIGHT({height}),
        .IN_CHANNELS({ch_in}),
        .CHANNEL_MUL({ch_mul}),
        .PADDING_W({padding_w}),
        .PADDING_H({padding_h}),
        .USE_BIAS({use_bias}),
        .USE_BN({use_bn}),
        .USE_RELU({use_relu}),
        .GROUPS({groups}),
        .IN_DATA_BIT_WIDTH({in_bw}),
        .IN_DATA_INT_WIDTH({in_int}),
        .IN_DATA_SIGN({in_s}),
        .WEIGHT_DATA_BIT_WIDTH({weight_bw}),
        .WEIGHT_DATA_INT_WIDTH({weight_int}),
        .WEIGHT_DATA_SIGN({weight_s}),
        .BIAS_DATA_BIT_WIDTH({bias_bw}),
        .BIAS_DATA_INT_WIDTH({bias_int}),
        .BIAS_DATA_SIGN({bias_s}),
        .INTER_DATA_BIT_WIDTH({inter_bw}),
        .INTER_DATA_INT_WIDTH({inter_int}),
        .INTER_DATA_SIGN({inter_s}),
        .BN_W_DATA_BIT_WIDTH({bn_weight_bw}),
        .BN_W_DATA_INT_WIDTH({bn_weight_int}),
        .BN_W_DATA_SIGN({bn_weight_s}),
        .BN_B_DATA_BIT_WIDTH({bn_bias_bw}),
        .BN_B_DATA_INT_WIDTH({bn_bias_int}),
        .BN_B_DATA_SIGN({bn_bias_s}),
        .OUT_DATA_BIT_WIDTH({out_bw}),
        .OUT_DATA_INT_WIDTH({out_int}),
        .OUT_DATA_SIGN({out_s}),
        .READ_MEMORY_LATENCY({read_latency}),
        .READ_WEIGHT_MEMORY_LATENCY({read_weight_latency}),
        .WRITE_MEMORY_LATENCY({write_latency})
        )
        {name}
        (
        .clk({clk}),
        .reset({reset}),
        .enable({enable}),
        .finished({finished}),
        .in_data_memory_out({read_data}),
        .in_data_memory_address({read_address}),
        .in_data_memory_read_enable({read_en}),
        .weights_memory_out({rom_data}),
        .weights_memory_address({rom_address}),
        .weights_memory_read_enable({rom_en}),
        .out_data_memory_in({write_data}),
        .out_data_memory_address({write_address}),
        .out_data_memory_write_enable({write_wen})
        );
    ROM
        #(
        .LEN({rom_len}),
        .DATA_WIDTH({weight_bw}),
        .init_file_name("rom_{name}.mem"),
        .LATENCY({read_weight_latency}),
        .USE_SLEEP("{rom_type}" != "distributed"),
        .PRIMITIVE_TYPE("{rom_type}")
        )
        rom_{name}
        (
        .sleep({rom_sleep}),
        .clka({clk}),
        .ena({rom_en}),
        .addra({rom_address}),
        .douta({rom_data})
        );

"""
    
    def external_signals(self):
        suffix = self.get_suffix()
        
        signals = {
                  'clk':'clk'+suffix,
                  'enable':'enable'+suffix,
                  'reset':'reset'+suffix,
                  'finished':'finished'+suffix,
                  'rom_sleep':'rom_sleep'+suffix,
                  }
        
        return signals
    
    def generate(self) -> str:
        T = DWBlock.TEMPL
        
        signals = self.get_memory_write('write_')
        signals.update(self.get_weight_memory_read('rom_'))
        signals.update(self.get_memory_read('read_'))
        signals.update(self.external_signals())
        
        T = T.format(name=self.name,**signals, **self.config)
        return T
        
    def __repr__(self) -> str:
        return str(self.config)
    


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
                }
    
    def get_memory_read(self, key_prefix=''):
        # as an input stream
        sx = self.get_suffix()
        signals = {
                  key_prefix+'data_in':'data_in'+sx,
                  key_prefix+'data_in_validity':'data_in_validity'+sx,
                  key_prefix+'last_data_received':'last_data_received'+sx,
                  }
        return signals
    
    def external_signals(self):
        suffix = self.get_suffix()
        
        signals = {
                  'clk':'clk'+suffix,
                  'enable':'enable'+suffix,
                  'reset':'reset'+suffix,
                  'finished':'finished'+suffix,
                  }
        
        return signals
    
    TEMPL = """
    wire {clk}, {enable}, {reset}, {in_stream_data_in_validity},
         {finished},{in_stream_last_data_received};
    wire [{groups}*{bit_width}-1:0] {in_stream_data_in};
    wire [{groups}*{bit_width}-1:0] {write_data};
    wire [32-1:0] {write_address};
    wire {write_wen}, {write_en} = {enable};
    
    InputLayer
		#(
		.BIT_WIDTH({bit_width}),
		.WIDTH({width}),
		.HEIGHT({height}),
		.CHANNELS({channels}),
		.GROUPS({groups}),
		.WRITE_MEMORY_LATENCY({write_latency})
		)
		{name}
		(
		.clk({clk}),
		.enable({enable}),
		.reset({reset}),
		.data_in({in_stream_data_in}),
		.data_in_validity({in_stream_data_in_validity}),
		.data_out({write_data}),
		.data_out_address({write_address}),
		.data_out_validity({write_wen}),
		.finished({finished}),
		.last_data_received({in_stream_last_data_received})
		);

"""
    
    def generate(self) -> str:
        T = ILBlock.TEMPL
        
        signals = self.get_memory_write('write_')
        signals.update(self.external_signals())
        signals.update(self.get_memory_read('in_stream_'))
        
        T = T.format(name=self.name,**signals, **self.config)
        return T


class RAMBlock(LayerBlock):
    def __init__(self, name, size, ports=2) -> None:
        config = self.extract_config(size, ports)
        super().__init__(name, None, 
                         None, None, 
                         None, config)
    
    def get_latency(self):
        return self.config['ports'] != 1 + self.config['READ_LATENCY']
        
    def extract_config(self, size, ports):
        config = {
                 'BYTE_LEN':size,
                 'WRITE_WIDTH':32,
                 'READ_WIDTH':8,
                 'BYTE_SIZE':8,
                 'READ_LATENCY':2,
                 'USE_SLEEP':0,
                 'ports':ports,
                 }
        return config
    
    def get_port_read(self, port_id):
        sx = '_port_'+str(port_id)
        
        signals = self.get_memory_read()
        signals = {k:v+sx for k,v in signals.items()}
        
        return signals
    
    def get_port_write(self, port_id):
        sx = '_port_'+str(port_id)
        
        signals = self.get_memory_write()
        signals = {k:v+sx for k,v in signals.items()}
        
        return signals
    
    def external_signals(self):
        suffix = '_'+self.name
        signals =  {
                    'clk':'clk'+suffix,
                    'reader_select':'reader_select'+suffix,
                    'writer_select':'writer_select'+suffix,
                    }
        return signals
    
    TEMPL = """
    wire {clk}, 
         ena_{name}, 
         enb_{name}, 
         wena_{name}, 
         sleep_{name} = 1'b0;
    wire [32-1:0] addra_{name}, 
                  addrb_{name};
    wire [{WRITE_WIDTH}-1:0] dina_{name};
    wire [{READ_WIDTH}-1:0] doutb_{name};
    // ports
    wire {formula_en};
    wire {formula_wen};
    wire [32-1:0] {formula_address};
    wire [{WRITE_WIDTH}-1:0] {formula_data_w};
    wire [{READ_WIDTH}-1:0] {formula_data_r};
    
    SDP_RAM
        #(
        .BYTE_LEN({BYTE_LEN}),
        .WRITE_WIDTH({WRITE_WIDTH}),
        .READ_WIDTH({READ_WIDTH}),
        .BYTE_SIZE({BYTE_SIZE}),
        .READ_LATENCY({READ_LATENCY}),
        .USE_SLEEP({USE_SLEEP})
        )
        {name}
        (
         .clka({clk}),
         .ena(ena_{name}),
         .wea(wena_{name}),
         .addra(addra_{name}),
         .dina(dina_{name}),
         
         .clkb({clk}),
         .enb(enb_{name}),
         .addrb(addrb_{name}),
         .doutb(doutb_{name}),
         
         .sleep(sleep_{name})
        );
    
    wire [$clog2({ports})-1:0] {reader_select};
    wire [32-1:0] {reader_addresses}[{ports}];
    wire {reader_ens}[{ports}];
    
{reader_addresses_formula}
{reader_ens_formula}
{reader_data_out_formula}
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH({READ_WIDTH}),
        .ADDRESS_BITS(32),
        .SOURCES({ports}),
        )
        reader_selector_{name}
        (
        .clk({clk}),
        .select({reader_select}),
        .data_in_address({reader_addresses}),
        .data_in_read_enable({reader_ens}),
        .data_out_address(addrb_{name}),
        .data_out_read_enable(enb_{name})
        );
        
    wire [$clog2({ports})-1:0] {writer_select};
    wire [{WRITE_WIDTH}-1:0] {writer_data}[{ports}];
    wire [32-1:0] {writer_addresses}[{ports}];
    wire {writer_wens}[{ports}];
    
{writer_data_formula}
{writer_addresses_formula}
{writer_wens_formula}
    
    assign ena_{name} = {writer_ens_formula};
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH({WRITE_WIDTH}),
        .ADDRESS_BITS(32),
        .SOURCES({ports}),
        )
        writer_selector_{name}
        (
        .clk({clk}),
        .select({writer_select}),
        
        .data_in({writer_data}),
        .data_in_address({writer_addresses}),
        .data_in_write_enable({writer_wens}),
        
        .data_out(dina_{name}),
        .data_out_address(addra_{name}),
        .data_out_write_enable(wea_{name})
        );

"""
    
    def ports_signals(self):
        signals = {
                  'en':[],
                  'wen':[],
                  'data_r':[],
                  'data_w':[],
                  'address':[],
                  }
        for i in range(self.config['ports']):
            p_read = self.get_port_read(i)
            p_write = self.get_port_write(i)
            signals['en'].append(p_read['en'])
            signals['en'].append(p_write['en'])
            signals['wen'].append(p_write['wen'])
            signals['data_r'].append(p_read['data'])
            signals['data_w'].append(p_write['data'])
            signals['address'].append(p_write['address'])
            signals['address'].append(p_read['address'])
        
        signals = {'formula_'+k:(',\n'+' '*9).join(v) for k,v in signals.items()}
        
        return signals
    
    def internal_signals(self):
        sx = self.get_suffix()
        
        signals = {
                  'reader_addresses':'reader_addresses'+sx,
                  'reader_ens':'reader_ens'+sx,
                  'reader_addresses_formula':'',
                  'reader_ens_formula':'',
                  'reader_data_out_formula':'',
                  
                  'writer_data':'writer_data'+sx,
                  'writer_addresses':'writer_addresses'+sx,
                  'writer_wens':'writer_wens'+sx,
                  'writer_data_formula':'',
                  'writer_addresses_formula':'',
                  'writer_wens_formula':'',
                  'writer_ens_formula':'0',
                  }
        assign = '    assign {w}[{i}] = {r};\n'
        
        for i in range(self.config['ports']):
            p_read = self.get_port_read(i)
            p_write = self.get_port_write(i)
            signals['reader_addresses_formula'] += assign.format(w=signals['reader_addresses'],
                                                                 r=p_read['address'],
                                                                 i=i)
            signals['reader_ens_formula'] += assign.format(w=signals['reader_ens'],
                                                           r=p_read['en'],
                                                           i=i)
            signals['reader_data_out_formula'] += assign.format(w=p_read['data'],
                                                           r='doutb_'+self.name,
                                                           i=i)
            signals['writer_addresses_formula'] += assign.format(w=signals['writer_addresses'],
                                                                 r=p_write['address'],
                                                                 i=i)
            signals['writer_wens_formula'] += assign.format(w=signals['writer_wens'],
                                                           r=p_write['wen'],
                                                           i=i)
            signals['writer_data_formula'] += assign.format(w=signals['writer_data'],
                                                           r=p_write['data'],
                                                           i=i)
            signals['writer_ens_formula'] += ' || '+p_write['en']

        return signals
    
    def generate(self) -> str:
        T = RAMBlock.TEMPL
        
        signals = {}
        signals.update(self.external_signals())
        signals.update(self.internal_signals())
        signals.update(self.ports_signals())
        
        T = T.format(name=self.name,**signals, **self.config)
        return T


class SharedMemoryBlocks(LayerBlock):
    
    def __init__(self, name, prev_blk:LayerBlock, layers:List[LayerBlock]) -> None:
        config = self.extract_config(name, prev_blk, layers)
        super().__init__(name,
                         config['in_shape'],
                         config['out_shape'],
                         config['in_quant'],
                         config['out_quant'],
                         config
                         )
    
    def extract_config(self,name:str, prev_blk:LayerBlock, layers:List[LayerBlock]):
        sizes = []
        for L in layers:
            s = L.out_shape[0]*L.out_shape[1]*L.out_shape[2]*(8//L.out_quant[0])
            sizes.append(s)
        
        rams = []
        if len(layers) == 1:
            rams.append(RAMBlock('ram_block_0_'+name,sizes[0]))
        elif len(layers) > 1:
            s0 = max(sizes[0::2])    
            s1 = max(sizes[1::2])    
            rams.append(RAMBlock('ram_block_0_'+name,s0))
            rams.append(RAMBlock('ram_block_1_'+name,s1))
        
        latency = 3
        for L in layers:
            L.config['read_latency'] = latency
            L.config['write_latency'] = latency
        
        config = {
                 'in_shape':prev_blk.out_shape,
                 'in_quant':prev_blk.out_quant,
                 'out_shape':layers[-1].out_shape,
                 'out_quant':layers[-1].out_quant,
                 'layers':layers,
                 'rams':rams,
                 'prev_blk':prev_blk,
                 }
        
        return config
    
    def external_signals(self):
        sx = self.get_suffix()
        signals = {
                  'clk':'clk'+sx,
                  }
        return signals
    
    def get_writers(self, ram_id):
        return self.config['layers'][ram_id::2]
    
    def get_readers(self, ram_id):
        return self.config['layers'][(1+ram_id)::2]
    
    def get_interface_to_prev(self, key_prefix=''):
        sx = self.get_suffix()
        signals = {
                  key_prefix+'en':'prev_en'+sx,
                  key_prefix+'data':'prev_data'+sx,
                  key_prefix+'address':'prev_address'+sx,
                  key_prefix+'reader_enabled':'prev_reader_enabled'+sx, # reader layer enabled
                  }
        return signals
    
    def get_interface_to_next(self, key_prefix=''):
        sx = self.get_suffix()
        signals = {
                  key_prefix+'en':'next_en'+sx,
                  key_prefix+'data':'next_data'+sx,
                  key_prefix+'address':'next_address'+sx,
                  key_prefix+'reader_enabled':'next_reader_enabled'+sx,
                  }
        return signals
        
    TEMPL = """
    // to/from previous block of double RAM
    wire {clk};
    wire {prev_en};
    wire {prev_reader_enabled};
    wire [8-1:0] {prev_data};
    wire [32-1:0] {prev_address};
    // to/from next block of double RAM
    wire {next_en};
    wire {next_reader_enabled};
    wire [8-1:0] {next_data};
    wire [32-1:0] {next_address};    
"""
    
    def generate(self) -> str:
        # declare wires for nearest blocks connection
        signals = self.get_interface_to_prev('prev_')
        signals.update(self.get_interface_to_next('next_'))
        signals.update(self.external_signals())
        print("signals:\n",signals)
        T = SharedMemoryBlocks.TEMPL.format(**signals)
        
        for j, r in enumerate(self.config['rams']):
            T += '   // generate ram '+ str(j)+'\n'
            r:RAMBlock = r
            T += r.generate()
            readers = self.get_readers(j)
            writers = self.get_writers(j)
            
            readers += [None]*(r.config['ports']-len(readers)-1) # -1 for read from next block 
            writers += [None]*(r.config['ports']-len(writers))
            
            for i, layer in enumerate(readers):
                p_r = r.get_port_read(i)
                layer_port_read = layer.get_memory_read()
                if layer_port_read:
                    T += '\n   // assignments for read port '+str(i)+'\n'
                    T += assign(layer_port_read['data'], p_r['data'])
                    T += assign(p_r['address'], layer_port_read['address'])
                    T += assign(p_r['en'], layer_port_read['en'])
                else:
                    T += '\n   // zero assignments for read port '+str(i)+'\n'
                    T += '   // no out data assignment'+'\n'
                    T += assign(p_r['address'], "32'd0")
                    T += assign(p_r['en'], "1'd0")
                    
            for i, layer in enumerate(writers):
                p_w = r.get_port_write(i)
                layer_port_write = layer.get_memory_write()
                
                if layer_port_write:
                    T += '\n   // assignments for write port '+str(i)+'\n'
                    T += assign(p_w['data'],layer_port_write['data'])
                    T += assign(p_w['address'], layer_port_write['address'])
                    T += assign(p_w['wen'], layer_port_write['wen'])
                    T += assign(p_w['en'], layer_port_write['en'])
                else:
                    T += '\n   // zero assignments for write port '+str(i)+'\n'
                    T += assign(p_w['data'],"32'd0")
                    T += assign(p_w['address'], "32'd0")
                    T += assign(p_w['wen'], "1'd0")
                    T += assign(p_w['en'], "1'd0")
        
        # nearest blocks interaces
        first_layer_interf = self.config['layers'][0].get_memory_read()
        block_prev = self.get_interface_to_prev()
        T += '\n   // assignments for first layer input\n'
        T += assign(first_layer_interf['data'],block_prev['data'])
        T += assign(block_prev['address'], first_layer_interf['address'])
        T += assign(block_prev['en'], first_layer_interf['en'])
        
        last_ram_idx = (len(self.config['layers'])+1) % 2
        last_ram : RAMBlock = self.config['rams'][last_ram_idx]
        lr_interf = last_ram.get_port_read(last_ram.config['ports']-1)
        block_next = self.get_interface_to_next()
        T += '\n   // assignments for first layer input\n'
        T += assign(block_next['data'],lr_interf['data'])
        T += assign(lr_interf['address'], block_next['address'])
        T += assign(lr_interf['en'], block_next['en'])
        
        T += '\n    // read and write selectors\n'
        for j, r in enumerate(self.config['rams'][:-1]):
            readers = self.get_readers(j)
            writers = self.get_writers(j)
            
            # reade selector
            r_sel = r.external_signals()['reader_select']
            # assign 2nd layer enable or always 0 index
            en = readers[-1].external_signals()['enable'] if len(readers) > 1 \
                                                          else "1'b0" if j != last_ram_idx\
                                                                      else lr_interf['reader_enabled']
            T += assign(r_sel,en)
            # write selector
            w_sel = r.external_signals()['writer_select']
            # assign 2nd layer enable or always 0 index
            en = writers[-1].external_signals()['enable'] if len(writers) > 1 else "1'b0"  
            T += assign(w_sel,en)    
        
        return T

def assign(w,r):
    return '    assign '+w+' = '+r+';\n'


class LastBlock(GenBlk):

    def __init__(self, layer:LayerBlock) -> None:
        self.name = None
        self.config = {}
        
    def extract_config(self,):
        return {}
    
    def external_signals(self):
        return {}
        
    def generate(self) -> str:
        return ''


class FirstBlock(GenBlk):

    def __init__(self, layer:LayerBlock) -> None:
        config = self.extract_config(layer)
        
        self.name = None
        self.layer = layer
        
    def extract_config(self,layer:LayerBlock):
        return {}
    
    def external_signals(self):
        return {}
        
    def generate(self) -> str:
        return ''


def create_hw_from_sw(model:torch.nn.Module,
                      input_shape = (1,3,112,208),
                      ):
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
    
    # itreate over intermediate layers
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
        
        # print(prev.config)
        # print(prev.external_signals())
        print(prev.generate())
        layers_blocks.append(prev)
    
    # [print(i,L) for i,L in enumerate(layers_blocks)]
    
    sh = SharedMemoryBlocks('sh_block', layers_blocks[0], layers_blocks[1:5])
    print("SHHH")
    print(sh.config)
    print(sh.generate())


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
    
    # ram = RAMBlock('ram_0', 2300)
    # print(ram.name)
    # print(ram.config)
    # print(ram.external_signals())
    # print(ram.generate())
