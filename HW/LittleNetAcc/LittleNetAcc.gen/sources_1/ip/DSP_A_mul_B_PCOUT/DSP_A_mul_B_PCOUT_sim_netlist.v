// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Jan 18 21:49:29 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/LittleNet/HW/LittleNetAcc/LittleNetAcc.gen/sources_1/ip/DSP_A_mul_B_PCOUT/DSP_A_mul_B_PCOUT_sim_netlist.v
// Design      : DSP_A_mul_B_PCOUT
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DSP_A_mul_B_PCOUT,dsp_macro_v1_0_1,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dsp_macro_v1_0_1,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module DSP_A_mul_B_PCOUT
   (CLK,
    CE,
    A,
    B,
    PCOUT,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL4:CESEL5, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_HIGH" *) input CE;
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
  (* C_LATENCY = "-1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000100100000010100000000" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "44" *) 
  (* C_REG_CONFIG = "00000000000011000011000001000100" *) 
  (* C_SEL_WIDTH = "0" *) 
  (* C_SQUARE_FCN = "0" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  DSP_A_mul_B_PCOUT_dsp_macro_v1_0_1 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 9280)
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
l2WJhvobhhuT0VYhlp/D5iMWfrJMMFzaTl+d4Rt7wrJHQUmq6TWhgbrWJl/wx5dCwmGX2/hw/D3l
xmvyR1zWF/9bgpMScMjH76QcFH2LkXyHf3nfRcy+we/KYMBqCIXa5RVpy7+m1nc+zOwoTWIXZglg
7XbEA28MYfPQh161zvs5m1D2po2tuDeyjdkU03/FXdBnYKTMuPJ/myAdHtIkeyI3oZsgfWZPbvSb
3EWh5wdvjq8p+m7xW21GvMU8s2g0dhk5yC+JITZJReJWtns5kA8Wg1GiraydRgJOWTxz0ZtJ5tI0
vB5GB8MfwmusTioYuAGe4qTT1qBBnLiFOdJezA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
pZQ/9BBzSTXcIMqM9NHnWfjuMtaYb8SwHmnYVdRu2b2uWfAs52NHpOfvzKvow2qfMuSkEm/mN69A
W6Czsf3JmhowGEtnwhdLo1WcGU9Ati0nGLfX7LdghnVKEc6j7N/B0MQSIQ+ztsVhkG5LisvZ9E//
zRCwwzHu1Mxlf7XiJB9mtxTqMqBZmhnNIFb8nhfIe4Bqfc6teP3PkmOsKDsgNXtqWeO7p/TnrMnA
Kivkb+UHvAmEABiwkJFl38KKRka0YVXnbooMJDy6w2CVk1qaBFNs7F/IaviJN2ZlQHDU2LnF7bdv
SxjL/I6PExJS4vF9YvayWcFWOiOUQlG08C0YnA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 33024)
`pragma protect data_block
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
Jpcp+Q5kqCjocknQtSo6p2Nj2sNT
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
