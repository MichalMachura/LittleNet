# GENETARED BY NNDCT, DO NOT EDIT!

import torch
import pytorch_nndct as py_nndct
class Sequential(torch.nn.Module):
    def __init__(self):
        super(Sequential, self).__init__()
        self.module_0 = py_nndct.nn.Input() #Sequential::input_0
        self.module_1 = py_nndct.nn.Conv2d(in_channels=3, out_channels=3, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=3, bias=True) #Sequential::Sequential/DWConv2d[0]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.2
        self.module_3 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[0]/DWConv2d[sub_dw_0]/ReLU[relu]/178
        self.module_4 = py_nndct.nn.Conv2d(in_channels=3, out_channels=3, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=3, bias=True) #Sequential::Sequential/DWConv2d[0]/DWConv2d[sub_dw_1]/Conv2d[conv]/input.4
        self.module_6 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[0]/DWConv2d[sub_dw_1]/ReLU[relu]/195
        self.module_7 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[0]/input.6
        self.module_8 = py_nndct.nn.Conv2d(in_channels=6, out_channels=8, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[1]/Conv2d[conv]/input.7
        self.module_10 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[1]/MaxPool2d[mp]/input.8
        self.module_11 = py_nndct.nn.Conv2d(in_channels=8, out_channels=8, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=8, bias=True) #Sequential::Sequential/DWConv2d[2]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.9
        self.module_13 = py_nndct.nn.Conv2d(in_channels=8, out_channels=8, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=8, bias=True) #Sequential::Sequential/DWConv2d[3]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.11
        self.module_15 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[3]/DWConv2d[sub_dw_0]/ReLU[relu]/251
        self.module_16 = py_nndct.nn.Conv2d(in_channels=8, out_channels=8, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=8, bias=True) #Sequential::Sequential/DWConv2d[3]/DWConv2d[sub_dw_1]/Conv2d[conv]/input.13
        self.module_18 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[3]/DWConv2d[sub_dw_1]/ReLU[relu]/268
        self.module_19 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[3]/input.15
        self.module_20 = py_nndct.nn.Conv2d(in_channels=16, out_channels=32, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[4]/Conv2d[conv]/input.16
        self.module_22 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[4]/MaxPool2d[mp]/input.17
        self.module_23 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/DWConv2d[5]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.18
        self.module_25 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/DWConv2d[6]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.20
        self.module_27 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[6]/DWConv2d[sub_dw_0]/ReLU[relu]/324
        self.module_28 = py_nndct.nn.Conv2d(in_channels=32, out_channels=32, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=32, bias=True) #Sequential::Sequential/DWConv2d[6]/DWConv2d[sub_dw_1]/Conv2d[conv]/input.22
        self.module_30 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[6]/DWConv2d[sub_dw_1]/ReLU[relu]/341
        self.module_31 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[6]/input.24
        self.module_32 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[7]/Conv2d[conv]/input.25
        self.module_34 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[7]/MaxPool2d[mp]/input.26
        self.module_35 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[8]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.27
        self.module_37 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[9]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.29
        self.module_39 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[9]/DWConv2d[sub_dw_0]/ReLU[relu]/397
        self.module_40 = py_nndct.nn.Conv2d(in_channels=64, out_channels=64, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=64, bias=True) #Sequential::Sequential/DWConv2d[9]/DWConv2d[sub_dw_1]/Conv2d[conv]/input.31
        self.module_42 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[9]/DWConv2d[sub_dw_1]/ReLU[relu]/413
        self.module_43 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[9]/input.33
        self.module_44 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[10]/Conv2d[conv]/input.34
        self.module_46 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[10]/ReLU[relu]/433
        self.module_47 = py_nndct.nn.MaxPool2d(kernel_size=[2, 2], stride=[2, 2], padding=[0, 0], dilation=[1, 1], ceil_mode=False) #Sequential::Sequential/PWConv2d[10]/MaxPool2d[mp]/input.36
        self.module_48 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[11]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.37
        self.module_50 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[12]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.39
        self.module_52 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[12]/DWConv2d[sub_dw_0]/ReLU[relu]/470
        self.module_53 = py_nndct.nn.Conv2d(in_channels=128, out_channels=128, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=128, bias=True) #Sequential::Sequential/DWConv2d[12]/DWConv2d[sub_dw_1]/Conv2d[conv]/input.41
        self.module_55 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[12]/DWConv2d[sub_dw_1]/ReLU[relu]/486
        self.module_56 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[12]/input.43
        self.module_57 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[13]/Conv2d[conv]/input.44
        self.module_59 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[13]/ReLU[relu]/input.46
        self.module_60 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[14]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.47
        self.module_62 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[15]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.49
        self.module_64 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[15]/DWConv2d[sub_dw_0]/ReLU[relu]/536
        self.module_65 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[15]/DWConv2d[sub_dw_1]/Conv2d[conv]/input.51
        self.module_67 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[15]/DWConv2d[sub_dw_1]/ReLU[relu]/552
        self.module_68 = py_nndct.nn.Cat() #Sequential::Sequential/DWConv2d[15]/input.53
        self.module_69 = py_nndct.nn.Conv2d(in_channels=512, out_channels=256, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[16]/Conv2d[conv]/input.54
        self.module_71 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/PWConv2d[16]/ReLU[relu]/input.56
        self.module_72 = py_nndct.nn.Conv2d(in_channels=256, out_channels=256, kernel_size=[3, 3], stride=[1, 1], padding=[1, 1], dilation=[1, 1], groups=256, bias=True) #Sequential::Sequential/DWConv2d[17]/DWConv2d[sub_dw_0]/Conv2d[conv]/input.57
        self.module_74 = py_nndct.nn.ReLU(inplace=True) #Sequential::Sequential/DWConv2d[17]/DWConv2d[sub_dw_0]/ReLU[relu]/input
        self.module_75 = py_nndct.nn.Conv2d(in_channels=256, out_channels=15, kernel_size=[1, 1], stride=[1, 1], padding=[0, 0], dilation=[1, 1], groups=1, bias=True) #Sequential::Sequential/PWConv2d[18]/Conv2d[conv]/598

    def forward(self, *args):
        self.output_module_0 = self.module_0(input=args[0])
        self.output_module_1 = self.module_1(self.output_module_0)
        self.output_module_3 = self.module_3(self.output_module_1)
        self.output_module_4 = self.module_4(self.output_module_0)
        self.output_module_6 = self.module_6(self.output_module_4)
        self.output_module_7 = self.module_7(dim=1, tensors=[self.output_module_3,self.output_module_6])
        self.output_module_8 = self.module_8(self.output_module_7)
        self.output_module_10 = self.module_10(self.output_module_8)
        self.output_module_11 = self.module_11(self.output_module_10)
        self.output_module_13 = self.module_13(self.output_module_11)
        self.output_module_15 = self.module_15(self.output_module_13)
        self.output_module_16 = self.module_16(self.output_module_11)
        self.output_module_18 = self.module_18(self.output_module_16)
        self.output_module_19 = self.module_19(dim=1, tensors=[self.output_module_15,self.output_module_18])
        self.output_module_20 = self.module_20(self.output_module_19)
        self.output_module_22 = self.module_22(self.output_module_20)
        self.output_module_23 = self.module_23(self.output_module_22)
        self.output_module_25 = self.module_25(self.output_module_23)
        self.output_module_27 = self.module_27(self.output_module_25)
        self.output_module_28 = self.module_28(self.output_module_23)
        self.output_module_30 = self.module_30(self.output_module_28)
        self.output_module_31 = self.module_31(dim=1, tensors=[self.output_module_27,self.output_module_30])
        self.output_module_32 = self.module_32(self.output_module_31)
        self.output_module_34 = self.module_34(self.output_module_32)
        self.output_module_35 = self.module_35(self.output_module_34)
        self.output_module_37 = self.module_37(self.output_module_35)
        self.output_module_39 = self.module_39(self.output_module_37)
        self.output_module_40 = self.module_40(self.output_module_35)
        self.output_module_42 = self.module_42(self.output_module_40)
        self.output_module_43 = self.module_43(dim=1, tensors=[self.output_module_39,self.output_module_42])
        self.output_module_44 = self.module_44(self.output_module_43)
        self.output_module_46 = self.module_46(self.output_module_44)
        self.output_module_47 = self.module_47(self.output_module_46)
        self.output_module_48 = self.module_48(self.output_module_47)
        self.output_module_50 = self.module_50(self.output_module_48)
        self.output_module_52 = self.module_52(self.output_module_50)
        self.output_module_53 = self.module_53(self.output_module_48)
        self.output_module_55 = self.module_55(self.output_module_53)
        self.output_module_56 = self.module_56(dim=1, tensors=[self.output_module_52,self.output_module_55])
        self.output_module_57 = self.module_57(self.output_module_56)
        self.output_module_59 = self.module_59(self.output_module_57)
        self.output_module_60 = self.module_60(self.output_module_59)
        self.output_module_62 = self.module_62(self.output_module_60)
        self.output_module_64 = self.module_64(self.output_module_62)
        self.output_module_65 = self.module_65(self.output_module_60)
        self.output_module_67 = self.module_67(self.output_module_65)
        self.output_module_68 = self.module_68(dim=1, tensors=[self.output_module_64,self.output_module_67])
        self.output_module_69 = self.module_69(self.output_module_68)
        self.output_module_71 = self.module_71(self.output_module_69)
        self.output_module_72 = self.module_72(self.output_module_71)
        self.output_module_74 = self.module_74(self.output_module_72)
        self.output_module_75 = self.module_75(self.output_module_74)
        return self.output_module_75
