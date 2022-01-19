// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Jan 18 21:46:38 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ DSP_A_mul_B_add_PCIN_sim_netlist.v
// Design      : DSP_A_mul_B_add_PCIN
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "DSP_A_mul_B_add_PCIN,dsp_macro_v1_0_1,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "dsp_macro_v1_0_1,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (CLK,
    CE,
    PCIN,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:pcout_intf:carrycascout_intf:carryout_intf:bcout_intf:acout_intf:concat_intf:d_intf:c_intf:b_intf:a_intf:bcin_intf:acin_intf:pcin_intf:carryin_intf:carrycascin_intf:sel_intf, ASSOCIATED_RESET SCLR:SCLRD:SCLRA:SCLRB:SCLRCONCAT:SCLRC:SCLRM:SCLRP:SCLRSEL, ASSOCIATED_CLKEN CE:CED:CED1:CED2:CED3:CEA:CEA1:CEA2:CEA3:CEA4:CEB:CEB1:CEB2:CEB3:CEB4:CECONCAT:CECONCAT3:CECONCAT4:CECONCAT5:CEC:CEC1:CEC2:CEC3:CEC4:CEC5:CEM:CEP:CESEL:CESEL1:CESEL2:CESEL3:CESEL4:CESEL5, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_HIGH" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 pcin_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME pcin_intf, LAYERED_METADATA undef" *) input [47:0]PCIN;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [26:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [17:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [47:0]P;

  wire [26:0]A;
  wire [17:0]B;
  wire CE;
  wire CLK;
  wire [47:0]P;
  wire [47:0]PCIN;
  wire NLW_U0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_U0_CARRYOUT_UNCONNECTED;
  wire [29:0]NLW_U0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_U0_BCOUT_UNCONNECTED;
  wire [47:0]NLW_U0_PCOUT_UNCONNECTED;

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
  (* C_HAS_PCOUT = "0" *) 
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_dsp_macro_v1_0_1 U0
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
        .PCOUT(NLW_U0_PCOUT_UNCONNECTED[47:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 10704)
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
F2dIS9Zc4vfBy/wpXb4gkT5Q4z57uOs1Cn0Ya3IYtuoirI4Tuf/3zuAwcGXLi5a4TmS4nW4HAVwR
YVeOzVbDhzF4kU/J45YCOU7hieYtJyzj0+2L0CGl8cBv8T79QrHCNy46wO4OQQuGyiHrNxT2oPt9
mg2c3gRrVWiAQK/bZvuLX6fiwnMVCbI+BH8RpDqpHai/dUBLBVaTdDN0RXSUOkW+h953ho15ZCsA
DcR3nAmYvGDkTiXtAAm7cQJzFicajOmPQ4iOmi4/GV1nYsJ3KDR0sXcQz123vQ8ihQkfrshFTA0p
5C9zFsfAq3aiLClLgfG3lH7MwVCVSc6t2nnuyQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BCZlkISBZ0FlKhs6omy5TyqOqrJ9A9vZmQZ5r4HzhDf0jXDr26Y2gabzXdWLQFNowZeaDGCmbVHa
iuPls9HIgLdk7BYSgkUug4KT+he9TAWHIIQ6WF2eYR6paGW6Vt/dRZihHmDVc3Ol7LSarwlAKvqc
50Dj1DP5tullV6AjCIPQ6dqLWxqXQgozcJY3ypLQhdu/jKglQvFXQoFUdpL1c2sOFpXSiOB3m+Gf
VeK863ohyxHHvD/sQrQSAbSnYzYVrTbQfTn6noD2J9VURK4t0LS1MD14sQl4ptCb4EkdKRFmmciq
QTb4ohOlD26Wq3C9mMsaCzjZ3xnjeRWMbK10Aw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 36560)
`pragma protect data_block
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
8vLpYwN6yKBw4iSQ+ASm1WM9Lk2Sxeo=
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
