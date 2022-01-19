// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Jan 18 21:47:50 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/LittleNet/HW/LittleNetAcc/LittleNetAcc.gen/sources_1/ip/DSP_A_mul_B_add_PCIN_PCOUT/DSP_A_mul_B_add_PCIN_PCOUT_sim_netlist.v
// Design      : DSP_A_mul_B_add_PCIN_PCOUT
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DSP_A_mul_B_add_PCIN_PCOUT,dsp_macro_v1_0_1,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dsp_macro_v1_0_1,Vivado 2020.2" *) 
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
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_HIGH" *) input CE;
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
  (* C_LATENCY = "-1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000000000001010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "47" *) 
  (* C_REG_CONFIG = "00000000000011000011000001000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_SQUARE_FCN = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  DSP_A_mul_B_add_PCIN_PCOUT_dsp_macro_v1_0_1 U0
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
VAgno8OxoF4iBvt805EvZ5B04t7vIuHc5hRCNc4uRUsaMd36oBh//VCaV+glO4HOAC6/d4L7akyM
NoqkXUiS6w==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
U6ZhtQdIHr1gLfhADEiO+K1WNlHhBgQb8eYI5f5jFHZ5UYXiHVsQATY/FbHqztSmNPvp4KvUkhej
thDIDPlHNW8wgk6+SiKuMewlbnM0hTFcqlQxhzGKVGJnjKT8FZJSPSGw2Hg7E6qEHzgbrJGQTlKF
73SCv5eKc0S9XMUe+YI=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NmFaPLOI1NIvYWxm2v2L84T3lWokDxeL3knkGbSe5KXlTRb6J5Y74MKblG5cGKXhtxEkCQ0gec5D
hqLTIc3UcPyDzE1CXLtOuKOsBoDPLXY9MKGjOCgHy7Go+8BDylOwPYNRiHe/vnCxO7wyHu57IT1n
pgKFaw/pAxxzchjSmQe1RPSco53iMrHLJejXCc2nHeGQn83fPc2bpT0Cq3aLpd12nTZ48EO9v6kO
i9G72xIcuCkS2V2nXFQ+dv6r92AFFTNsfyQYpa6sHmH/qiOtYlUIFoPC9HJOjFONJBkrwAxng/DR
3jHngCh+/ffUm+7Y9cujnFzZ/aTAnoVqDkUJLw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tY1Yr8H3ZMvW9KPKsXgsB+/u+HwJaMnptw8PQcv01FdZa0ncpM2nnHZPwinabKiMlgHSon8rYa+C
BuljUFY8uS79ceRHr5tppm/0ZSAiSeWwP7WlAAIsHzXc/f7eSvvJWSLvsu+zT2eNJQf+wFqQyxJV
TngIxT6zxk4Bwd0va4YF1lLQSXA7fpgtiOihGZfZynIzKvD9VR6ua30wMSEJypDxGdHtMD+A32e7
nqR4FuqLBuvVK1JyatqAcxGXOVp1A2fHajEnqf5NCIT2o4QU+h6smFJ4pwfz6yReEitw7rUksNPi
DrMGoh01+VaYBqSmUHllQ9D8o+qu44747/shHg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
epgfLpE4AfaebCd/xo6rzntRHWndFcvWv7NNzkC0DrGgLx/qLMeiAzPXT1KZrOlkKYar4Oev0KS2
seAzBZKOJb+dfLMfGjbNjZPeLrLums2ERTJ7WE+5yAv4QGFHxcC1k80l0qUDCLHzBzVXW0c8sX+B
LHmVbu2gMQx5y1FOKug=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HcfaoEBWp1R0frrTjXqZyqFBlPGNyaVQrS04wcexFhFLzPM8UsUlXJRxmZojF+CsQtP9tf3acyOK
p5jS6LsVRYWE4J7kOtXgjf2nKzQ/pzre30c7X8lSwCbmxWMlSP1GufuOv5x4dSTTbF1qb9ZRy8UQ
LbVBev7PH63xB4SwUZtwkVYAh7W3p/loLE25DWiS2Qq+ppB+u3VtZcoVjGoW5dDbqJ8FsAJDXNx9
hK0iOW8J5gFbMT4etSZeXmzjY0pEI7idEQb0lyKow5bU9tNclcqoPqqopsi2kqNhMsVaCpxOJOdD
sbnpMAwKMFjh7exSwv5qauPaTMgxp+RfABM9jw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WB4hP6JlC0o0M8+Od+R3rCSDwZOlSfXOLohbHV5nesvh55O8sjA7b7ir3feizh1nRYijfKi8zTA/
WyECFs6xWiRGtvpNafeKuhORfQusbndgqqN8HDpwLXcpkqymf4ftNAKIgzUlHIPOJ8Mi+NzI3N8A
rjYnA6wkoBCjJn9MxGPgJISSjAVsoKFBvb4Aa4SV68hp9QqLWlIrtNajJq2yl0w9O1PlvObfPjHI
N02/wUmym0wqIfKBfl1lCKLd8yZRoWw0AwV3EMX7NMr8VDVwpp1zuxEMXX5zg1L41p1yrxXhARAG
DgsFDrr6Z1iW3LJ8ES/gxOinFkqrootk9Y+8iA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VN0xOp0nWW+D5ex5VOj6GzvPAsqIRZ4LgrZZGNGpxBfhf4pq9cO0Ptn4shsfC1tVOJ9LkHwp+FsV
4eFMXd7kWb4Y5GG8tMrKRo8Wj6MScYwE3JsRvi/r0c70rq05H/iwvDN6FRkAk25vpinAdfiMNHmp
KaguMbyP+OWVsWvL73uCOy8tFg8SjkQe/MKWOROFyMOr7+5zxCQK+pDmacX1Pm7lKNVegyLD01K0
UeYpLhDeRMANFVPv+dHCtKkh7stihgtk9qfNK9NAFg/JTmDcfvs2rBywQ+S8svu7MNBFUuwHy8AU
w4Tor65k368a75R2ewdiua6MNJgvTXqQ/XpM8A==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
KX0I33YSxvGDPd/LhoPFxFV0GNRAII5wmVcxqYL+WLsG+br/lj8z8lthZeJ9h9uPYthgpfC9Ttam
D/b0yECdgRL02fw5ZI5v9XZTb3RsAMXY5DlfTGsywmtHIerFQLVM9HR4qDOjVL1ATRPpN9pgNDbY
HRpOKe1JhvtZWGm8abiIqzYoxkhVZdsqld88SkD+EgjC6QXhObic6fdS1A3J8xaLHlzhNua9/fRp
1pyw6iHAfizbz3L8vmEwfh4uCSJ8kmuDirAAZjDm7U0OjWtp2MYP5koly1f526/KdtukdtfEkJVU
N7c02FLMvcFZz8EzZURZJ2XCKAElKtQzIC0pbA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 9088)
`pragma protect data_block
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
o3Pv6lKsngmHzkA63S3NImtRmz6rxhu8wQ==
`pragma protect end_protected
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
VAgno8OxoF4iBvt805EvZ5B04t7vIuHc5hRCNc4uRUsaMd36oBh//VCaV+glO4HOAC6/d4L7akyM
NoqkXUiS6w==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
U6ZhtQdIHr1gLfhADEiO+K1WNlHhBgQb8eYI5f5jFHZ5UYXiHVsQATY/FbHqztSmNPvp4KvUkhej
thDIDPlHNW8wgk6+SiKuMewlbnM0hTFcqlQxhzGKVGJnjKT8FZJSPSGw2Hg7E6qEHzgbrJGQTlKF
73SCv5eKc0S9XMUe+YI=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NmFaPLOI1NIvYWxm2v2L84T3lWokDxeL3knkGbSe5KXlTRb6J5Y74MKblG5cGKXhtxEkCQ0gec5D
hqLTIc3UcPyDzE1CXLtOuKOsBoDPLXY9MKGjOCgHy7Go+8BDylOwPYNRiHe/vnCxO7wyHu57IT1n
pgKFaw/pAxxzchjSmQe1RPSco53iMrHLJejXCc2nHeGQn83fPc2bpT0Cq3aLpd12nTZ48EO9v6kO
i9G72xIcuCkS2V2nXFQ+dv6r92AFFTNsfyQYpa6sHmH/qiOtYlUIFoPC9HJOjFONJBkrwAxng/DR
3jHngCh+/ffUm+7Y9cujnFzZ/aTAnoVqDkUJLw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tY1Yr8H3ZMvW9KPKsXgsB+/u+HwJaMnptw8PQcv01FdZa0ncpM2nnHZPwinabKiMlgHSon8rYa+C
BuljUFY8uS79ceRHr5tppm/0ZSAiSeWwP7WlAAIsHzXc/f7eSvvJWSLvsu+zT2eNJQf+wFqQyxJV
TngIxT6zxk4Bwd0va4YF1lLQSXA7fpgtiOihGZfZynIzKvD9VR6ua30wMSEJypDxGdHtMD+A32e7
nqR4FuqLBuvVK1JyatqAcxGXOVp1A2fHajEnqf5NCIT2o4QU+h6smFJ4pwfz6yReEitw7rUksNPi
DrMGoh01+VaYBqSmUHllQ9D8o+qu44747/shHg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
epgfLpE4AfaebCd/xo6rzntRHWndFcvWv7NNzkC0DrGgLx/qLMeiAzPXT1KZrOlkKYar4Oev0KS2
seAzBZKOJb+dfLMfGjbNjZPeLrLums2ERTJ7WE+5yAv4QGFHxcC1k80l0qUDCLHzBzVXW0c8sX+B
LHmVbu2gMQx5y1FOKug=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HcfaoEBWp1R0frrTjXqZyqFBlPGNyaVQrS04wcexFhFLzPM8UsUlXJRxmZojF+CsQtP9tf3acyOK
p5jS6LsVRYWE4J7kOtXgjf2nKzQ/pzre30c7X8lSwCbmxWMlSP1GufuOv5x4dSTTbF1qb9ZRy8UQ
LbVBev7PH63xB4SwUZtwkVYAh7W3p/loLE25DWiS2Qq+ppB+u3VtZcoVjGoW5dDbqJ8FsAJDXNx9
hK0iOW8J5gFbMT4etSZeXmzjY0pEI7idEQb0lyKow5bU9tNclcqoPqqopsi2kqNhMsVaCpxOJOdD
sbnpMAwKMFjh7exSwv5qauPaTMgxp+RfABM9jw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
WB4hP6JlC0o0M8+Od+R3rCSDwZOlSfXOLohbHV5nesvh55O8sjA7b7ir3feizh1nRYijfKi8zTA/
WyECFs6xWiRGtvpNafeKuhORfQusbndgqqN8HDpwLXcpkqymf4ftNAKIgzUlHIPOJ8Mi+NzI3N8A
rjYnA6wkoBCjJn9MxGPgJISSjAVsoKFBvb4Aa4SV68hp9QqLWlIrtNajJq2yl0w9O1PlvObfPjHI
N02/wUmym0wqIfKBfl1lCKLd8yZRoWw0AwV3EMX7NMr8VDVwpp1zuxEMXX5zg1L41p1yrxXhARAG
DgsFDrr6Z1iW3LJ8ES/gxOinFkqrootk9Y+8iA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VN0xOp0nWW+D5ex5VOj6GzvPAsqIRZ4LgrZZGNGpxBfhf4pq9cO0Ptn4shsfC1tVOJ9LkHwp+FsV
4eFMXd7kWb4Y5GG8tMrKRo8Wj6MScYwE3JsRvi/r0c70rq05H/iwvDN6FRkAk25vpinAdfiMNHmp
KaguMbyP+OWVsWvL73uCOy8tFg8SjkQe/MKWOROFyMOr7+5zxCQK+pDmacX1Pm7lKNVegyLD01K0
UeYpLhDeRMANFVPv+dHCtKkh7stihgtk9qfNK9NAFg/JTmDcfvs2rBywQ+S8svu7MNBFUuwHy8AU
w4Tor65k368a75R2ewdiua6MNJgvTXqQ/XpM8A==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
KX0I33YSxvGDPd/LhoPFxFV0GNRAII5wmVcxqYL+WLsG+br/lj8z8lthZeJ9h9uPYthgpfC9Ttam
D/b0yECdgRL02fw5ZI5v9XZTb3RsAMXY5DlfTGsywmtHIerFQLVM9HR4qDOjVL1ATRPpN9pgNDbY
HRpOKe1JhvtZWGm8abiIqzYoxkhVZdsqld88SkD+EgjC6QXhObic6fdS1A3J8xaLHlzhNua9/fRp
1pyw6iHAfizbz3L8vmEwfh4uCSJ8kmuDirAAZjDm7U0OjWtp2MYP5koly1f526/KdtukdtfEkJVU
N7c02FLMvcFZz8EzZURZJ2XCKAElKtQzIC0pbA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
nbNPFvCObyer6alC9aUUAVCTbtCP8xigsvpgEFwo8zUNRGvL0RpYpJlKsSa8fU51SFsxcZ/Haasu
BY2yxMDqYVM+xxPDHMpHYKksgL8nPt2/2hPAeq2EwXv9UuvvYQHMkSjG+Y15uUlL3b1MWeaFLw4B
ji0mT/iWpFvVwUDtbm/UMuQXr7/ROule5BWlttCo3DxRLWkT1IF5l6wN/gRs1DK4dmV1kQMMoXbs
Y/xjDUTYnDe02/xFvXAeDis9HDCCtnPBTWHSq2F2hnRf1z7vwJtgyMUhmRTk6Tkr8vCwzeZni2Kt
0nhl0zArofuY498vgRk0mW7FT+MqPmJt/4fZYg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CS1fFEfnK4oM8UaVT7Lp350ddS5+z0gQX1gMgCcE5SseVsdnU/g6+vanU/LHuy8SSb+XUOsFBSSL
EAHSvwuhOHwPII+mWC8jqQiBK+Y4C8XpSoVn5d0J2D2OkncReiZzpCRDZPBYLDnNUeAKO8L1AtQ9
a1ku3EMWON2tojRdHZnlo2EPbL0Lq1q11JRWI3zjOqdIARzMZO2mt3t9MhqrQ96XKHQmsfttjqWs
GqQd8JpFGSguzERNrkqDDbFfoVsBnvuczbHSCie9tS/THgnC1PjD8PMelT7uLlAjYXLitiDZwGAv
dXtNc15IP6YnI+HeKl45wjgVNkZsekcMWXbnlw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 32960)
`pragma protect data_block
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
j6zLRAoQPhM9iN9yINk=
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
