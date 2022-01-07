from data_types import Types
import torch
import copy
from typing import OrderedDict, Union
import typing
import unittest
import networks

from torch._C import device


bit_size = {torch.uint8:8,
            # torch.int8:8,
            # torch.int16:16,
            # torch.int32:32,
            # torch.int64:64
            }
            
FLOAT_TYPE = torch.float32


####################################
# QUANT TENSORS
####################################
class QuantizedTensor:
    
    def __init__(self, tensor:torch.Tensor=None):	
        self.tensor = tensor
        
    def float(self):
        return self.to(torch.float32)
    
    def to(self, dtype=torch.float32):
        return self.tensor.to(dtype)
    
    def copy(self):
        return copy.copy(self)
    
    def __repr__(self):
        return self.__str__()
    
    def __str__(self) -> str:
        d = self.__dict__.copy()
        d['tensor'] = self.float()
        v = list(d.values())
        
        return str(tuple(v))


class FixedPointTensor(QuantizedTensor):
    
    def __init__(self, tensor:torch.Tensor, bit_width:int=8, int_width:int=8, sign:bool=True):
        if tensor.dtype != torch.uint8:
            raise Exception("For FixedPointTensor uint8 tensor is required")
            
        super().__init__(tensor=tensor)
        self.bit_width = bit_width
        self.int_width = int_width
        self.sign = sign
        
    def to(self, dtype=torch.float32):
        frac_width = self.bit_width-self.int_width
        # clear unused part with sign bit
        unused_bits = bit_size[self.tensor.dtype] - self.bit_width + self.sign
        cleared = (self.tensor << unused_bits) >> unused_bits
        # get sign
        if self.sign:
            # == max abs negative
            sign = -torch.bitwise_and(torch.tensor(2**(self.bit_width-1), dtype=self.tensor.dtype, device=self.tensor.device), self.tensor).to(torch.int32)
            value = (sign + cleared.to(torch.int32))
        else:
            value = cleared
        
        value = value.to(dtype) / (2**(frac_width))
        
        return value.to(dtype)


class BinaryTensor(QuantizedTensor):

    def __init__(self, tensor:torch.Tensor):
        if tensor.dtype != torch.bool:
            raise Exception("For BinaryTensor bool tensor is required")
            
        super().__init__(tensor=tensor)

    def to(self, dtype=torch.float32):
        return 2*self.tensor.to(dtype) - 1


####################################
# QUANTIZERS
####################################
class Identity(torch.nn.Module):
    
    def __init__(self, dtype=None):
        super().__init__()
        self.dst_dtype = dtype
        
    def forward(self, x):
        return x.to(self.dst_dtype)

    def __str__(self) -> str:
        return '(Identity)'


class Quantizer(Identity):
    def __init__(self, dtype=None):
        super().__init__(dtype)
    
    def __str__(self) -> str:
        return '(Quantizer-Identity)'
        
    def make_quant_tensor(self, x):
        return QuantizedTensor(x)


class BinaryQuantizer(Quantizer):
    
    def __init__(self, dtype=None):
        super().__init__(dtype)
    
    def __str__(self) -> str:
        return '(BinaryQuantizer)'
    
    def forward(self, x):
        return (2*(x > 0) - 1).to(self.dst_dtype if self.dst_dtype else torch.float32)
        
    def make_quant_tensor(self, x):
        return BinaryTensor(x > 0)


class FixedPointQuantizer(Quantizer):
    round_types ={'floor':torch.floor,
                  'round':torch.round,
                  'ceil':torch.ceil
                  }
    def __init__(self, bit_width:int=8, int_width=8,signed:bool=True, round_type:str='floor', dtype=None):
        super().__init__()
        self.bit_width = bit_width
        self.int_width = int_width
        self.signed = signed
        self.round_type = round_type
        
    def __str__(self) -> str:
        return str(('FixedPointQuantizer',self.bit_width,self.int_width, self.signed, self.round_type))
        
    def get_min_max(self):
        frac_width = self.bit_width - self.int_width
        min_ = -2**(self.int_width-self.signed) if self.signed else 0
        max_ = (2**(self.bit_width-self.signed) - 1) / 2**frac_width
        
        return min_, max_
    
    def forward(self, x):
        min_, max_ = self.get_min_max()
        fp_range = max_ - min_
        int_range = 2**self.bit_width - 1
        scale = int_range / fp_range
        # to int range
        x = x-min_
        x *= scale
        # quantization
        x = FixedPointQuantizer.round_types[self.round_type](x)
        x = torch.clip(x, 0, int_range)
        # back to fixed point range
        x *= 1/scale
        x += min_
        
        return x.to(self.dst_dtype) if self.dst_dtype is not None else x
    
    def make_quant_tensor(self, x):
        min_, max_ = self.get_min_max()
        fp_range = max_ - min_
        int_range = 2**self.bit_width - 1
        scale = int_range / fp_range
        s = self.signed*(x < 0)
        # to int range
        x = x-min_
        x = x*scale
        # quantization
        x = FixedPointQuantizer.round_types[self.round_type](x)
        # limit range
        x = torch.clip(x, 0, int_range).to(torch.uint8)
        # to add max abs negative value
        x -= self.signed*(2**(self.bit_width-self.signed))
        
        return FixedPointTensor(x, self.bit_width, self.int_width, self.signed)
        

####################################
# QUANTIZED LAYERS
####################################


class WeightQuantized(torch.nn.Module):
    def __init__(self):
        super().__init__()
        
    def _load_from_state_dict(self, state_dict, prefix, local_metadata, strict, missing_keys, unexpected_keys, error_msgs):
        p_len = len(prefix)
        for k, v in state_dict.items():
            if prefix == k[:p_len]:
                # if it's QuantizedTensor
                if isinstance(v, QuantizedTensor):
                    # make float tensor from it
                    state_dict[k] = v.float()
        
        return super()._load_from_state_dict(state_dict, prefix, local_metadata, strict, missing_keys, unexpected_keys, error_msgs)


class WrapperWeightQuantized(WeightQuantized):
    def __init__(self, module):
        super().__init__()
        self.module = module
        
    def forward(self, x):
        return self.module(x)


class InputQuantized(torch.nn.Module):
    def __init__(self, module, q_in:Quantizer=None):
        super().__init__()
        self.module = module
        self.q_in = q_in if q_in is not None else Quantizer()
        
    def forward(self, x):
        return self.module( self.q_in(x) )


class OutputQuantized(torch.nn.Module):
    def __init__(self, module, q_out:Quantizer=None):
        super().__init__()
        self.module = module
        self.q_out = q_out if q_out is not None else Quantizer()
        
    def forward(self, x):
        return self.q_out( self.module(x) )


class InOutQuantized(OutputQuantized):
    def __init__(self, module, q_in:Quantizer=None, q_out:Quantizer=None):
        super().__init__(InputQuantized(module, q_in), q_out)


def grad_off(model):
    for p in model.parameters():
        p.requires_grad = False


def quantized_dict_to_float(quant_dict, device=None):
    float_dict = {}
    for k, v in quant_dict.items():
        if isinstance(v, QuantizedTensor):
            # make float tensor from it
            float_dict[k] = v.float().to(device)
            
    return float_dict


##########################
# Test part
##########################
class Const:
    ALLOWED_EPS = 1e-5
    
    def same(t1:torch.Tensor,t2:torch.Tensor):
        diff = torch.abs(t1-t2) > Const.ALLOWED_EPS
        
        return diff.sum() == 0
     
     
class QuantizedTensor_Test(unittest.TestCase):
    
    def test_no_changes(self):
        t = torch.tensor([2.5,3.0,-4.2,-6436.4,-23535.5435,435436.4], dtype=FLOAT_TYPE)
        
        qt = QuantizedTensor(t)
        q = qt.float()
        
        t_ref = torch.tensor([2.5,3.0,-4.2,-6436.4,-23535.5435,435436.4], dtype=FLOAT_TYPE)
        
        self.assertTrue(Const.same(t,t_ref))
         
     
class FixedPointTensor_Test(unittest.TestCase):
    
    def test_8_8_u(self):
        t = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, -1], dtype=torch.uint8)
        
        qt = FixedPointTensor(t, 8,8,False)
        q = qt.float()
        
        t_ref = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, 255], dtype=FLOAT_TYPE)
        
        self.assertTrue(Const.same(q,t_ref))
        
    def test_8_8_s(self):
        t = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, -1], dtype=torch.uint8)
        
        qt = FixedPointTensor(t, 8,8,True)
        q = qt.float()
        
        t_ref = torch.tensor([0,1,2,4,8,16,32,64,127,-128,-128+5, -1, -1], dtype=FLOAT_TYPE)
        
        self.assertTrue(Const.same(q,t_ref))
        
    def test_8_0_u(self):
        t = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, -1], dtype=torch.uint8)
        
        qt = FixedPointTensor(t, 8,0,False)
        q = qt.float()
        
        t_ref = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, 255], dtype=FLOAT_TYPE)/256.0
        
        self.assertTrue(Const.same(q,t_ref))
        
    def test_8_1_s(self):
        t = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, -1], dtype=torch.uint8)
        
        qt = FixedPointTensor(t, 8,1,True)
        q = qt.float()
        
        t_ref = torch.tensor([0,2**-7,2**-6,2**-5,2**-4,
                              2**-3,2**-2,2**-1,1-2**-7,
                              -2**-0,-2**-0+2**-7+2**-5, 
                              -2**-7, -2**-7], dtype=FLOAT_TYPE)
        
        self.assertTrue(Const.same(q,t_ref))
    
    def test_8_4_s(self):
        t = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, -1], dtype=torch.uint8)
        
        qt = FixedPointTensor(t, 8,4,True)
        q = qt.float()
        
        t_ref = torch.tensor([0,2**-4,2**-3,2**-2,2**-1,
                              1,2,4,1+2+4+2**-1+2**-2+2**-3+2**-4,
                              -2**3,-2**3+2**-2+2**-4, 
                              -2**-4, -2**-4], dtype=FLOAT_TYPE)
        
        self.assertTrue(Const.same(q,t_ref))
        
        
class BinaryTensor_Test(unittest.TestCase):
    
    def test_b(self):
        t = torch.tensor([-1.0,-3.0,0.0,
                          5.0,5.6,-6.3,
                          128.0,-127.0]) >=0
        
        qt = BinaryTensor(t)
        q = qt.float()
        
        t_ref = torch.tensor([-1.0,-1.0,1.0,
                              1.0,1.0,-1.0,
                              1.0,-1.0], dtype=FLOAT_TYPE)
        
        self.assertTrue(Const.same(q,t_ref))
        
        
class FixedPointQuantizer_Test(unittest.TestCase):
    
    def test_8_8_u_f(self):
        q = FixedPointQuantizer(8,8,False, 'floor')
        
        t = torch.tensor([1,2,4,127,128,255,256,-2,-127,-255,-256], dtype=torch.float32)
        t_ref = torch.tensor([1,2,4,127,128,255,255,0,0,0,0], dtype=torch.float32)
        
        qt = q.make_quant_tensor(t)
        
        rt = qt.float()
        t_quantized = q(t)
        
        self.assertTrue(Const.same(rt,t_ref))
        self.assertTrue(Const.same(t_quantized,t_ref))
    
    def test_8_8_s_f(self):
        q = FixedPointQuantizer(8,8,True, 'floor')
        
        t = torch.tensor([1,2,4,127,128,255,256,-2,-127,-255,-256], dtype=torch.float32)
        t_ref = torch.tensor([1,2,4,127,127,127,127,-2,-127,-128,-128], dtype=torch.float32)
        
        qt = q.make_quant_tensor(t)
        
        rt = qt.float()
        t_quantized = q(t)
        
        self.assertTrue(Const.same(rt,t_ref))
        self.assertTrue(Const.same(t_quantized,t_ref))
        
    def test_8_0_u_f(self):
        q = FixedPointQuantizer(8,0,False, 'floor')
        
        t = torch.tensor([1,2,4,127,128,255,256,-2,-127,-255,-256], dtype=torch.float32)/256
        t_ref = torch.tensor([1,2,4,127,128,255,255,0,0,0,0], dtype=torch.float32)/256
        
        qt = q.make_quant_tensor(t)
        
        rt = qt.float()
        t_quantized = q(t)
        
        self.assertTrue(Const.same(rt,t_ref))
        self.assertTrue(Const.same(t_quantized,t_ref))
        
    def test_8_2_s_f(self):
        q = FixedPointQuantizer(8,2, True, 'floor')
        
        t = torch.tensor(	 [0,2-2**-6,-2,2**-6,-3,5], dtype=torch.float32)
        t_ref = torch.tensor([0,2-2**-6,-2,2**-6,-2,2-2**-6], dtype=torch.float32)
        
        qt = q.make_quant_tensor(t)
        
        rt = qt.float()
        t_quantized = q(t)
        
        self.assertTrue(Const.same(rt,t_ref))
        self.assertTrue(Const.same(t_quantized,t_ref))

    def test_8_4_s_f(self):
        q = FixedPointQuantizer(8,4, True, 'floor')
        
        t = torch.tensor(	 [0, 2**3-2**-4, -2**3, 2**-4, -2**-4,   -13,    	  13,], dtype=torch.float32)
        t_ref = torch.tensor([0, 2**3-2**-4, -2**3, 2**-4, -2**-4, -2**3, 2**3-2**-4,], dtype=torch.float32)
        
        qt = q.make_quant_tensor(t)
        
        rt = qt.float()
        t_quantized = q(t)
        
        self.assertTrue(Const.same(rt,t_ref))
        self.assertTrue(Const.same(t_quantized,t_ref))
        
    def test_round_check_8_2_s_f(self):
        q = FixedPointQuantizer(8,2, True, 'floor')
        for eps in [(2**-6)/3, (2**-6)/2,2*(2**-6)/3]:
            t = torch.tensor([0,2-2**-6,-2,2**-6,-3,5], dtype=torch.float32)
            # add sth to check rounding
            t += eps
            t_ref = torch.tensor([0,2-2**-6,-2,2**-6,-2,2-2**-6], dtype=torch.float32)
            
            qt = q.make_quant_tensor(t)
            
            rt = qt.float()
            t_quantized = q(t)
            
            self.assertTrue(Const.same(rt,t_ref))
            self.assertTrue(Const.same(t_quantized,t_ref))
    
    def test_round_check_8_2_s_r(self):
        q = FixedPointQuantizer(8,2, True, 'round')
        for mul in [-1,1]:
            for eps in [(2**-6)/3, 2*(2**-6)/5,(2**-6)/5]:
                t = torch.tensor(	 [0,2-2**-6,-2,2**-6,-3,5], dtype=torch.float32)
                # add sth to check rounding
                t += mul*eps
                t_ref = torch.tensor([0,2-2**-6,-2,2**-6,-2,2-2**-6], dtype=torch.float32)
                
                qt = q.make_quant_tensor(t)
                
                rt = qt.float()
                t_quantized = q(t)
                self.assertTrue(Const.same(rt,t_ref))
                self.assertTrue(Const.same(t_quantized,t_ref))
    
    def test_round_check_8_2_s_c(self):
        q = FixedPointQuantizer(8,2, True, 'ceil')
        for eps in [(2**-6)/3, (2**-6)/2,2*(2**-6)/3]:
            t = torch.tensor([0,2-2**-6,-2,2**-6,-3,5], dtype=torch.float32)
            # subtract sth to check rounding
            t -= eps
            t_ref = torch.tensor([0,2-2**-6,-2,2**-6,-2,2-2**-6], dtype=torch.float32)
            
            qt = q.make_quant_tensor(t)
            
            rt = qt.float()
            t_quantized = q(t)
            
            self.assertTrue(Const.same(rt,t_ref))
            self.assertTrue(Const.same(t_quantized,t_ref))
    
    
class Quantizer_Test(unittest.TestCase):
    def test_identity(self):
        q = Quantizer()
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        
        qt = q.make_quant_tensor(t)
        
        rt = qt.float()
        t_quantized = q(t)
        
        self.assertTrue(Const.same(rt,t_ref))
        self.assertTrue(Const.same(t_quantized,t_ref))
        
        
class Identity_Test(unittest.TestCase):
    def test_identity(self):
        q = Identity()
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        
        t_quantized = q(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        

class InputQuantized_Test(unittest.TestCase):
    
    def test_quant_input(self):
        q_main = FixedPointQuantizer(8,4,True)
        q2 = FixedPointQuantizer(8,2,True)
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_main(q2(t.clone()))
        
        module = InputQuantized(q_main, q2)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        
    def test_non_quant_input(self):
        q_main = FixedPointQuantizer(8,4,True)
        q2 = None
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_main(t.clone())
        
        module = InputQuantized(q_main, q2)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        

class OutputQuantized_Test(unittest.TestCase):
    
    def test_quant_output(self):
        q_main = FixedPointQuantizer(8,4,True)
        q_out = FixedPointQuantizer(8,2,True)
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_out(q_main(t.clone()))
        
        module = OutputQuantized(q_main, q_out)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        
    def test_non_quant_output(self):
        q_main = FixedPointQuantizer(8,4,True)
        q_out = None
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_main(t.clone())
        
        module = InputQuantized(q_main, q_out)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        

class InOutQuantized_Test(unittest.TestCase):
    
    def test_quant_output(self):
        q_main = FixedPointQuantizer(8,4,True)
        q_in = FixedPointQuantizer(8,6,True)
        q_out = FixedPointQuantizer(8,2,True)
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_out(q_main(q_in(t.clone())))
        
        module = InOutQuantized(q_main, q_in, q_out)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        
    def test_non_quant_output(self):
        q_main = FixedPointQuantizer(8,4,True)
        q_in = FixedPointQuantizer(8,6,True)
        q_out = None
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_main(q_in(t.clone()))
        
        module = InOutQuantized(q_main, q_in, q_out)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        
    def test_non_quant_input(self):
        q_main = FixedPointQuantizer(8,4,True)
        q_in = None
        q_out = FixedPointQuantizer(8,2,True)
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_out(q_main(t.clone()))
        
        module = InOutQuantized(q_main, q_in, q_out)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))
        
        
    def test_non_quant_in_output(self):
        q_main = FixedPointQuantizer(8,4,True)
        q_in = None
        q_out = None
        
        t = torch.tensor([1,2,4.7,-34,34,-546.6456,-7657.4], dtype=torch.float32)
        t_ref = q_main(t.clone())
        
        module = InOutQuantized(q_main, q_in, q_out)
        
        t_quantized = module(t)
        
        self.assertTrue(Const.same(t_quantized,t_ref))


def __general_test__():
    t = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255, -1], dtype=torch.uint8)
    
    fpt = FixedPointTensor(t, 8, 8, sign=False)
    
    print(t)
    
    print("Fixed Point Tensors")
    for s in [True, False]:
        for b in [8,4,2,1]:
            for i in range(b,-1,-1):
                fpt.int_width = i
                fpt.bit_width = b
                fpt.sign = s
                # print(fpt)
                print('b:',b,'i:',i,'s:',s,'t:',fpt.float())
    
    print("Binary Tensors")
    t = torch.tensor([0,1,2,4,8,16,32,64,127,128,128+5, 255], dtype=torch.bool)
    t = torch.rand(5,3)-0.5 >= 0
    t = (torch.rand(5,3)*255).to(torch.int32)-128 >= 0
    
    bt = BinaryTensor(t)
    
    print(t)
    print(bt)
    print(bt.float())
    
    
    print("Quantized propagation")
    t = (torch.rand(1,1,5)*2 - 1)*5
    
    q_identity = Quantizer()
    q_f = FixedPointQuantizer(8,3,True,'floor')
    q_r = FixedPointQuantizer(8,3,True,'round')
    q_c = FixedPointQuantizer(8,3,True,'ceil')
    q_b = BinaryQuantizer()
    
    main_module = Identity()
    main_module = torch.nn.Conv1d(1,1, 3, padding=1).eval()
    with torch.no_grad():
        main_module.weight *= 0
        main_module.weight += 1
    
    for q in [q_f,q_r,q_c, q_b]:
        normal = main_module(t)
        q_in = InputQuantized(main_module, q)(t)
        q_out = OutputQuantized(main_module, q)(t)
        q_in_out = InOutQuantized(main_module, q, q)(t)
        
        print("quantizer:", q)
        print("input tensor:",t)
        print("normal:", normal)
        print("q_in:", q_in)
        print("q_out:", q_out)
        print("q_in_out:", q_in_out)
        print()
    
    
    print("Make quant tensor:")
    
    t = ((torch.rand(5)*2 -1)*5)
    q_n = Quantizer()
    q_fp = FixedPointQuantizer(6,3,True)
    q_b = BinaryQuantizer()
    
    print()
    for q in [q_n, q_fp, q_b]:
        print("quantizer:",q)
        print("t:",t)
        qt = q.make_quant_tensor(t)
        print("qt:",qt)
        rt = qt.float()
        print("rt:",rt)
        print()
        
    
    import networks as NET
    layers = [
             InOutQuantized(torch.nn.Conv2d(1,1,3, bias=True), FixedPointQuantizer(8,0,False), FixedPointQuantizer(8,2,True)),
             ]
    net = NET.Sequential(layers, return_quant_tensor=True, device='cpu')
    net.eval()
    t = (torch.rand(1,1,5,5)*2+1)*3
    
    print("tensor pass")
    print(t)
    print(net(t))
    
    grad_off(net)
        
    print("before")
    for p in net.parameters():
        print(p)
    
    sd = net.state_dict()
    for k,v in sd.items():
        # sd[k] = FixedPointQuantizer(8,2,True).make_quant_tensor(v)
        sd[k] = BinaryQuantizer().make_quant_tensor(v)
    
    sd = quantized_dict_to_float(sd)
    net.load_state_dict(sd)
    
    print("after")
    for p in net.parameters():
        print(p)
    
    print("tensor pass")
    print(t)
    print(net(t))


if __name__ == "__main__":
    # __general_test__()
    unittest.main()