# GENETARED BY NNDCT, DO NOT EDIT!

import torch
import pytorch_nndct as py_nndct
class Sequential(torch.nn.Module):
    def __init__(self):
        super(Sequential, self).__init__()
        self.module_0 = py_nndct.nn.Input() #Sequential::input_0
        self.module_1 = py_nndct.nn.Conv2d(in_channels=3, out_channels=3, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=3, bias=False) #Sequential::Sequential/DWConv2d[0]/Conv2d[0]/142
        self.module_2 = py_nndct.nn.Conv2d(in_channels=3, out_channels=3, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=3, bias=False) #Sequential::Sequential/DWConv2d[0]/Conv2d[1]/153
        self.module_3 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[0]/input.2
        self.module_4 = py_nndct.nn.Module('batch_norm',num_features=6, eps=1e-05, momentum=0.1) #Sequential::Sequential/DWConv2d[0]/BatchNorm2d[bn]/input.3
        self.module_5 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[0]/ReLU[relu]/input.4
        self.module_6 = py_nndct.nn.Conv2d(in_channels=6, out_channels=8, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[1]/Conv2d[conv]/input.5
        self.module_8 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[1]/MaxPool2d[mp]/input.6
        self.module_9 = py_nndct.nn.Conv2d(in_channels=8, out_channels=8, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=8, bias=True) #Sequential::Sequential/DWConv2d[2]/Conv2d[0]/input.7
        self.module_11 = py_nndct.nn.Conv2d(in_channels=8, out_channels=8, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=8, bias=False) #Sequential::Sequential/DWConv2d[3]/Conv2d[0]/209
        self.module_12 = py_nndct.nn.Conv2d(in_channels=8, out_channels=8, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=8, bias=False) #Sequential::Sequential/DWConv2d[3]/Conv2d[1]/220
        self.module_13 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[3]/input.9
        self.module_14 = py_nndct.nn.Module('batch_norm',num_features=16, eps=1e-05, momentum=0.1) #Sequential::Sequential/DWConv2d[3]/BatchNorm2d[bn]/input.10
        self.module_15 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[3]/ReLU[relu]/input.11
        self.module_16 = py_nndct.nn.Conv2d(in_channels=16, out_channels=32, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[4]/Conv2d[conv]/input.12
        self.module_18 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[4]/MaxPool2d[mp]/input.13
        self.module_19 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/DWConv2d[5]/Conv2d[0]/input.14
        self.module_21 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=32, bias=False) #Sequential::Sequential/DWConv2d[6]/Conv2d[0]/276
        self.module_22 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=32, bias=False) #Sequential::Sequential/DWConv2d[6]/Conv2d[1]/287
        self.module_23 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[6]/input.16
        self.module_24 = py_nndct.nn.Module('batch_norm',num_features=64, eps=1e-05, momentum=0.1) #Sequential::Sequential/DWConv2d[6]/BatchNorm2d[bn]/input.17
        self.module_25 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[6]/ReLU[relu]/input.18
        self.module_26 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[7]/Conv2d[conv]/input.19
        self.module_28 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[7]/MaxPool2d[mp]/input.20
        self.module_29 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[8]/Conv2d[0]/input.21
        self.module_31 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[9]/Conv2d[0]/343
        self.module_32 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[9]/Conv2d[1]/353
        self.module_33 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[9]/input.23
        self.module_34 = py_nndct.nn.Module('batch_norm',num_features=128, eps=1e-05, momentum=0.1) #Sequential::Sequential/DWConv2d[9]/BatchNorm2d[bn]/input.24
        self.module_35 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[9]/ReLU[relu]/input.25
        self.module_36 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[10]/Conv2d[conv]/input.26
        self.module_38 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[10]/ReLU[relu]/379
        self.module_39 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[10]/MaxPool2d[mp]/input.28
        self.module_40 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[11]/Conv2d[0]/input.29
        self.module_42 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[12]/Conv2d[0]/410
        self.module_43 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[12]/Conv2d[1]/420
        self.module_44 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[12]/input.31
        self.module_45 = py_nndct.nn.Module('batch_norm',num_features=256, eps=1e-05, momentum=0.1) #Sequential::Sequential/DWConv2d[12]/BatchNorm2d[bn]/input.32
        self.module_46 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[12]/ReLU[relu]/input.33
        self.module_47 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[13]/Conv2d[conv]/input.34
        self.module_49 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[13]/ReLU[relu]/input.36
        self.module_50 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[14]/Conv2d[0]/input.37
        self.module_52 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[15]/Conv2d[0]/470
        self.module_53 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[15]/Conv2d[1]/480
        self.module_54 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[15]/input.39
        self.module_55 = py_nndct.nn.Module('batch_norm',num_features=512, eps=1e-05, momentum=0.1) #Sequential::Sequential/DWConv2d[15]/BatchNorm2d[bn]/input.40
        self.module_56 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[15]/ReLU[relu]/input.41
        self.module_57 = py_nndct.nn.Conv2d(in_channels=512, out_channels=256, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[16]/Conv2d[conv]/input.42
        self.module_59 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[16]/ReLU[relu]/input.44
        self.module_60 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[17]/Conv2d[0]/input.45
        self.module_62 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[17]/ReLU[relu]/input
        self.module_63 = py_nndct.nn.Conv2d(in_channels=256, out_channels=15, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[18]/Conv2d[conv]/532

    def forward(self, *args):
        self.output_module_0 = self.module_0(input=args[0])
        self.output_module_1 = self.module_1(self.output_module_0)
        self.output_module_2 = self.module_2(self.output_module_0)
        self.output_module_3 = self.module_3(dim=1, tensors=[self.output_module_1,self.output_module_2])
        self.output_module_4 = self.module_4(self.output_module_3)
        self.output_module_5 = self.module_5(self.output_module_4)
        self.output_module_6 = self.module_6(self.output_module_5)
        self.output_module_8 = self.module_8(self.output_module_6)
        self.output_module_9 = self.module_9(self.output_module_8)
        self.output_module_11 = self.module_11(self.output_module_9)
        self.output_module_12 = self.module_12(self.output_module_9)
        self.output_module_13 = self.module_13(dim=1, tensors=[self.output_module_11,self.output_module_12])
        self.output_module_14 = self.module_14(self.output_module_13)
        self.output_module_15 = self.module_15(self.output_module_14)
        self.output_module_16 = self.module_16(self.output_module_15)
        self.output_module_18 = self.module_18(self.output_module_16)
        self.output_module_19 = self.module_19(self.output_module_18)
        self.output_module_21 = self.module_21(self.output_module_19)
        self.output_module_22 = self.module_22(self.output_module_19)
        self.output_module_23 = self.module_23(dim=1, tensors=[self.output_module_21,self.output_module_22])
        self.output_module_24 = self.module_24(self.output_module_23)
        self.output_module_25 = self.module_25(self.output_module_24)
        self.output_module_26 = self.module_26(self.output_module_25)
        self.output_module_28 = self.module_28(self.output_module_26)
        self.output_module_29 = self.module_29(self.output_module_28)
        self.output_module_31 = self.module_31(self.output_module_29)
        self.output_module_32 = self.module_32(self.output_module_29)
        self.output_module_33 = self.module_33(dim=1, tensors=[self.output_module_31,self.output_module_32])
        self.output_module_34 = self.module_34(self.output_module_33)
        self.output_module_35 = self.module_35(self.output_module_34)
        self.output_module_36 = self.module_36(self.output_module_35)
        self.output_module_38 = self.module_38(self.output_module_36)
        self.output_module_39 = self.module_39(self.output_module_38)
        self.output_module_40 = self.module_40(self.output_module_39)
        self.output_module_42 = self.module_42(self.output_module_40)
        self.output_module_43 = self.module_43(self.output_module_40)
        self.output_module_44 = self.module_44(dim=1, tensors=[self.output_module_42,self.output_module_43])
        self.output_module_45 = self.module_45(self.output_module_44)
        self.output_module_46 = self.module_46(self.output_module_45)
        self.output_module_47 = self.module_47(self.output_module_46)
        self.output_module_49 = self.module_49(self.output_module_47)
        self.output_module_50 = self.module_50(self.output_module_49)
        self.output_module_52 = self.module_52(self.output_module_50)
        self.output_module_53 = self.module_53(self.output_module_50)
        self.output_module_54 = self.module_54(dim=1, tensors=[self.output_module_52,self.output_module_53])
        self.output_module_55 = self.module_55(self.output_module_54)
        self.output_module_56 = self.module_56(self.output_module_55)
        self.output_module_57 = self.module_57(self.output_module_56)
        self.output_module_59 = self.module_59(self.output_module_57)
        self.output_module_60 = self.module_60(self.output_module_59)
        self.output_module_62 = self.module_62(self.output_module_60)
        self.output_module_63 = self.module_63(self.output_module_62)
        return self.output_module_63
