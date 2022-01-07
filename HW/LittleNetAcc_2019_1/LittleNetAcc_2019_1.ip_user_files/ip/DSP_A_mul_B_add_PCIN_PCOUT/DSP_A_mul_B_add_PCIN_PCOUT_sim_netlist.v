// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 21:52:15 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/DSP_A_mul_B_add_PCIN_PCOUT_synth_1/DSP_A_mul_B_add_PCIN_PCOUT_sim_netlist.v
// Design      : DSP_A_mul_B_add_PCIN_PCOUT
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DSP_A_mul_B_add_PCIN_PCOUT,xbip_dsp48_macro_v3_0_18,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_dsp48_macro_v3_0_18,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module DSP_A_mul_B_add_PCIN_PCOUT
   (CLK,
    CE,
    PCIN,
    A,
    B,
    PCOUT,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL4:CESEL5, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 pcin_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME pcin_intf, LAYERED_METADATA undef" *) input [47:0]PCIN;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [26:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 pcout_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME pcout_intf, LAYERED_METADATA undef" *) output [47:0]PCOUT;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [47:0]P;

  wire [26:0]A;
  wire [17:0]B;
  wire CE;
  wire CLK;
  wire [47:0]P;
  wire [47:0]PCIN;
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
  (* C_HAS_PCIN = "1" *) 
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
  (* C_OPMODES = "000000000001010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "47" *) 
  (* C_REG_CONFIG = "00000000000011000011000001000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  DSP_A_mul_B_add_PCIN_PCOUT_xbip_dsp48_macro_v3_0_18 U0
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
        .PCIN(PCIN),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 9056)
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
bgAS0BYwX2IVy2dwrLfE4gUVGSkvSHjQvv+Vbgi6ZUSiQqz/du4KYW2xJmR7CgsH2Pf9RJYmjh6Q
9AqhAYwkiNuLR3s0y/gKLZM7yyYxz8XxATLQVsa9r91bnBF3jm0MNNqXkz20b7qnV/PtPjtiFRC2
DxXnptUTvey2tDdXWZOCGLoZwyNWxT+HLxMWwp8VFuUZLdj6B7FiFsvBWXmcGKDkfp3PDJxDHZ6W
EhTT4orlf8HzQweA3eZTFIpXm6GCezAj2VetK3ElqP0LeE/MFOaPaV2R6aooge3+h61/AtLg2X3o
F69KFmQwC5eT5m7tq7gKgcOiXn8ISjiO8AXYdA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ihhtw2p0hx21Z/fLMOBV94v2JySkKugxMqux79c30hU2koYn0xdzNR3DWag17DHfiRqr4m+sBTC1
q4SLJ7euQH5v/W/YbZ0bzsOKGlX4sgDxWrSB13Rqe3CH+P1CCpEiG9vkI0VfPKXV3QrwykL2aKBB
rZ+E3S/WISShfxRgYl3S5n3eEbkanRBN+Cnqb8dEpq++htAp4ZHMAdCgFMZWP09w6dd8Rf/EkrzQ
tdKl3dh0SX5Zka5rkTfAgvyRARRnareDmhT9kwzewcY67w9l4Pn1dfAmJy3ZwcwW413j4OkdeSUd
8T5Z2LXgQRXNmhkd1TU1rrQInDnHPdmKwBYD7A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 32960)
`pragma protect data_block
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
oHuHl9jVXHiC1f4iVZo=
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
