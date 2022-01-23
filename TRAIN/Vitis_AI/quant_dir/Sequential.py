# GENETARED BY NNDCT, DO NOT EDIT!

import torch
import pytorch_nndct as py_nndct
class Sequential(torch.nn.Module):
    def __init__(self):
        super(Sequential, self).__init__()
        self.module_0 = py_nndct.nn.Input() #Sequential::input_0
        self.module_1 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[0]/input.1
        self.module_2 = py_nndct.nn.Conv2d(in_channels=6, out_channels=6, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=6, bias=True) #Sequential::Sequential/DWConv2d[0]/Conv2d[conv]/input.2
        self.module_4 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[0]/ReLU[relu]/input.4
        self.module_5 = py_nndct.nn.Conv2d(in_channels=6, out_channels=8, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[1]/Conv2d[conv]/input.5
        self.module_7 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[1]/MaxPool2d[mp]/input.6
        self.module_8 = py_nndct.nn.Conv2d(in_channels=8, out_channels=8, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=8, bias=True) #Sequential::Sequential/DWConv2d[2]/Conv2d[conv]/input.7
        self.module_10 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[3]/input.8
        self.module_11 = py_nndct.nn.Conv2d(in_channels=16, out_channels=16, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=16, bias=True) #Sequential::Sequential/DWConv2d[3]/Conv2d[conv]/input.9
        self.module_13 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[3]/ReLU[relu]/input.11
        self.module_14 = py_nndct.nn.Conv2d(in_channels=16, out_channels=32, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[4]/Conv2d[conv]/input.12
        self.module_16 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[4]/MaxPool2d[mp]/input.13
        self.module_17 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/DWConv2d[5]/Conv2d[conv]/input.14
        self.module_19 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[6]/input.15
        self.module_20 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[6]/Conv2d[conv]/input.16
        self.module_22 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[6]/ReLU[relu]/input.18
        self.module_23 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[7]/Conv2d[conv]/input.19
        self.module_25 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[7]/MaxPool2d[mp]/input.20
        self.module_26 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[8]/Conv2d[conv]/input.21
        self.module_28 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[9]/input.22
        self.module_29 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[9]/Conv2d[conv]/input.23
        self.module_31 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[9]/ReLU[relu]/input.25
        self.module_32 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[10]/Conv2d[conv]/input.26
        self.module_34 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[10]/ReLU[relu]/327
        self.module_35 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[10]/MaxPool2d[mp]/input.28
        self.module_36 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[11]/Conv2d[conv]/input.29
        self.module_38 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[12]/input.30
        self.module_39 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[12]/Conv2d[conv]/input.31
        self.module_41 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[12]/ReLU[relu]/input.33
        self.module_42 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[13]/Conv2d[conv]/input.34
        self.module_44 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[13]/ReLU[relu]/input.36
        self.module_45 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[14]/Conv2d[conv]/input.37
        self.module_47 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[15]/input.38
        self.module_48 = py_nndct.nn.Conv2d(in_channels=512, out_channels=512, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=512, bias=True) #Sequential::Sequential/DWConv2d[15]/Conv2d[conv]/input.39
        self.module_50 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[15]/ReLU[relu]/input.41
        self.module_51 = py_nndct.nn.Conv2d(in_channels=512, out_channels=256, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[16]/Conv2d[conv]/input.42
        self.module_53 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[16]/ReLU[relu]/input.44
        self.module_54 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[17]/Conv2d[conv]/input.45
        self.module_56 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[17]/ReLU[relu]/input
        self.module_57 = py_nndct.nn.Conv2d(in_channels=256, out_channels=15, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[18]/Conv2d[conv]/460

    def forward(self, *args):
        self.output_module_0 = self.module_0(input=args[0])
        self.output_module_1 = self.module_1(tensors=[self.output_module_0,self.output_module_0], dim=1)
        self.output_module_2 = self.module_2(self.output_module_1)
        self.output_module_4 = self.module_4(self.output_module_2)
        self.output_module_5 = self.module_5(self.output_module_4)
        self.output_module_7 = self.module_7(self.output_module_5)
        self.output_module_8 = self.module_8(self.output_module_7)
        self.output_module_10 = self.module_10(tensors=[self.output_module_8,self.output_module_8], dim=1)
        self.output_module_11 = self.module_11(self.output_module_10)
        self.output_module_13 = self.module_13(self.output_module_11)
        self.output_module_14 = self.module_14(self.output_module_13)
        self.output_module_16 = self.module_16(self.output_module_14)
        self.output_module_17 = self.module_17(self.output_module_16)
        self.output_module_19 = self.module_19(tensors=[self.output_module_17,self.output_module_17], dim=1)
        self.output_module_20 = self.module_20(self.output_module_19)
        self.output_module_22 = self.module_22(self.output_module_20)
        self.output_module_23 = self.module_23(self.output_module_22)
        self.output_module_25 = self.module_25(self.output_module_23)
        self.output_module_26 = self.module_26(self.output_module_25)
        self.output_module_28 = self.module_28(tensors=[self.output_module_26,self.output_module_26], dim=1)
        self.output_module_29 = self.module_29(self.output_module_28)
        self.output_module_31 = self.module_31(self.output_module_29)
        self.output_module_32 = self.module_32(self.output_module_31)
        self.output_module_34 = self.module_34(self.output_module_32)
        self.output_module_35 = self.module_35(self.output_module_34)
        self.output_module_36 = self.module_36(self.output_module_35)
        self.output_module_38 = self.module_38(tensors=[self.output_module_36,self.output_module_36], dim=1)
        self.output_module_39 = self.module_39(self.output_module_38)
        self.output_module_41 = self.module_41(self.output_module_39)
        self.output_module_42 = self.module_42(self.output_module_41)
        self.output_module_44 = self.module_44(self.output_module_42)
        self.output_module_45 = self.module_45(self.output_module_44)
        self.output_module_47 = self.module_47(tensors=[self.output_module_45,self.output_module_45], dim=1)
        self.output_module_48 = self.module_48(self.output_module_47)
        self.output_module_50 = self.module_50(self.output_module_48)
        self.output_module_51 = self.module_51(self.output_module_50)
        self.output_module_53 = self.module_53(self.output_module_51)
        self.output_module_54 = self.module_54(self.output_module_53)
        self.output_module_56 = self.module_56(self.output_module_54)
        self.output_module_57 = self.module_57(self.output_module_56)
        return self.output_module_57
