from typing import Optional, Tuple, Union, overload
import brevitas
import torch
from brevitas.inject import ExtendedInjector, Injector
import brevitas.core.quant as bv_quant
import brevitas.core.scaling as bv_scaling
import brevitas.core.zero_point as bv_zp
import brevitas.core.bit_width as bv_bw
import brevitas.core.function_wrapper.ops_ste as bv_os
import torchvision
from data_types import Types
from brevitas.jit import ScriptModule as SM
from brevitas.function import ops_ste as grad_op
from brevitas import function as bv_fcn
import pdb
from brevitas.quant import solver as bv_sol

round_modes = { 'floor':bv_os.FloorSte,
                'round':bv_os.RoundSte,
                'ceil':bv_os.CeilSte}


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
        # scaling_init = torch.tensor([sc], dtype=Types.T_WEIGHT)
        scaling_init = torch.tensor([sc])
        bit_width = bw
        # zero_point = torch.tensor([0], dtype=Types.T_WEIGHT)
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
    :param round_mode: type of float to int implementation, alloed are ['floor', 'ceil', 'round']
    :return: class of fixed point quantization
    """
    scale = (2**(bit_width-signed)-narrow_range-(1-signed)) / 2**(bit_width-int_width)
    
    return create_int_quant(scale=scale, 
                            bit_width=bit_width, 
                            _narrow_range=narrow_range, 
                            _signed=signed,
                            round_mode=round_mode)


class BinaryQuant(ExtendedInjector):
    """
    Create binary quantizer
    """
    tensor_quant = bv_quant.BinaryQuant
    scaling_impl = bv_scaling.ConstScaling(torch.tensor([1], dtype=Types.T_WEIGHT))
    scaling_init = torch.tensor([1], dtype=Types.T_WEIGHT)
    requires_input_scale = False
    requires_input_bit_width = False


def create_binary_quant():
    return BinaryQuant


class CustomRound(torch.autograd.Function):
    @staticmethod
    def forward(ctx, x):
        x_r = torch.round(x)
        ctx.save_for_backward(x)
        return x_r

    @staticmethod
    def backward(ctx, grad_out):
        # x, = ctx.saved_tensors
        # x = x+0.5
        # x_r = torch.round(x)
        # delta = x-x_r
        # d_2 = delta**2
        # pow_ = d_2 + d_2**5        
        # round_qrad = pow_ * 0.5
        return grad_out
        # return grad_out+round_qrad

def custom_round(x):
    # return CustomRound.apply(x)
    return bv_fcn.round_ste(x)

def custom_clamp(x, min_val, max_val):
    # return CustomClamp.apply(x, min_val, max_val)
    return bv_fcn.tensor_clamp(x, min_val, max_val)

def sigmoid(x:torch.Tensor):
    e = torch.exp(x)
    return e / (e+1)

MUL = 2

def logistic(x):
    mul = MUL
    # v = sigmoid(x)
    # v = torch.tanh(mul*x)/2+0.5
    v = custom_clamp(mul*x+1.0*mul,fp32(0.0),fp32(1.0))
    return v

def delogistic(v):
    demul = 1 / MUL
    p = torch.tensor(v, dtype=torch.float32) if type(v) is not torch.Tensor else v
    # arg = torch.log(p/(1-p+1e-5))
    # arg = torch.arctanh(p*2-1)
    arg = p-1.0*MUL
    
    return arg*demul
    

class RunningStat(torch.nn.Module):
    def __init__(self, stat_fcn, init_val, lr=0.1) -> None:
        super().__init__()
        self.stat_fcn = stat_fcn
        self.value = torch.nn.Parameter(fp32(init_val), requires_grad=False)
        self.lr = lr
        
    def forward(self, x):
        with torch.no_grad():
            self.value *= (1.0-self.lr)
            self.value += self.lr*self.stat_fcn(x)
        # return self.value


class ParameterSigned(SM):
    def __init__(self, init_sign, trainable=True) -> None:
        super().__init__()
        init_sign = delogistic(init_sign)
        self.sign = torch.nn.Parameter(fp32(init_sign), requires_grad=trainable)
        
    @brevitas.jit.script_method
    def forward(self, x:torch.Tensor=None):
        # get param
        sign = get_int(self.sign, 0.0, 1.0)
        return sign        

class ParameterBitWidth(SM):
    def __init__(self, init_bit_width, max_bit_width,min_bit_width, trainable=True) -> None:
        super().__init__()
        min_bit_width = max(2,min_bit_width)
        bw = delogistic((init_bit_width-min_bit_width) / (max_bit_width-min_bit_width+1e-5))
        self.bit_width = torch.nn.Parameter(bw, requires_grad=trainable)
        self.max_bit_width = torch.nn.Parameter(fp32(max_bit_width), requires_grad=False)
        self.min_bit_width = torch.nn.Parameter(fp32(min_bit_width), requires_grad=False)
        
    @brevitas.jit.script_method
    def forward(self, x:torch.Tensor=None):
        if x is None:
            # run statistics
            pass
        bw = get_int(self.bit_width,self.min_bit_width, self.max_bit_width)
        return bw

class ParameterScaleFixedPoint(SM):
    
    def __init__(self, 
                 bit_width_impl, 
                #  signed,  
                 signed_impl, 
                 frac_part:Union[int,float,torch.Tensor], 
                 trainable=True) -> None:
        super().__init__()
        # it allows pass numerical values
        signed_impl = signed_impl if isinstance(signed_impl,ParameterSigned) else lambda x=None,val=signed_impl:val
        
        frac_part = delogistic(frac_part/(bit_width_impl()-signed_impl()*1.0))
        self.frac_part = torch.nn.Parameter(frac_part,
                                            requires_grad=trainable)
        self.signed_impl= signed_impl
        self.bit_width_impl = bit_width_impl
        
    @brevitas.jit.script_method
    def forward(self, x:torch.Tensor=None):
        if x is not None:
            # run statistics
            pass
        bw = self.bit_width_impl()
        signed = self.signed_impl()
        bits= bw-signed
        frac_part = get_int(self.frac_part,0.0, bits)
        
        scale = (2**(bits) - (1-signed) )/ 2**(frac_part)
        
        return scale


def get_int(f, min_, max_, with_quant=True):
    i = (max_ - min_)*logistic(f) + min_
    if with_quant:
        i = bv_fcn.round_ste(i)
        # i = custom_round(i)
    return i

def fp32(v):
    return torch.tensor(v,dtype=torch.float32) if not issubclass(v.__class__,torch.Tensor) else v


class ParametrizedFixedPointQuantizer(SM):
    ROUNDS = {
              'round':bv_os.RoundSte(), 
              'floor': bv_os.FloorSte(), 
              'ceil':bv_os.CeilSte()
              }
    
    def __init__(self, 
                 max_bit_width=8,
                 min_bit_width=2,
                 bit_width=7,
                 frac_part=5,
                 signed=0.51,
                 round_mode='round',
                 trainable_signed=True,
                 trainable_scale=True,
                 trainable_bit_width=True,
                 ) -> None:
        super().__init__()
        self.round_mode = round_mode
        self.round_method = ParametrizedFixedPointQuantizer.ROUNDS[round_mode]
        # to bool
        # parameters order has metter !!!
        # order should start from the mostly dependent (on the rest) to no dependent from previous
        # create parameters
        signed_impl = ParameterSigned(signed, trainable=trainable_signed)
        bit_width_impl = ParameterBitWidth(init_bit_width=bit_width,
                                           max_bit_width=max_bit_width,
                                           min_bit_width=min_bit_width,
                                           trainable=trainable_bit_width)
        # asign them
        self.scale_impl = ParameterScaleFixedPoint(bit_width_impl,
                                                   signed_impl,
                                                   frac_part,
                                                   trainable=trainable_scale)
        self.bit_width_impl = bit_width_impl
        self.signed_impl = signed_impl
        self.zero_point = fp32(0.0)
    
    @property
    def signed(self):
        return self.signed_impl()
    
    @property
    def bit_width(self):
        return self.bit_width_impl()
    
    @property
    def scale(self):
        return self.scale_impl()
        
    @property
    def narrow_range(self):
        return False
        
    @property
    def float_to_int_impl(self):
        return self.round_mode
        
    def quantize(self, x, scale, bit_width, signed):
        # to int range
        x = x * (1/scale)
        # get limits
        min_val = -signed*2**(bit_width-signed)
        max_val = 2**(bit_width-signed)-1.0
        offset = min_val
        int_range = max_val-min_val
        # round to nearest int
        x = self.round_method(x)
        # apply limits
        x = custom_clamp(x-offset, fp32(0.0), fp32(int_range))
        # x = tensor_clamp(x-offset, fp32(0.0), fp32(int_range))
        # back to float
        x = x + offset
        x = x * scale
        
        return x
    
    def get_repr(self):
        bw = self.bit_width_impl()
        signed = self.signed_impl()
        bits= bw-signed
        pow_frac = (2**(bits) - (1-signed) ) / self.scale_impl()
        frac_part = torch.log2(pow_frac)
        
        return bw.to(int).item(), (bw - frac_part).to(int).item(), (signed > 0.5).to(bool).item()
         
    @brevitas.jit.script_method
    def forward(self, x:torch.tensor):
        bw = self.bit_width_impl(x)
        sign = self.signed_impl(x)
        # # recalculate scale
        scale = self.scale_impl(x) / (2**(bw-sign)-(1-sign))
        # # quantize tensor
        t = self.quantize(x, scale, bw, sign)
        # # pack as QuantTensor
        # qt = (t, scale, fp32(0.0).to(x.device), bw, sign > 0.5)
        qt = (t, scale, fp32(0.0).to(x.device), bw)
        
        return qt


def generalized_auto_fxp(
                        bit_width=6,
                        frac_part=4,
                        signed=0.51,
                        round_mode='round',
                        max_bit_width=8,
                        min_bit_width=2,
                        trainable_signed=True,
                        trainable_scale=True,
                        trainable_bit_width=True,
                        dst='act'
                        ):
    bw = bit_width
    fp = frac_part
    sign = signed
    rm = round_mode
    maxbw = max_bit_width
    minbw = max(2,min_bit_width)
    train_sign=trainable_signed
    train_scale=trainable_scale
    train_bw=trainable_bit_width
    
    proxies = {'act':bv_sol.ActQuantSolver,
             'bias':bv_sol.BiasQuantSolver,
             'weight':bv_sol.WeightQuantSolver,
            }
    
    proxy = proxies[dst]
    
    class GFXP(proxy):
        tensor_quant = ParametrizedFixedPointQuantizer
        
        max_bit_width = maxbw
        min_bit_width = minbw
        bit_width = bw
        frac_part = fp
        signed = sign
        round_mode = rm
        
        requires_input_scale = False
        requires_input_bit_width = False
        requires_output_scale = False
        requires_output_bit_width = False
        
        trainable_signed=train_sign
        trainable_scale=train_scale
        trainable_bit_width=train_bw
    
    return GFXP

# ROUND
Q8_1U = create_fixed_point_quant(8,1, signed=False)
Q8_1 = create_fixed_point_quant(8,1)
Q8_2 = create_fixed_point_quant(8,2)
Q8_3 = create_fixed_point_quant(8,3)
Q4_1 = create_fixed_point_quant(4,1)
Q4_2 = create_fixed_point_quant(4,2)
# BINARY
Qb = create_binary_quant()
# FLOOR
Q8_1U_F = create_fixed_point_quant(8,1, signed=False, round_mode='floor')
Q8_1_F = create_fixed_point_quant(8,1, round_mode='floor')
Q8_2_F = create_fixed_point_quant(8,2, round_mode='floor')
Q8_3_F = create_fixed_point_quant(8,3, round_mode='floor')
Q4_1_F = create_fixed_point_quant(4,1, round_mode='floor')
Q4_2_F = create_fixed_point_quant(4,2, round_mode='floor')
# CEIL
Q8_1U_C = create_fixed_point_quant(8,1, signed=False, round_mode='ceil')
Q8_1_C = create_fixed_point_quant(8,1, round_mode='ceil')
Q8_2_C = create_fixed_point_quant(8,2, round_mode='ceil')
Q8_3_C = create_fixed_point_quant(8,3, round_mode='ceil')
Q4_1_C = create_fixed_point_quant(4,1, round_mode='ceil')
Q4_2_C = create_fixed_point_quant(4,2, round_mode='ceil')


if __name__ == '__main__':
    torch.manual_seed(0)
    use_cuda = torch.cuda.is_available()
    device = torch.device("cuda" if use_cuda else "cpu")
    print("Device:", device)
    from brevitas import nn
    
    Qi = generalized_auto_fxp(8,8, signed=0.1, round_mode='floor', 
                                max_bit_width=8, min_bit_width=8, trainable_signed=False, dst='act')
    Qw = generalized_auto_fxp(8,7, signed=0.7, round_mode='round', dst='weight')
    Qb = generalized_auto_fxp(8,7, signed=0.7, round_mode='round', dst='bias')
    Qa = generalized_auto_fxp(3,0.49, signed=0.9, round_mode='floor',max_bit_width=4, dst='act')
    Qau = generalized_auto_fxp(3,0.49, signed=0.1, round_mode='floor',max_bit_width=4, dst='act')
    
    net = torch.nn.Sequential(
                              nn.QuantIdentity(act_quant=Qi,return_quant_tensor=True),
                              
                              nn.QuantConv2d(1,8,3,bias=False,padding=0,weight_quant=Qw,bias_quant=Qb, return_quant_tensor=True),
                              nn.QuantIdentity(act_quant=Qa,return_quant_tensor=False),
                              torch.nn.BatchNorm2d(8),
                              nn.QuantReLU(act_quant=Qau,return_quant_tensor=True),
                              
                              nn.QuantConv2d(8,16,3,bias=False,padding=0,weight_quant=Qw,bias_quant=Qb, return_quant_tensor=True),
                              nn.QuantIdentity(act_quant=Qa,return_quant_tensor=False),
                              torch.nn.BatchNorm2d(16),
                              nn.QuantReLU(act_quant=Qau,return_quant_tensor=True),
                              nn.QuantMaxPool2d(2,2),
                              
                              nn.QuantConv2d(16,32,3,bias=True,padding=0,weight_quant=Qw,bias_quant=Qb, return_quant_tensor=True),
                              nn.QuantIdentity(act_quant=Qa,return_quant_tensor=False),
                              torch.nn.BatchNorm2d(32),
                              nn.QuantReLU(act_quant=Qau,return_quant_tensor=True),
                              
                              nn.QuantConv2d(32,64,3,bias=False,padding=0,weight_quant=Qw,bias_quant=Qb, return_quant_tensor=True),
                              nn.QuantIdentity(act_quant=Qa,return_quant_tensor=False),
                              torch.nn.BatchNorm2d(64),
                              nn.QuantReLU(act_quant=Qau,return_quant_tensor=True),
                              
                              nn.QuantConv2d(64,10,2,bias=True,padding=0,weight_quant=Qw,bias_quant=Qb, return_quant_tensor=True),
                              nn.QuantIdentity(act_quant=Qa,return_quant_tensor=False),
                            #   torch.nn.BatchNorm2d(128),
                            #   nn.QuantReLU(act_quant=Qa,return_quant_tensor=True),
                              
                              torch.nn.Flatten(),
                              
                            #   nn.QuantLinear(128,10,bias=True, weight_quant=Qw,bias_quant=Qb, return_quant_tensor=True),
                            #   nn.QuantIdentity(act_quant=Qa, return_quant_tensor=False),
                              
                              torch.nn.Sigmoid()
                              )
    
    
    def print_sd(prefix, net):
        print(prefix)
        sd = net.state_dict()
        new_sd = {}
        K = '.tensor_quant.'
        for k,v in sd.items():
            beg = k.find(K)
            if beg != -1:
                end = beg+len(K)
                mk = k[:beg]
                sk = k[end:]
                if mk not in new_sd.keys():
                    new_sd[mk] = {}
                
                new_sd[mk][sk] = v
        # return
        for mk,d in new_sd.items():
            mbw = d['bit_width_impl.max_bit_width']
            minbw = d['bit_width_impl.min_bit_width']
            bw_param = d['bit_width_impl.bit_width']
            s_param = d['signed_impl.sign']
            fp_param = d['scale_impl.frac_part']      
            
            bw = get_int(bw_param, minbw, mbw, False)
            s = get_int(s_param,0.0,1.0, False)
            fp = get_int(fp_param,0.0,custom_round(bw)-custom_round(s), False)      
            
            print('{:45} => ({:1.5f}, {:1.5f}, {:1.5f})->({},{:5},{})'
                  .format(mk, bw.item(),s.item(),fp.item(), 
                          custom_round(bw).int().item(),
                          str(custom_round(s).item() > 0.5),
                          custom_round(fp).int().item()))
        
        print()
        
    from torchvision import transforms, datasets
    
    def acc(net, gen, device):
        pos = 0
        all = 0
        for X,y in gen:
            y_pred = net(X.to(device))
            y = y.to(device)
            y_pred = torch.argmax(y_pred,1)
            cmp = y == y_pred
            pos += cmp.sum().item()
            all += len(y)
        
        acc_ = pos / all
        print('Accuracy:', acc_)
        
    cuda_kwargs = {'num_workers': 1,
                   'pin_memory': True,
                   'shuffle': True} if use_cuda else {}
    
    transform=transforms.Compose([
        transforms.ToTensor(),
        transforms.Resize((16,16)),
        transforms.RandomAffine(20,),
        ])
    
    # dataset1 = datasets.MNIST('../tmp', train=True, download=True,
    #                    transform=transform,)
    # train_loader = torch.utils.data.DataLoader(dataset1, batch_size=128,**cuda_kwargs)
    
    dataset2 = datasets.MNIST('../tmp', train=False,
                       transform=transform)
    test_loader = torch.utils.data.DataLoader(dataset2, batch_size=128,**cuda_kwargs)
    train_loader = test_loader
    
    net = net.to(device)
    net.train()
    
    for m in net.modules():
        if type(m) is ParametrizedFixedPointQuantizer:
            # m.requires_grad_(False)
            # m.signed.requires_grad_(False)
            # m.bit_width.requires_grad_(False)
            # m.max_bit_width.requires_grad_(False)
            pass
        
    opt = torch.optim.Adagrad(net.parameters(),0.1)
    
    import torch.nn.functional as F
    
    loss = torch.nn.CrossEntropyLoss()
    
    def bit_reg(net:torch.nn.Module):
        BW = '.bit_width'
        params = []
        for m in net.modules():
            if isinstance(m, ParameterBitWidth):
                params.append(m())

        e = sum(params)
        return e
    
    for i in range(100):
        print_sd(str(i)+'->',net)
        e = 0
        pos = 0
        all = 0
        
        for j, (X,y) in enumerate(train_loader):
            y_pred = net(X.to(device))
            
            y = y.to(device)
            err = loss(y_pred,y) + 1e-3*bit_reg(net) 
            err = err / len(train_loader)
            e += err.detach().cpu().item()
            err.backward()
            
            pos += (torch.argmax(y_pred.detach(),1) == y).sum().item()
            all += len(y)
        
        opt.step()
        opt.zero_grad()
        print("Error:", e, "Acc:",pos / all)
        
    
    print_sd('FINISH ->',net)
    net.eval()
    acc(net,test_loader,device)    
        
        
        
    
    