// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 21:49:29 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/DSP_A_mul_B_PCOUT_synth_1/DSP_A_mul_B_PCOUT_sim_netlist.v
// Design      : DSP_A_mul_B_PCOUT
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DSP_A_mul_B_PCOUT,xbip_dsp48_macro_v3_0_18,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_dsp48_macro_v3_0_18,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module DSP_A_mul_B_PCOUT
   (CLK,
    CE,
    A,
    B,
    PCOUT,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL4:CESEL5, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [26:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 pcout_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME pcout_intf, LAYERED_METADATA undef" *) output [47:0]PCOUT;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [44:0]P;

  wire [26:0]A;
  wire [17:0]B;
  wire CE;
  wire CLK;
  wire [44:0]P;
  wire [47:0]PCOUT;
  wire NLW_U0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_U0_CARRYOUT_UNCONNECTED;
  wire [29:0]NLW_U0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_U0_BCOUT_UNCONNECTED;

  (* C_A_WIDTH = "27" *) 
  (* C_B_WIDTH = "18" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "48" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "0" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "124" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000100100000010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "44" *) 
  (* C_REG_CONFIG = "00000000000011000011000001000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  DSP_A_mul_B_PCOUT_xbip_dsp48_macro_v3_0_18 U0
       (.A(A),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_U0_ACOUT_UNCONNECTED[29:0]),
        .B(B),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_U0_BCOUT_UNCONNECTED[17:0]),
        .C({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_U0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYOUT(NLW_U0_CARRYOUT_UNCONNECTED),
        .CE(CE),
        .CEA(1'b1),
        .CEA1(1'b1),
        .CEA2(1'b1),
        .CEA3(1'b1),
        .CEA4(1'b1),
        .CEB(1'b1),
        .CEB1(1'b1),
        .CEB2(1'b1),
        .CEB3(1'b1),
        .CEB4(1'b1),
        .CEC(1'b1),
        .CEC1(1'b1),
        .CEC2(1'b1),
        .CEC3(1'b1),
        .CEC4(1'b1),
        .CEC5(1'b1),
        .CECONCAT(1'b1),
        .CECONCAT3(1'b1),
        .CECONCAT4(1'b1),
        .CECONCAT5(1'b1),
        .CED(1'b1),
        .CED1(1'b1),
        .CED2(1'b1),
        .CED3(1'b1),
        .CEM(1'b1),
        .CEP(1'b1),
        .CESEL(1'b1),
        .CESEL1(1'b1),
        .CESEL2(1'b1),
        .CESEL3(1'b1),
        .CESEL4(1'b1),
        .CESEL5(1'b1),
        .CLK(CLK),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(PCOUT),
        .SCLR(1'b0),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
RjBOnpqHtHSn7Th98eHEXvWyBHe3T/gX1ti9+oK+DEEpXjYJihGx5qABFhKaZ7HnG7jWsuBRgFTw
VE0K5T9mAw==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
AD8tLEblaOjB+faGHLQIkzbrG4aM6nCBT8dcD81Iun3SQOUijB8ABDIg5lEYH5K3EeksCSGHki8g
OvxbLFTgjliJBLxLsx+ia51eHHbkDhVrKKZyRVjuRNVWUvpPqSQue0dt1m+8vXZ8EbDTFu57FQES
ftptMOmvCz4P45+upgw=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Dd31zkgUgmtbPfI+NIw7WlVAEr8tSKWNShbB1sHb/DVoeVc7e1sPES4YIchOZKIfybkZs4GbQZzu
7p0DR6LJViMcpdkP8L6fqfNzF1OhTLtyiyODjmJKVbEn9K3WIpfx3cKfr6NLVyyNtOZfkBdGi5Ju
yPztYIemvy4+HBXWlBIbtGcnfXdNFt6Od4zR7R7/HusvUvKc/AGqJmz7S3809B2hCVf4LcEqkDzC
l8O/4DarStZq7ROZLBUD+boey+5aS2clMyo0UHdNPvD6k+zdaj8GrnfawU2PU/hDlhDX4CeV6VAR
YUnkfC0yC72QCfwlKJ4gUttkmO+HsgYJkC+aOg==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QhWl9RMPJdD/ZzRR8EMwTgTNuPOKRQrQFdbwGVDvZKtpMwRqT9R3LfVWtbQcz8WGEhjsrZdTQ2Tt
VXYvZIIO7sMT53lhA3efDgr1bk94sKVKucYzrMdSlvkj44xuzeTUMsmVRrIVvGGtMytti17Vm1/W
vosV75seV2FQGB2C4rv4he7Cogzs2UePX7lT3jCmXP0VH7iWZUx7ew5GrP2Lte6VI+nAr6bYcgvE
vgA3qG2GsLNZpxxVVGWNesA3GqSc+PIUB2xPr00h4vrrgYxO428jrUtnAR5wwUZw9W152bGVgIX8
xZau1x+uZ3yzQTazm9yu6t4ME2PBCwXVz17jDw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jpkTKe1I/bpe85OESn4XWlnPzxPg7qI9WIaK5XaiGGBGixYLwRzLlNkUzErN03b7oqURMr88K5M4
jNn2+jzz9HmzWdP0ZGKTlhrW6Sdko4T714+/bxB2IR+v5vpPzrpnI50QFbCjIFmAS+RzojYfVaSs
9AwUQ1qyecUtyzkjygo=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FnnZEWGd+W7GPfbxXNmL25gL5GeM4EahuG6OQnjnqdruSkYjP2R/neKgChYgKz0laVTQyyADbUGE
HLaB3cP6Mshm6TnsnznSYK3MYY8w1lwyPLH2P3S29O1EOQLfDNE4m3G3ihbblMd78y/8SmJiycPk
go89UvGCQbKY9DEXc1lfc/kIKXgMkB/CNdD4PkOcSDb4YH1FlP8KteLdVDv12i1cLvqCVQYiZIvr
bPu0MglEawi5DZttyhu7zb5dLJqPtl5YpEeYPpnAKqKQ0+SJhzfzjc9wrtkT7vf0NhK8OwYDgbp7
wX8Dma61ADq291MJDKSyxgY2OiH7zkhHt9mvdA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
k9ONE6V8cDPlTUs5hhzMJIw+J7u2toMV3xjrlyeyXlJat41nqtoIXMfKe4BvqchMuefafW9o2L9r
11s6BZl20Y69RcOU0WetH72qfd7/7Kpp+ikXD+VrFWxzhaZufypkPXMtQGr98S0nR5j7y1TFJIJd
qDRH1OuRhVjJcgd9KVnrtLm9mT/oJOOeiqPMHaqf6aQFna+ZSigYPN/QMMnTMfSsdJQLmLWo6Z4/
lAS0efB4bdfMEzg55uYjJstVlH6jQr/CRM+9L6IkMoFxPYHNWqS7LsPs/zw78SU/JnA3/cVvx7Wy
RzBFiRvPRFB7x6tSNas53jhf6lVanpPxpin40A==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NJ3AewbGy/1b3Q7grl6l3g8U/DqAzeMvF0M/rx3LiqYv/mBQyl3As83UPy99ReUtnyfJP3CLmF9r
4i+XbKr4we6uYQcjbnhylwEw56pFm7SGXVTq5roiDHSotdKqcr33xTDX+9/auKrJUcx1Lf5rScgw
m0oxolc2QVL1yT4tMLK/R4C/mdARmD1Jhf7hKfUOIKi/xNXzXcqfBPU3jQ9AuZW8aTM0nILtH3XA
ZHBcPwZv41mguaikMmdwlA0v5KQ4jHbnOftBLuEpvG4KDiFFgCVN0rxTp3ObmKYNi0n/sIdyXwyu
xJkurQJKLU+73OaQuBjToZKkK8Hi7opi24E4eA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
J9x89Uvo6pGaqNI/JxQkXmn17BeLNJdHi40iwXG4XmigXrbTK8r0txxMjDZPf7lGcor6U/li1IgB
zqsF3jG03OqOjPVxJz3ymVNO2uLbm6Xefy/o5XhmwVZIwmxxNRtZfSeFXJDcLqJ1FEOUpKjWZc9w
u1v+F+g4pKLsoQOSnFRGnaRfLErIqY+NuyhvRJXNncy5oAd3mY1c66jcpNLqMMjIFG4OXxB+NeYi
XGI6+jt4apOfng5+RGiJVzA88WHZIlLzqgXaKg2TpgBxodNUl7nCUIADd8EgIGdiLaX3GC+IKIB2
1UO+CctB6E21VKAqU74VG0lD/p93HxBKnKjD1g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 9264)
`pragma protect data_block
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
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
RjBOnpqHtHSn7Th98eHEXvWyBHe3T/gX1ti9+oK+DEEpXjYJihGx5qABFhKaZ7HnG7jWsuBRgFTw
VE0K5T9mAw==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
AD8tLEblaOjB+faGHLQIkzbrG4aM6nCBT8dcD81Iun3SQOUijB8ABDIg5lEYH5K3EeksCSGHki8g
OvxbLFTgjliJBLxLsx+ia51eHHbkDhVrKKZyRVjuRNVWUvpPqSQue0dt1m+8vXZ8EbDTFu57FQES
ftptMOmvCz4P45+upgw=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Dd31zkgUgmtbPfI+NIw7WlVAEr8tSKWNShbB1sHb/DVoeVc7e1sPES4YIchOZKIfybkZs4GbQZzu
7p0DR6LJViMcpdkP8L6fqfNzF1OhTLtyiyODjmJKVbEn9K3WIpfx3cKfr6NLVyyNtOZfkBdGi5Ju
yPztYIemvy4+HBXWlBIbtGcnfXdNFt6Od4zR7R7/HusvUvKc/AGqJmz7S3809B2hCVf4LcEqkDzC
l8O/4DarStZq7ROZLBUD+boey+5aS2clMyo0UHdNPvD6k+zdaj8GrnfawU2PU/hDlhDX4CeV6VAR
YUnkfC0yC72QCfwlKJ4gUttkmO+HsgYJkC+aOg==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QhWl9RMPJdD/ZzRR8EMwTgTNuPOKRQrQFdbwGVDvZKtpMwRqT9R3LfVWtbQcz8WGEhjsrZdTQ2Tt
VXYvZIIO7sMT53lhA3efDgr1bk94sKVKucYzrMdSlvkj44xuzeTUMsmVRrIVvGGtMytti17Vm1/W
vosV75seV2FQGB2C4rv4he7Cogzs2UePX7lT3jCmXP0VH7iWZUx7ew5GrP2Lte6VI+nAr6bYcgvE
vgA3qG2GsLNZpxxVVGWNesA3GqSc+PIUB2xPr00h4vrrgYxO428jrUtnAR5wwUZw9W152bGVgIX8
xZau1x+uZ3yzQTazm9yu6t4ME2PBCwXVz17jDw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jpkTKe1I/bpe85OESn4XWlnPzxPg7qI9WIaK5XaiGGBGixYLwRzLlNkUzErN03b7oqURMr88K5M4
jNn2+jzz9HmzWdP0ZGKTlhrW6Sdko4T714+/bxB2IR+v5vpPzrpnI50QFbCjIFmAS+RzojYfVaSs
9AwUQ1qyecUtyzkjygo=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FnnZEWGd+W7GPfbxXNmL25gL5GeM4EahuG6OQnjnqdruSkYjP2R/neKgChYgKz0laVTQyyADbUGE
HLaB3cP6Mshm6TnsnznSYK3MYY8w1lwyPLH2P3S29O1EOQLfDNE4m3G3ihbblMd78y/8SmJiycPk
go89UvGCQbKY9DEXc1lfc/kIKXgMkB/CNdD4PkOcSDb4YH1FlP8KteLdVDv12i1cLvqCVQYiZIvr
bPu0MglEawi5DZttyhu7zb5dLJqPtl5YpEeYPpnAKqKQ0+SJhzfzjc9wrtkT7vf0NhK8OwYDgbp7
wX8Dma61ADq291MJDKSyxgY2OiH7zkhHt9mvdA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
k9ONE6V8cDPlTUs5hhzMJIw+J7u2toMV3xjrlyeyXlJat41nqtoIXMfKe4BvqchMuefafW9o2L9r
11s6BZl20Y69RcOU0WetH72qfd7/7Kpp+ikXD+VrFWxzhaZufypkPXMtQGr98S0nR5j7y1TFJIJd
qDRH1OuRhVjJcgd9KVnrtLm9mT/oJOOeiqPMHaqf6aQFna+ZSigYPN/QMMnTMfSsdJQLmLWo6Z4/
lAS0efB4bdfMEzg55uYjJstVlH6jQr/CRM+9L6IkMoFxPYHNWqS7LsPs/zw78SU/JnA3/cVvx7Wy
RzBFiRvPRFB7x6tSNas53jhf6lVanpPxpin40A==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NJ3AewbGy/1b3Q7grl6l3g8U/DqAzeMvF0M/rx3LiqYv/mBQyl3As83UPy99ReUtnyfJP3CLmF9r
4i+XbKr4we6uYQcjbnhylwEw56pFm7SGXVTq5roiDHSotdKqcr33xTDX+9/auKrJUcx1Lf5rScgw
m0oxolc2QVL1yT4tMLK/R4C/mdARmD1Jhf7hKfUOIKi/xNXzXcqfBPU3jQ9AuZW8aTM0nILtH3XA
ZHBcPwZv41mguaikMmdwlA0v5KQ4jHbnOftBLuEpvG4KDiFFgCVN0rxTp3ObmKYNi0n/sIdyXwyu
xJkurQJKLU+73OaQuBjToZKkK8Hi7opi24E4eA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
J9x89Uvo6pGaqNI/JxQkXmn17BeLNJdHi40iwXG4XmigXrbTK8r0txxMjDZPf7lGcor6U/li1IgB
zqsF3jG03OqOjPVxJz3ymVNO2uLbm6Xefy/o5XhmwVZIwmxxNRtZfSeFXJDcLqJ1FEOUpKjWZc9w
u1v+F+g4pKLsoQOSnFRGnaRfLErIqY+NuyhvRJXNncy5oAd3mY1c66jcpNLqMMjIFG4OXxB+NeYi
XGI6+jt4apOfng5+RGiJVzA88WHZIlLzqgXaKg2TpgBxodNUl7nCUIADd8EgIGdiLaX3GC+IKIB2
1UO+CctB6E21VKAqU74VG0lD/p93HxBKnKjD1g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
D7jA/QF9R/cFvdQag8T1HWCZJvjeYnDhSmUQcTDTUvOkFMRiwLQ+sw9UbS/AtZOXDmLIcGpYbaMn
s1Jd35vMkMMHGOk4NxeAI5QR3dwco3Du/SyNvBRqzAGpAy6SwZVoMDn0bqbIlNyg9FK1EIpmceb3
wyJwOsgZ1qbQkx+craddaKkJco9201tGvYY7Az1XyzyQypIBD2jknEdyVfPBrzG4oE+ZruJ8ZbcA
j2ObwsFHs4+lZy1HO4+lkZcQxB3SRvEFryOnKGa93mY416I3OJ2A5WT8/nGWSndwbfNBBkktnJTN
VLb/QryBDegEFhHjrMmXoZSLFZyzKR88ybzMMw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LYdUvpeNevzhYyPyCLRIHic6pl3xP4bTONH+Da/Hj5kiG/6tkKBgd++2aPuAt/bQeJggcXauMd5i
lnpQLG6WC0+wAT6ueQD56Go59QQKoBEzOYgP8ywz8jC/FW36UQQu3WnCHqopm9V9lQoNSr/Dq/Bl
wK4l/hdNKGyxGT79RrbiePPOXpIOZFpXAv1xf59zfoFbIQG4N17cptlyDsUIk98mMSWmw0NDLcqa
Iq0X/RqNqm4IhlYfPYK524QD/B7NRbiUuaYDxS4nOtnh9XwSmR3Ypw+KJLv07HlD8/pVgfD3cKIR
THaZ12Ax2oR0tBoI66EYiyi8luOIjRSAhTf7oQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 33040)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
