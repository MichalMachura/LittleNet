# GENETARED BY NNDCT, DO NOT EDIT!

import torch
import pytorch_nndct as py_nndct
class Sequential(torch.nn.Module):
    def __init__(self):
        super(Sequential, self).__init__()
        self.module_0 = py_nndct.nn.Input() #Sequential::input_0
        self.module_1 = py_nndct.nn.Conv2d(in_channels=3, out_channels=16, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/Conv2d[0]/input.2
        self.module_3 = py_nndct.nn.Conv2d(in_channels=16, out_channels=16, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=16, bias=True) #Sequential::Sequential/Clamp[2]/Conv2d[conv1]/input.4
        self.module_4 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[2]/ReLU[r]/93
        self.module_5 = py_nndct.nn.Conv2d(in_channels=16, out_channels=16, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=16, bias=True) #Sequential::Sequential/Clamp[2]/Conv2d[conv2]/input.5
        self.module_6 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[2]/ReLU[r]/input.6
        self.module_7 = py_nndct.nn.Conv2d(in_channels=16, out_channels=16, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=16, bias=True) #Sequential::Sequential/Clamp[2]/Conv2d[conv3]/114
        self.module_8 = py_nndct.nn.Add() #Sequential::Sequential/Clamp[2]/116
        self.module_9 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/MaxPool2d[3]/input.7
        self.module_10 = py_nndct.nn.Conv2d(in_channels=16, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/Conv2d[4]/input.8
        self.module_12 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/Clamp[6]/Conv2d[conv1]/input.10
        self.module_13 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[6]/ReLU[r]/149
        self.module_14 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/Clamp[6]/Conv2d[conv2]/input.11
        self.module_15 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[6]/ReLU[r]/input.12
        self.module_16 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/Clamp[6]/Conv2d[conv3]/170
        self.module_17 = py_nndct.nn.Add() #Sequential::Sequential/Clamp[6]/172
        self.module_18 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/MaxPool2d[7]/input.13
        self.module_19 = py_nndct.nn.Conv2d(in_channels=32, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/Conv2d[8]/input.14
        self.module_21 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[10]/Conv2d[conv1]/input.16
        self.module_22 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[10]/ReLU[r]/205
        self.module_23 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[10]/Conv2d[conv2]/input.17
        self.module_24 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[10]/ReLU[r]/input.18
        self.module_25 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[10]/Conv2d[conv3]/226
        self.module_26 = py_nndct.nn.Add() #Sequential::Sequential/Clamp[10]/228
        self.module_27 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/MaxPool2d[11]/input.19
        self.module_28 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/Conv2d[12]/input.20
        self.module_30 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[14]/Conv2d[conv1]/input.22
        self.module_31 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[14]/ReLU[r]/261
        self.module_32 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[14]/Conv2d[conv2]/input.23
        self.module_33 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[14]/ReLU[r]/input.24
        self.module_34 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[14]/Conv2d[conv3]/282
        self.module_35 = py_nndct.nn.Add() #Sequential::Sequential/Clamp[14]/284
        self.module_36 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/MaxPool2d[15]/input.25
        self.module_37 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/Conv2d[16]/input.26
        self.module_39 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[18]/Conv2d[conv1]/input.28
        self.module_40 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[18]/ReLU[r]/317
        self.module_41 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[18]/Conv2d[conv2]/input.29
        self.module_42 = py_nndct.nn.ReLU(inplace=False) #Sequential::Sequential/Clamp[18]/ReLU[r]/input.30
        self.module_43 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/Clamp[18]/Conv2d[conv3]/338
        self.module_44 = py_nndct.nn.Add() #Sequential::Sequential/Clamp[18]/input.31
        self.module_45 = py_nndct.nn.Conv2d(in_channels=64, out_channels=30, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/Conv2d[19]/input

    def forward(self, *args):
        self.output_module_0 = self.module_0(input=args[0])
        self.output_module_1 = self.module_1(self.output_module_0)
        self.output_module_3 = self.module_3(self.output_module_1)
        self.output_module_4 = self.module_4(self.output_module_3)
        self.output_module_5 = self.module_5(self.output_module_1)
        self.output_module_6 = self.module_6(self.output_module_5)
        self.output_module_7 = self.module_7(self.output_module_6)
        self.output_module_8 = self.module_8(input=self.output_module_4, alpha=1, other=self.output_module_7)
        self.output_module_9 = self.module_9(self.output_module_8)
        self.output_module_10 = self.module_10(self.output_module_9)
        self.output_module_12 = self.module_12(self.output_module_10)
        self.output_module_13 = self.module_13(self.output_module_12)
        self.output_module_14 = self.module_14(self.output_module_10)
        self.output_module_15 = self.module_15(self.output_module_14)
        self.output_module_16 = self.module_16(self.output_module_15)
        self.output_module_17 = self.module_17(input=self.output_module_13, alpha=1, other=self.output_module_16)
        self.output_module_18 = self.module_18(self.output_module_17)
        self.output_module_19 = self.module_19(self.output_module_18)
        self.output_module_21 = self.module_21(self.output_module_19)
        self.output_module_22 = self.module_22(self.output_module_21)
        self.output_module_23 = self.module_23(self.output_module_19)
        self.output_module_24 = self.module_24(self.output_module_23)
        self.output_module_25 = self.module_25(self.output_module_24)
        self.output_module_26 = self.module_26(input=self.output_module_22, alpha=1, other=self.output_module_25)
        self.output_module_27 = self.module_27(self.output_module_26)
        self.output_module_28 = self.module_28(self.output_module_27)
        self.output_module_30 = self.module_30(self.output_module_28)
        self.output_module_31 = self.module_31(self.output_module_30)
        self.output_module_32 = self.module_32(self.output_module_28)
        self.output_module_33 = self.module_33(self.output_module_32)
        self.output_module_34 = self.module_34(self.output_module_33)
        self.output_module_35 = self.module_35(input=self.output_module_31, alpha=1, other=self.output_module_34)
        self.output_module_36 = self.module_36(self.output_module_35)
        self.output_module_37 = self.module_37(self.output_module_36)
        self.output_module_39 = self.module_39(self.output_module_37)
        self.output_module_40 = self.module_40(self.output_module_39)
        self.output_module_41 = self.module_41(self.output_module_37)
        self.output_module_42 = self.module_42(self.output_module_41)
        self.output_module_43 = self.module_43(self.output_module_42)
        self.output_module_44 = self.module_44(input=self.output_module_40, alpha=1, other=self.output_module_43)
        self.output_module_45 = self.module_45(self.output_module_44)
        return self.output_module_45
