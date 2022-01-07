from brevitas.nn.quant_conv import QuantConv2d
import torch
import brevitas
import quantizers
from torch.nn import Module
from brevitas import nn
from brevitas.nn import QuantEltwiseAdd, QuantIdentity, QuantMaxPool2d, QuantReLU, QuantLinear, QuantAdaptiveAvgPool2d
from data_types import Types
import numpy as np


def get_number_of_params(model):
    p = 0

    for param in model.parameters():
        size = param.size()
        tmp = 1
        for i in range(len(size)):
            tmp *= size[i] 
        tmp = tmp if len(size) else 0
        p += tmp

    return p


def print_state_dict(state_dict, print_values=False):
    for i,(k,v) in enumerate(state_dict.items()):
        print("{}: {} -> {}".format(i,k,v if print_values else v.shape))


def print_model(model):
    for i, ch in enumerate(model.children()):
        print("{}: {}".format(i,ch.__class__))


def knowledge_transfer(src_dict, dst_dict):
    transferred_dict = {k:v.clone() for k,v in zip(dst_dict.keys(), src_dict.values())}
    
    return transferred_dict


def init_state_dict(state_dict, device='cpu', dtype=Types.T_WEIGHT, max_val=1e-6):
    new_dict = {}
    for k, v in state_dict.items():
        new_dict[k] = torch.rand(v.shape, dtype=v.dtype, device=device)*2*max_val - max_val
        
    return new_dict


#################################################
## Backbone network interface
#################################################

class Backbone(Module):
    def __init__(self):
        """
        Backbone network should include input quantization
        """
        super().__init__()
        
    def get_scale_factors(self):
        """
        input_size / output_size
        :return: numpy array with shape resize factors for each output layer 
                 shape (-1,2) as [height scale, width scale]
        """
        raise Exception('Not implemented')
    
    def output_sizes(self, input_size):
        """
        :param input_size: size of input layer as tuple (W,H)
        :return: numpy array of shape (n,2)  [[W1,H1], [W2, H2]] of widths and heights for each output layer
        """
        raise Exception('Not implemented')
    
    def multioutput_forward(self, x):
        """
        :param x: torch tensor to pass through the model
        :return: output of each layer
        """
        return x
        
    def to(self, device):
        """
        Method move the network to device.
        :param device: destiny device
        """
        super().to(device)
        
        return self
    
    def get_channels_number(self):
        """
        :return: number of channels for each returned (by forward) layer's output
        """
        raise Exception('Not implemented')


class Sequential(Backbone):

    def __init__(self, layers, device='cpu', return_quant_tensor=False):
        super().__init__()
        # find scales and chanels from given layers

        self.layers = layers
        self.device = device
        self.return_quant_tensor = return_quant_tensor

        for i in range(len(layers)):
            L = layers[i]
            self.add_module(str(i), L)
        
        self.to(device)

    def to(self, device):
        super().to(device)
        
        if Types.is_device(device):
            self.device = device

        for L in self.layers:
            L.to(device)
        
        return self

    def forward(self, x):
        for L in self.layers:
            # print(L.__class__)
            # if hasattr(x, 'tensor'):
            #     tmp = x.tensor
            # else:
            #     tmp = x
            # print(tmp.dtype, tmp.device)
            # if hasattr(L, 'weight') and L.weight is not None:
            #     print(L.weight.dtype, L.weight.device)
            #     if hasattr(L, 'quant_weight'):
            #         qw = L.quant_weight().tensor
            #         print(qw.dtype, qw.device)
            # if hasattr(L, 'bias') and L.bias is not None:
            #     print(L.bias.dtype, L.bias.device)
            #     if hasattr(L, 'quant_bias'):
            #         qb = L.quant_bias().tensor
            #         print(qb.dtype, qb.device)
            
            x = L(x)

        return x if self.return_quant_tensor else x.tensor

    def multioutput_forward(self, x):
        y = []

        for L in self.layers:
            x = L(x)
            y.append(x)

        return y

    def output_sizes(self, input_size):
        """
        :param input_size: tuple (W,H)
        :return: numpy array of shape (-1,2) as [num_at_width,num_at_height]
        """
        raise Exception("Not implemented")


#################################################
## Usefull layers/blocks
################################################

class BaseLayer(Module):
    def __init__(self, device):
        super().__init__()

        self.device = device
        self.layers = []

    def to(self, device):
        if Types.is_device(device):
            self.device = device
        super().to(device)

        for L in self.layers:
            L.to(device)

        return self
    
    def forward(self, x):
        for L in self.layers:
            # print(L.__class__)
            # if hasattr(x, 'tensor'):
            #     tmp = x.tensor
            # else:
            #     tmp = x    
            # print(tmp.dtype, tmp.device)
            # if hasattr(L, 'weight') and L.weight is not None:
            #     print(L.weight.dtype, L.weight.device)
            #     if hasattr(L, 'quant_weight'):
            #         qw = L.quant_weight().tensor
            #         print(qw.dtype, qw.device)
            # if hasattr(L, 'bias') and L.bias is not None:
            #     print(L.bias.dtype, L.bias.device)
            #     if hasattr(L, 'quant_bias'):
            #         qb = L.quant_bias().tensor
            #         print(qb.dtype, qb.device)
            
            x = L(x)

        return x

class QuantWrapper(Module):
    def __init__(self, wrapped, return_quant_tensor=True):
        super().__init__()
        self.wrapped = wrapped
        self.return_quant_tensor = return_quant_tensor
        
    def forward(self, x):
        if isinstance(x,brevitas.quant_tensor.QuantTensor): 
            x = x.tensor
            
        x = self.wrapped(x)
        
        if self.return_quant_tensor:
            x = brevitas.quant_tensor.QuantTensor(x)
        
        return x

class QuantBatchNorm(Module):
    
    TO_HARDWARE = False
    ALLOW_QUANTIZATION = True

    def __init__(self, num_of_features, eps=1e-5,q_w=None,q_i=None,q_o=None,q_b=None):
        super().__init__()
        self.use_quant = (q_w is not None \
                        or q_i is not None \
                        or q_o is not None \
                        or q_b is not None) and QuantBatchNorm.ALLOW_QUANTIZATION
        if self.use_quant and not QuantBatchNorm.TO_HARDWARE:
            # for quantized training
            self.bn = brevitas.nn.BatchNorm2dToQuantScaleBias(num_of_features,eps,q_w,q_b,q_i,q_o, return_quant_tensor=True)
        elif self.use_quant and QuantBatchNorm.TO_HARDWARE:
            # for hardware implementation
            self.bn = QuantConv2d(num_of_features,num_of_features,1,groups=num_of_features,bias=True,
                                    weight_quant=q_w,bias_quant=q_b,input_quant=q_i,output_quant=q_o,
                                    return_quant_tensor=True)
        else:
            # for floating point training
            self.bn = QuantWrapper(torch.nn.BatchNorm2d(num_of_features, eps), True)
            
    def _load_from_state_dict(self, state_dict, prefix, local_metadata, strict, missing_keys, unexpected_keys, error_msgs):
        
        k = prefix
        # torch bn weights
        key_running_mean = k+'bn.wrapped.running_mean'
        key_running_var = k+'bn.wrapped.running_var'
        key_weight = k+'bn.wrapped.weight'
        key_bias = k+'bn.wrapped.bias'
        key_num_batches_tracked = k+'bn.wrapped.num_batches_tracked'
        
        # if previous model uses wrapper for torch.bn
        if self.use_quant and \
                key_running_mean in state_dict.keys() and \
                key_running_var in state_dict.keys() and \
                key_weight in state_dict.keys() and \
                key_bias in state_dict.keys() and \
                key_num_batches_tracked in state_dict.keys():

            # get torch bn weights
            mean = state_dict[key_running_mean]
            std = torch.sqrt(state_dict[key_running_var]+self.bn.eps)
            weight = state_dict[key_weight]
            bias = state_dict[key_bias]
            # compute affine values
            a = weight / std
            b = bias - weight*mean/std
            # add brevitas bn weights
            state_dict[prefix+'bn.weight'] = a
            state_dict[prefix+'bn.bias'] = b
            
            # remove torch bn weights from state dict
            state_dict.pop(key_running_mean, None)
            state_dict.pop(key_running_var, None)
            state_dict.pop(key_weight, None)
            state_dict.pop(key_bias, None)
            state_dict.pop(key_num_batches_tracked, None)
            
        if QuantBatchNorm.TO_HARDWARE:
            # reshape weights tensors
            state_dict[prefix+'bn.weight'] = state_dict[prefix+'bn.weight'].reshape(-1,1,1,1)
            state_dict[prefix+'bn.bias'] = state_dict[prefix+'bn.bias'].reshape(-1)
            
        
        return super()._load_from_state_dict(state_dict, prefix, local_metadata, strict, missing_keys, unexpected_keys, error_msgs)
    
    def forward(self,x):
        return self.bn(x)


class DWConv2d(BaseLayer):
    def __init__(self, 
                 in_channels,  
                 quantizer_w,
                 quantizer_in,
                 quantizer_out,
                 quantizer_bias,
                 return_quant_tensor=True,
                 bias=True,
                 kernel_size=(3,3),
                 padding=(1,1),
                 stride=(1,1),
                 device='cpu',
                 intermediate_channels=1,
                 use_bn=False,
                 use_relu=False):
        super().__init__(device)

        self.in_channels = in_channels
        self.out_channels = in_channels*intermediate_channels
        self.stride = stride
        # self.use_quant = (quantizer_w or quantizer_in or quantizer_out or quantizer_bias) is not None
        
        out_class = brevitas.nn.QuantReLU if use_relu else brevitas.nn.QuantIdentity
        
        # depthwise convolution 2d
        conv_dw = nn.QuantConv2d(in_channels=in_channels, 
                                    out_channels=in_channels*intermediate_channels, 
                                    kernel_size=kernel_size,
                                    padding=padding, # 'same'
                                    groups=in_channels,
                                    stride=stride,
                                    bias=bias,
                                    weight_quant=quantizer_w,
                                    bias_quant=quantizer_bias,
                                    input_quant=quantizer_in,
                                    output_quant=None,
                                    # output_quant=quantizer_out,
                                    return_quant_tensor=return_quant_tensor
                                    )
        dw_bn = QuantBatchNorm(in_channels*intermediate_channels, eps=1e-5,q_w=quantizer_w,q_i=quantizer_in,q_o=None,q_b=quantizer_bias)
        dw_out = out_class(act_quant=quantizer_out, 
                           return_quant_tensor=return_quant_tensor, 
                        #    inplace=True
                        )
               
        # add DW
        self.add_module('conv_dw', conv_dw)
        self.layers.append(conv_dw)
        
        # batch norm add
        if use_bn:
            # quant before batch norm
            if SeparableConv2D.QUANT_BEFORE_BN:
                quant_dw_bn = QuantIdentity(act_quant=quantizer_out, return_quant_tensor=True)
                self.layers.append(quant_dw_bn)
                self.add_module('quant_dw_bn', quant_dw_bn)

            self.add_module('dw_bn', dw_bn)
            self.layers.append(dw_bn)
            
        self.layers.append(dw_out)
        self.add_module('dw_out', dw_out)
            
    def get_scale_factor(self):
        return self.stride

class PWConv2d(BaseLayer):
    def __init__(self, 
                 in_channels, 
                 out_channels, 
                 quantizer_w,
                 quantizer_in,
                 quantizer_out,
                 quantizer_bias,
                 return_quant_tensor=True,
                 bias=False,
                 device='cpu',
                 use_bn=False,
                 use_relu=False,
                 use_mp=False):
        super().__init__(device)

        self.in_channels = in_channels
        self.out_channels = out_channels
        self.stride = (1,1)
        
        out_class = brevitas.nn.QuantReLU if use_relu else brevitas.nn.QuantIdentity
        
        # pointwise convolution 2d
        conv_pw = nn.QuantConv2d(in_channels=in_channels, 
                                 out_channels=out_channels, 
                                 kernel_size=(1,1),
                                 bias=bias,  
                                 weight_quant=quantizer_w,
                                 bias_quant=quantizer_bias,
                                 input_quant=quantizer_in,
                                 output_quant=None,
                                #  output_quant=quantizer_out,
                                 return_quant_tensor=return_quant_tensor
                                 )
        pw_bn = QuantBatchNorm(out_channels, eps=1e-5,q_w=quantizer_w,q_i=quantizer_in,q_o=None,q_b=quantizer_bias)
        pw_out = out_class(act_quant=quantizer_out, 
                           return_quant_tensor=return_quant_tensor, 
                        #    inplace=True
                           )
        
        # add PW
        self.add_module('conv_pw', conv_pw)
        self.layers.append(conv_pw)
        
        # batch norm add
        if use_bn:
            # quant before batch norm
            if SeparableConv2D.QUANT_BEFORE_BN:
                quant_pw_bn = QuantIdentity(act_quant=quantizer_out, return_quant_tensor=True)
                self.layers.append(quant_pw_bn)
                self.add_module('quant_pw_bn', quant_pw_bn)
                

            self.add_module('pw_bn', pw_bn)
            self.layers.append(pw_bn)
        
        self.layers.append(pw_out)
        self.add_module('pw_out', pw_out)
        if use_mp:
            mp = QuantMaxPool2d(kernel_size=(2,2),stride=(2,2), ceil_mode=True)
            self.add_module('pw_mp', mp)
            self.layers.append(mp)
        
        self.to(device)

    def get_scale_factor(self):
        return self.stride

class SeparableConv2D(BaseLayer):

    QUANT_BEFORE_BN = False

    def __init__(self, 
                 in_channels, 
                 out_channels, 
                 quantizer_w,
                 quantizer_in,
                 quantizer_out,
                 quantizer_bias,
                 return_quant_tensor=True,
                 bias=True,
                 kernel_size=(3,3),
                 padding=(1,1),
                 stride=(1,1),
                 device='cpu',
                 intermediate_channels=1,
                 use_bn=False,
                 use_relu=False):
        super().__init__(device)

        self.in_channels = in_channels
        self.out_channels = out_channels
        self.stride = stride
        # self.use_quant = (quantizer_w or quantizer_in or quantizer_out or quantizer_bias) is not None
        
        out_class = brevitas.nn.QuantReLU if use_relu else brevitas.nn.QuantIdentity
        
        # depthwise convolution 2d
        conv_dw = nn.QuantConv2d(in_channels=in_channels, 
                                    out_channels=in_channels*intermediate_channels, 
                                    kernel_size=kernel_size,
                                    padding=padding, # 'same'
                                    groups=in_channels,
                                    stride=stride,
                                    bias=bias,
                                    weight_quant=quantizer_w,
                                    bias_quant=quantizer_bias,
                                    input_quant=quantizer_in,
                                    output_quant=None,
                                    # output_quant=quantizer_out,
                                    return_quant_tensor=return_quant_tensor
                                    )
        dw_bn = QuantBatchNorm(in_channels*intermediate_channels, eps=1e-5,q_w=quantizer_w,q_i=quantizer_in,q_o=None,q_b=quantizer_bias)
        dw_out = out_class(act_quant=quantizer_out, 
                           return_quant_tensor=return_quant_tensor, 
                        #    inplace=True
                           )
        
        # pointwise convolution 2d
        conv_pw = nn.QuantConv2d(in_channels=in_channels*intermediate_channels, 
                                 out_channels=out_channels, 
                                 kernel_size=(1,1),
                                 bias=bias,  
                                 weight_quant=quantizer_w,
                                 bias_quant=quantizer_bias,
                                 input_quant=quantizer_in,
                                 output_quant=None,
                                #  output_quant=quantizer_out,
                                 return_quant_tensor=return_quant_tensor
                                 )
        pw_bn = QuantBatchNorm(out_channels, eps=1e-5,q_w=quantizer_w,q_i=quantizer_in,q_o=None,q_b=quantizer_bias)
        pw_out = out_class(act_quant=quantizer_out, 
                           return_quant_tensor=return_quant_tensor, 
                        #    inplace=True
                           )
        
        # add DW
        self.add_module('conv_dw', conv_dw)
        self.layers.append(conv_dw)
        
        # batch norm add
        if use_bn:
            # quant before batch norm
            if SeparableConv2D.QUANT_BEFORE_BN:
                quant_dw_bn = QuantIdentity(act_quant=quantizer_out, return_quant_tensor=True)
                self.layers.append(quant_dw_bn)
                self.add_module('quant_dw_bn', quant_dw_bn)

            self.add_module('dw_bn', dw_bn)
            self.layers.append(dw_bn)
            
        self.layers.append(dw_out)
        self.add_module('dw_out', dw_out)
            
        # add PW
        self.add_module('conv_pw', conv_pw)
        self.layers.append(conv_pw)
        
        # batch norm add
        if use_bn:
            # quant before batch norm
            if SeparableConv2D.QUANT_BEFORE_BN:
                quant_pw_bn = QuantIdentity(act_quant=quantizer_out, return_quant_tensor=True)
                self.layers.append(quant_pw_bn)
                self.add_module('quant_pw_bn', quant_pw_bn)
                

            self.add_module('pw_bn', pw_bn)
            self.layers.append(pw_bn)
        
        self.layers.append(pw_out)
        self.add_module('pw_out', pw_out)
        
        self.to(device)

    def get_scale_factor(self):
        return self.stride


class StdConv2D(BaseLayer):

    def __init__(self, 
                 in_channels, 
                 out_channels, 
                 quantizer_w,
                 quantizer_in,
                 quantizer_out,
                 quantizer_bias,
                 return_quant_tensor=True,
                 bias=True,
                 kernel_size=(3,3),
                 padding=(1,1),
                 stride=(1,1),
                 groups=1,
                 device='cpu',):
        super().__init__(device)

        self.in_channels = in_channels
        self.out_channels = out_channels
        self.stride = stride
        self.use_quant = quantizer_w or quantizer_in or quantizer_out or quantizer_bias

        # pointwise convolution 2d
        conv = nn.QuantConv2d(in_channels=in_channels, 
                                 out_channels=out_channels, 
                                 kernel_size=kernel_size,
                                 bias=bias,  
                                 stride=stride,
                                 padding=padding,
                                 groups=groups,
                                 weight_quant=quantizer_w,
                                 bias_quant=quantizer_bias,
                                 input_quant=quantizer_in,
                                 output_quant=None,
                                 return_quant_tensor=return_quant_tensor
                                 )
        conv_out = brevitas.nn.QuantIdentity(act_quant=quantizer_out, 
                                                return_quant_tensor=return_quant_tensor)
        
        self.add_module('conv', conv)
        
        self.layers = [ 
                       conv, 
                       conv_out]

        self.to(device)


class ResidualBlock(torch.nn.Module):
    """
    Residual Block process parallel sequential branches and make sum of each sequential output. 

    """
    def __init__(self,
                 in_channels,
                 branches,
                 q_i,q_o,
                 return_quant_tensor=True,
                 out_channels=None,
                 device='cpu'):
        """
        Create residual block with branches as nn.Modules or Sequences. 
        Note that identity is branch with no filters.
        :param in_channels: input channels number
        """
        super().__init__()

        self.device = device
        self.in_channels = in_channels
        self.branches = branches
        
        # add branches
        for i,b in enumerate(self.branches):
            self.add_module('branch_'+str(i), b)

        # number of out channels
        self.out_channels = out_channels
        # SUMMING MODULES
        self.summing_nodes = []

        for i in range(len(self.branches)-1):
            sn = brevitas.nn.QuantEltwiseAdd(q_i,q_o,
                                            tie_input_output_quant=False, 
                                            return_quant_tensor=return_quant_tensor)
            self.summing_nodes.append(sn)
            self.add_module('summing_node_'+str(i), sn)

        self.to(device)

    def to(self, device):
        super().to(device)

        if Types.is_device(device):
            self.device = device

        for branch in self.branches:
            branch.to(device)
        
        for sn in self.summing_nodes:
            sn.to(device)

        return self

    def forward(self, x):
        # pass x_beg through first branch
        x_sum = self.branches[0](x)
        # pass x_beg through the rest of branches and sum them with x_sum 
        for branch, sn in zip(self.branches[1:], self.summing_nodes):
            x_sum = sn(x_sum, branch(x))

        return x_sum


def YoloLayer_v3(in_channels,  
                    num_of_anchors,
                    quantizer_w,
                    quantizer_in,
                    quantizer_out,
                    quantizer_bias,
                    return_quant_tensor=True,
                    bias=True,
                    kernel_size=(3,3),
                    padding=(0,0),
                    stride=(1, 1),
                    use_sigmoid=True,
                    sigm_output_range=3,
                    device='cpu',
                    conv_class=SeparableConv2D):
    class YoloLayer_Local(conv_class):

        def __init__(self, 
                    in_channels,  
                    num_of_anchors,
                    quantizer_w,
                    quantizer_in,
                    quantizer_out,
                    quantizer_bias,
                    return_quant_tensor=True,
                    bias=True,
                    kernel_size=(3,3),
                    padding=(0,0),
                    stride=(1,1),
                    use_sigmoid=True,
                    sigm_output_range=3,
                    device='cpu'):
            super().__init__(in_channels,
                            5*num_of_anchors, # [validity, dx,dy, w, h]*num_of_anchors
                            quantizer_w,
                            quantizer_in,
                            quantizer_out,
                            quantizer_bias,
                            return_quant_tensor,
                            bias,
                            kernel_size,
                            padding,
                            stride,
                            device=device)

            self.num_of_anchors = num_of_anchors
            self.use_sigmoid = use_sigmoid
            self.sigm_output_range = sigm_output_range

        def forward(self, x):
            x = super().forward(x)

            if self.use_sigmoid:
                if isinstance(x, brevitas.quant_tensor.QuantTensor):
                    x = x.tensor
                    
                idx = self.sigm_output_range*self.num_of_anchors
                x[:,:idx,:,:] = torch.sigmoid(x[:,:idx,:,:])

            return x
    
    return YoloLayer_Local(in_channels,  
                            num_of_anchors,
                            quantizer_w,
                            quantizer_in,
                            quantizer_out,
                            quantizer_bias,
                            return_quant_tensor,
                            bias,
                            kernel_size,
                            padding,
                            stride,
                            use_sigmoid,
                            sigm_output_range,
                            device)


class AnchorMul(torch.nn.Module):

    def __init__(self, num_of_anchors, device=torch.device('cpu')):
        super().__init__()
        self.noa = num_of_anchors
        self.anchors = torch.nn.Parameter(data=torch.Tensor(1,2*self.noa,1,1), requires_grad=True)
        self.anchors.data.uniform_(-1,1)
        self.register_parameter('anchors', self.anchors)
        
        self.to(device)

    def forward(self, x):
        xvc = x[:,:-2*self.noa,:,:]
        xwh = x[:,-2*self.noa:,:,:]
        ywh = xwh*torch.exp(self.anchors)
        y = torch.cat((xvc,ywh), dim=1)

        return y

class QuantAnchorMul(QuantWrapper):
    def __init__(self, num_of_anchors, device=torch.device('cpu'),return_quant_tensor=True):
        super().__init__(AnchorMul(num_of_anchors, device),return_quant_tensor=True )
        
###############################################
## Architectures
###############################################

class SkyNet(Sequential):
    def __init__(self, num_of_anchors,input_quant=None, 
                 intermediate_quant=(None,None,None,None), 
                 output_quant=(None,None,None,None),
                 device='cpu', use_sigmoid=False):
        """
        :param input_quant: quantizer class
        :param intermediate_quant: quantizers classes tuple(w,in,out,bias)
        :param output_quant: quantizers classes tuple(w,in,out,bias)
        """
        
        L = [
            brevitas.nn.QuantIdentity(input_quant, True),

            DWConv2d(3, *intermediate_quant, intermediate_channels=1, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(3,48, *intermediate_quant, bias=False, use_bn=True, use_relu=True, use_mp=True, device=device),
            
            DWConv2d(48, *intermediate_quant, intermediate_channels=1, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(48,96, *intermediate_quant, bias=False, use_bn=True, use_relu=True, use_mp=True, device=device),
            
            DWConv2d(96, *intermediate_quant, intermediate_channels=1, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(96,192, *intermediate_quant, bias=False, use_bn=True, use_relu=True, use_mp=True, device=device),
            
            DWConv2d(192, *intermediate_quant, intermediate_channels=1, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(192,384, *intermediate_quant, bias=False, use_bn=True, use_relu=True, use_mp=False, device=device),
            
            DWConv2d(384, *intermediate_quant, intermediate_channels=1, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(384,512, *intermediate_quant, bias=False, use_bn=True, use_relu=True, use_mp=False, device=device),
            
            PWConv2d(512,num_of_anchors*5, *output_quant, bias=False, use_bn=False, use_relu=False, use_mp=False, device=device),
            
            QuantAnchorMul(num_of_anchors, device, return_quant_tensor=True), 
            ]
            
            
        super().__init__(L, device=device, return_quant_tensor=False)


class QuantResNet18(Sequential):
    
    def BasicBlock_1(in_channels, qw,qi,qo,qb, device):
        nf = in_channels
        conv1 = StdConv2D(nf,nf,qw,qi,qo,qb,bias=False,device=device)
        bn1 = QuantBatchNorm(nf,1e-5,qw,qi,qo,qb)
        relu = QuantReLU(act_quant=qo, return_quant_tensor=True)
        conv2 = StdConv2D(nf,nf,qw,qi,qo,qb,bias=False,device=device)
        bn2 = QuantBatchNorm(nf,1e-5,qw,qi,qo,qb)
        
        s1 = Sequential([conv1,bn1,relu,conv2,bn2], return_quant_tensor=True,device=device)
        s2 = Sequential([], return_quant_tensor=True,device=device)
                
        return ResidualBlock(in_channels,[s1,s2],qi,qo,True,in_channels,device)
        
    def BasicBlock_2(in_channels, out_channels, qw,qi,qo,qb, device):
        in_f = in_channels
        out_f = out_channels
        # branch 1
        conv1 = StdConv2D(in_f,out_f,qw,qi,qo,qb,stride=(2,2),bias=False,device=device)
        bn1 = QuantBatchNorm(out_f,1e-5,qw,qi,qo,qb)
        relu = QuantReLU(act_quant=qo, return_quant_tensor=True)
        conv2 = StdConv2D(out_f,out_f,qw,qi,qo,qb,bias=False,device=device)
        bn2 = QuantBatchNorm(out_f,1e-5,qw,qi,qo,qb)
        
        s1 = Sequential([conv1,bn1,relu,conv2,bn2], return_quant_tensor=True,device=device)
        
        # branch 2
        conv_1 = StdConv2D(in_f,out_f,qw,qi,qo,qb,kernel_size=(1,1),padding=(0,0),stride=(2,2),bias=False,device=device)
        bn_1 = QuantBatchNorm(out_f,1e-5,qw,qi,qo,qb)
        s2 = Sequential([conv_1, bn_1], return_quant_tensor=True,device=device)
        
        return ResidualBlock(in_channels,[s1,s2],qi,qo,True,out_channels,device)


    def __init__(self, input_quant=None, 
        intermediate_quant=(None,None,None,None), 
        output_quant=(None,None,None,None),
        device='cpu'):

        L = [
            brevitas.nn.QuantIdentity(act_quant=input_quant, return_quant_tensor=True),
            StdConv2D(3,64,
                      *intermediate_quant,bias=False,
                      kernel_size=(7,7), 
                      padding=(3,3), 
                      stride=(2,2),
                      device=device),
            QuantBatchNorm(64,1e-5,*intermediate_quant),
            QuantReLU(act_quant=intermediate_quant[2], 
                      return_quant_tensor=True),
            QuantMaxPool2d(kernel_size=(3,3), 
                           stride=(2,2),
                           padding=(1,1),
                           ceil_mode=False,
                           return_quant_tensor=True),
            Sequential([
                       QuantResNet18.BasicBlock_1(64,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       QuantResNet18.BasicBlock_1(64,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       ], return_quant_tensor=True,device=device),
                       
            Sequential([
                       QuantResNet18.BasicBlock_2(64,128,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       QuantResNet18.BasicBlock_1(128,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       ], return_quant_tensor=True,device=device),
                       
            Sequential([
                       QuantResNet18.BasicBlock_2(128,256,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       QuantResNet18.BasicBlock_1(256,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       ], return_quant_tensor=True,device=device),
                       
            Sequential([
                       QuantResNet18.BasicBlock_2(256,512,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       QuantResNet18.BasicBlock_1(512,*intermediate_quant, device),
                       QuantReLU(inplace=True,act_quant=intermediate_quant[2], return_quant_tensor=True),
                       ], return_quant_tensor=True,device=device),
                       
            QuantAdaptiveAvgPool2d(output_size=(1,1), 
                                   trunc_quant=intermediate_quant[2]),
            QuantLinear(512,1000,bias=True, 
                        weight_quant=output_quant[0],
                        input_quant=output_quant[1],
                        output_quant=output_quant[2],
                        bias_quant=output_quant[3], return_quant_tensor=True)
            ]
        
        super().__init__(L, device=device, return_quant_tensor=False)


def fp_resnet_dict_to_quant_resnet_dict(fp_dict, yolo_layer, cut_top=4, device='cpu',eps=1e-5, with_quantizers=True):
    layers = QuantResNet18(device=device).layers[:-cut_top]
    layers.append(yolo_layer)
    model = Sequential(layers, device=device)
    
    nq_dict = model.state_dict()
    # rename dict from torch convention to quant convention
    nq_dict = {knq:vfp.clone() for knq,vfp in zip(nq_dict.keys(), fp_dict.values())}
    
    if not with_quantizers:
        return nq_dict

    bn_keys = [k[:-len('.wrapped.running_mean')] for k in nq_dict.keys() if '.running_mean' in k]

    for k in bn_keys:
        # get bn 
        mean = nq_dict[k+'.wrapped.running_mean']
        var = torch.sqrt(nq_dict[k+'.wrapped.running_var']+eps)
        weight = nq_dict[k+'.wrapped.weight'] 
        bias = nq_dict[k+'.wrapped.bias']
        # weights convertion
        a = weight / var
        b = bias - mean * weight / var
        # replace old weights with new calculated
        nq_dict[k+'.weight'] = a
        nq_dict[k+'.bias'] = b
        
        # remove not needed keys
        nq_dict.pop(k+'.wrapped.running_mean', None)
        nq_dict.pop(k+'.wrapped.running_var', None)
        nq_dict.pop(k+'.wrapped.weight', None)
        nq_dict.pop(k+'.wrapped.bias', None)
        nq_dict.pop(k+'.wrapped.num_batches_tracked', None)
    
    # return dict prepared for quant resnet
    return nq_dict 


class LittleNet5(Sequential):
    def __init__(self, num_of_anchors,input_quant=None, 
                 intermediate_quant=(None,None,None,None), 
                 output_quant=(None,None,None,None),
                 device='cpu', use_sigmoid=False, use_am=True, use_bias=False):
        """
        :param input_quant: quantizer class
        :param intermediate_quant: quantizers classes tuple(w,in,out,bias)
        :param output_quant: quantizers classes tuple(w,in,out,bias)
        """
        ub = use_bias
        L = [
            brevitas.nn.QuantIdentity(input_quant, True),
            # SeparableConv2D(3, 16, *intermediate_quant, intermediate_channels=5, bias=False, use_bn=True, use_relu=True, device=device),
            DWConv2d(3, *intermediate_quant, intermediate_channels=5, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(15,16, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            QuantMaxPool2d(kernel_size=(2,2),stride=(2,2), ceil_mode=True),
            
            # SeparableConv2D(16, 32, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            DWConv2d(16, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(32,32, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            QuantMaxPool2d(kernel_size=(2,2),stride=(2,2), ceil_mode=True),
            
            # SeparableConv2D(32, 64, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            DWConv2d(32, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(64,64, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            QuantMaxPool2d(kernel_size=(2,2),stride=(2,2), ceil_mode=True),
            
            # SeparableConv2D(64, 128, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            DWConv2d(64, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(128,128, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            QuantMaxPool2d(kernel_size=(2,2),stride=(2,2), ceil_mode=True),
            
            # SeparableConv2D(128, 128, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            DWConv2d(128, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(256,128, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            # SeparableConv2D(128, 256, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            DWConv2d(128, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(256,256, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            
            # YoloLayer_v3(256, num_of_anchors, *output_quant, bias=True, kernel_size=(1,1), use_sigmoid=use_sigmoid, device=device, conv_class=StdConv2D),
            PWConv2d(256,5*num_of_anchors, *intermediate_quant, bias=True, use_bn=False, use_relu=False, device=device)
            ]
        if use_am:
            L.append(QuantAnchorMul(num_of_anchors, device, return_quant_tensor=True) )
            
        super().__init__(L, device=device, return_quant_tensor=False)


class LittleNet6(Sequential):
    def __init__(self, num_of_anchors,input_quant=None, 
                 intermediate_quant=(None,None,None,None), 
                 output_quant=(None,None,None,None),
                 device='cpu', use_sigmoid=False, use_am=True, use_bias=False):
        """
        :param input_quant: quantizer class
        :param intermediate_quant: quantizers classes tuple(w,in,out,bias)
        :param output_quant: quantizers classes tuple(w,in,out,bias)
        """
        ub = use_bias
        L = [
            brevitas.nn.QuantIdentity(input_quant, True),
     
            DWConv2d(3, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(6,8, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, use_mp=True, device=device),
            DWConv2d(8, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),
            DWConv2d(8, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),
            
            DWConv2d(8, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(16,32, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, use_mp=True, device=device),
            DWConv2d(32, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),
            DWConv2d(32, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),

            DWConv2d(32, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(64,64, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, use_mp=True, device=device),
            DWConv2d(64, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),

            DWConv2d(64, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(128,128, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, use_mp=True, device=device),
            DWConv2d(128, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),

            DWConv2d(128, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(256,128, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            DWConv2d(128, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),

            DWConv2d(128, *intermediate_quant, intermediate_channels=2, bias=ub, use_bn=True, use_relu=True, device=device),
            PWConv2d(256,256, *intermediate_quant, bias=ub, use_bn=True, use_relu=True, device=device),
            DWConv2d(256, *intermediate_quant, bias=ub, use_bn=True, use_relu=False, device=device),
            
            PWConv2d(256,5*num_of_anchors, *intermediate_quant, bias=True, use_bn=False, use_relu=False, device=device)
            ]
        if use_am:
            L.append(QuantAnchorMul(num_of_anchors, device, return_quant_tensor=True) )
            
        super().__init__(L, device=device, return_quant_tensor=False)


class LittleNet7(Sequential):
    def __init__(self, num_of_anchors,input_quant=None, 
                 intermediate_quant=(None,None,None,None), 
                 output_quant=(None,None,None,None),
                 device='cpu', use_sigmoid=False, use_am=True, use_bias=False):
        """
        :param input_quant: quantizer class
        :param intermediate_quant: quantizers classes tuple(w,in,out,bias)
        :param output_quant: quantizers classes tuple(w,in,out,bias)
        """
        ub = use_bias
        L = [
            brevitas.nn.QuantIdentity(input_quant, True),
      
            DWConv2d(3, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(6,8, *intermediate_quant, bias=True, use_bn=True, use_relu=False, use_mp=True, device=device),
            DWConv2d(8, *intermediate_quant, bias=True, use_bn=True, use_relu=False, device=device),
            
            DWConv2d(8, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(16,32, *intermediate_quant, bias=True, use_bn=True, use_relu=False, use_mp=True, device=device),
            DWConv2d(32, *intermediate_quant, bias=True, use_bn=True, use_relu=False, device=device),
            
            DWConv2d(32, *intermediate_quant, intermediate_channels=2, bias=False, use_bn=True, use_relu=True, device=device),
            PWConv2d(64,64, *intermediate_quant, bias=False, use_bn=True, use_relu=False, use_mp=True, device=device),
            DWConv2d(64, *intermediate_quant, bias=True, use_bn=True, use_relu=False, device=device),
            
            DWConv2d(64, *intermediate_quant, intermediate_channels=2, bias=True, use_bn=True, use_relu=True, device=device),
            PWConv2d(128,128, *intermediate_quant, bias=False, use_bn=True, use_relu=True, use_mp=True, device=device),
            DWConv2d(128, *intermediate_quant, bias=True, use_bn=True, use_relu=False, device=device),

            DWConv2d(128, *intermediate_quant, intermediate_channels=2, bias=True, use_bn=True, use_relu=True, device=device),
            PWConv2d(256,256, *intermediate_quant, bias=True, use_bn=True, use_relu=True, device=device),
            DWConv2d(256, *intermediate_quant, bias=True, use_bn=True, use_relu=False, device=device),
            
            DWConv2d(256, *intermediate_quant, intermediate_channels=2, bias=True, use_bn=True, use_relu=True, device=device),
            PWConv2d(512,256, *intermediate_quant, bias=True, use_bn=True, use_relu=True, device=device),
            DWConv2d(256, *intermediate_quant, intermediate_channels=1, bias=False, use_bn=True, use_relu=True, device=device),
            
            PWConv2d(256,5*num_of_anchors, *intermediate_quant, bias=True, use_bn=False, use_relu=False, device=device)
            ]
        if use_am:
            L.append(QuantAnchorMul(num_of_anchors, device, return_quant_tensor=True) )
            
        super().__init__(L, device=device, return_quant_tensor=False)

