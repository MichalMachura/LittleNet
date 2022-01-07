// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 21:52:14 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ DSP_A_mul_B_add_PCIN_PCOUT_sim_netlist.v
// Design      : DSP_A_mul_B_add_PCIN_PCOUT
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DSP_A_mul_B_add_PCIN_PCOUT,xbip_dsp48_macro_v3_0_18,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_dsp48_macro_v3_0_18,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_xbip_dsp48_macro_v3_0_18 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 9040)
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
Nqne6YfPmScfatDAJEhMxYury8u2m9Q5tyZrA7m/LMFulun5XfJkXcPNNg3PfWTZbR5mj+wv60Kw
dGN23u1naiPgZY+8rZuesA4yX3zL/UKPsGs1Xb0oW9+79GkrHvYXJWlBeSXdbX8NDlACFYuVTrU1
5DAs/yo+EhLHIBrIyHEipmiulHNAQnWVcP3wlWn18KNHXQnCmt9D64RXNL9lpEhox7VwxJLKiZKn
V4Tjcpwq7DJyuOj0lHnC0zIkWbJjeJNU/cYQbtjlQtYHrhhnmT9x8LzvURiqOMct8g3JEa3XUawW
qklNDwCNXQB/+hD9+aVI5ynaEjJrfWokB/vcGg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
buky9EOPOrdgp4Lh4KRjw3vmoZnSETgAQQfF2SS7rAEXSxBTjjaabii+3nQXl/m8WD/tvo4UCgT2
CiKoj43grH2oQtrnYwWdqkab9HejoNRyJHKbzdbjYqLl2VnDvy7k9ocOcu+mGQ2flk9vB0CgDT7u
UkjMTzTizSaOjFvW3vsmod8LsjXXT/evP7eYz287cVSYovaM3x/HBFLMwm/tCIBVBxKSmDBgyUrv
kxbyBLtMcvUvZ0Wo38s7NMgsHIbyLrlwGBZ8RkbtYO7RKU6AHg5dWpdVMxeGELwSpzTPo4cfnKLn
2GRPKqDDFxZrX0h1NVyziEheH9z357LgX5WpTw==

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
