// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:11:37 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/ROM_PW_5_0_synth_1/ROM_PW_5_0_sim_netlist.v
// Design      : ROM_PW_5_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_PW_5_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module ROM_PW_5_0
   (clka,
    ena,
    addra,
    douta,
    sleep);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [39:0]douta;
  input sleep;

  wire [9:0]addra;
  wire clka;
  wire [39:0]douta;
  wire ena;
  wire sleep;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [39:0]NLW_U0_doutb_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [39:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "1" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.714423 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "ROM_PW_5_0.mem" *) 
  (* C_INIT_FILE_NAME = "ROM_PW_5_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "771" *) 
  (* C_READ_DEPTH_B = "771" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "40" *) 
  (* C_READ_WIDTH_B = "40" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "771" *) 
  (* C_WRITE_DEPTH_B = "771" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "40" *) 
  (* C_WRITE_WIDTH_B = "40" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  ROM_PW_5_0_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[39:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[39:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(sleep),
        .wea(1'b0),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
QGLtnqZzRetDH6gCWT4Js6wuLlZfrNx/VJp3sfR2NF+cxypO5AxN0oDKLJJtmdrtE/ueNDg+Qf7Z
TqBNRojORA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
B6Ger3hRvfjHkaJ+W8639Kl3TzC9TogLuklOXEiMNdc4Im+DjEUzxb3DKlzu0VW3zxZqjJ3+wsW/
LnRmPCESi5Y9eRJaLFXg79EMfoj4X+nTdHAP6yCfltBADKegZ12gpnB/8ey5yn2KA74LUtPC7jna
iyjqSfsWLGnz6UdXzwk=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BX+DxgMPRyZbYojCUR9Sk8Lq+3ZigBz4yMFHQkmurfdfDzyTPJCE827eGiPyTenK1QPVhEtf9g06
0BFXq/0COPuU1BWJwdkz1c4dE6/exDwhvEh+hPx3vRY6z8fDEf6aGVIXrHDvrmddehe7yMSIpo+k
aXHR06EEdfHCFY4TggYwhcJVXjkE+ApsVuyfmEfPmYjo8hCWyQyBsUWIOY03q1+MvUjjsmTwgs9g
fh5MY9ToaLfoJxPKdCpsqrBX4LJ+VDGFlAqIcqHTE2jCmPiToZAFXB7fzf1wDjFCBlJyFVDBGi0i
m+CouLSb7X1mvVhdDZgNrZDJMV688Bu3o54vew==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DaIU/Ddc8USbZ2mURzujJDWDH1JbHl5tFVOOQ2aVaUPIA71yyE38OXVLEtF8rNmujYH30nEeQ+FV
LVJ16aaHw+iiuaqorTM3K5KLohVlN+WlcEtSXHuPNHjw8ddqtzpaX7pH1zqZH+YmfCL5oaNLqDH4
rkBnUl0/Gm/hzSwKjYhXGQFYQ+gGP99OjXakzrAqZzp/Iq4gt+Z5902/JV9thd/isHQImJ0QyK8M
EKM579iPAfXGes2mbiNYHcvDmSPYmW1zlhOE++N1EKeea7j/msnKeyhlC+hGE4Xfn4TVvqgQexCT
rp/wS/MosY6WH1aKFQlFH2hEppA7KXUaQlvG+w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
XmWoAt4X8hrCJ5yTyug4ajJW5UhfkLNibzjihWzZ4Cr9hQSvWZoTc8rjGsLPbz6Le+/9iI5KxecS
eR0wiAO+G2IkwhZgVBeZdKoFnlnTVAyLjk9wMAFXNyJZM6b1NDbfXlPcUsC6JePvPlwwdWknkSsC
r3KvgkWAS+O3xvRmaNw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hw3Y+rShKrXiUViyNU1/O2qv6TgheLHBnFMj1i9MUGrHYqh9pLfLYUgWR7S2vj4jv4S+Ks0BpP4p
dKEqVAFmTCfQNEUHaVcFPkOHgig6L4mhLY6HUUKJoRgiQepgLi/W3V+ZZPQSQFkB3CU4MsJzhXvR
yLcpDriZy8cnAHD87Zi5DrNGBzj3kigJeM0du6lCQbxtF5aEdoaNP+YTnIFtcqYhoYnswQlYt0sV
HKgFA8VzqzL5WYnpH7+1IKmFkJBHkyqHCa9wPK0qCKnxkuDj70YzPVqQ+cocdKU+/gNdpCOdZlci
F2HTxrgfrXndJru3TiDqu4UavqAe0MNuFp3t0w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XPVggoWL6aXz+MpODTOZhEUQDa0vfEnUDaYeEHXm2vGyqKJujN2c/FFAFBeBYdJATLsIsQ+BqoPc
pBbcFYXDBfOtFIW2dH6Y1OoD65KyJ/hAq8coa21kFgq4hFat5vzZ2iIfkCpTUr4vDZO7Xne8cZO9
WsHffoTCt5rS59wWm2b8I5R8Eh2TUbQg3RCyrcnD66cvcEnlXe1CNMQ4/loVJpA4IBinBf820Wjc
vw2fZbGI0jXC+ACSHOviH63Xwmn+aRV5Ppkup7IYoon/ieKapRQeASu3TTY37xSBXiInSdtMTzJ6
+4GfO4eSHVriCk/sWbuTBzfRzoSShrnHjzz5LA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L78XuiswVcgO2gtebzL7SA9BC/jJGAM0v6S9pzmyqL+QYzRneiYeGyDmsW33jEVVSTuNjTXkBLY7
yTOKQruatwe4V0OLi6174saSAmPgerSV1GyLP7KhmusLV/N61avC9TPam+tekhKeE0tds4EnJ3et
4JdLh+SE4Z4pcuqCjB5MFneIYKKWDx7siU6oesAQtoSJOesfMchX63MhOjOHFP/ch+1gHv3T45hg
IGF7V7TrdREVE4f9631tlVJ1o2Dypsmo/76Itz5WCGlTMjAnWXN8IXxKN+PZ3dyt1wjrZm2P/td+
xiGszFnSLrRvw/HferwtSmRx8q0fiHZ88roGTw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kDX5kq2QEe25429T6vQqBCFvV1McKTJRYfK99ymVNK2GGvGLXSzgwJHwB2fj9rM0wme3zYYY0vQR
x+9F4L7KLlOVY6qY3LB59uDzyXBI3mMZaS905HXHJkdZHWtQWpfHhl27LqL+8FSluaD6F+KFfYOV
CwIOVuCIp/XjxFXpNBik7YiPt4kHOlDA97IXNLnYUn/g1csGqeNWce4UTne50ggWvLYGbTFGmTjT
N67TpUiGRVRCSv8Tax72GWFIMFZk3Tlp68ZUSQEybZMWX1U9XdMdtxfvNGhf8mi5jQJ2SupSzKu4
T/+53IN9T8aLePAiGBKKG1ZBj4y1ZyYA7XYvjw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 42144)
`pragma protect data_block
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
ZtKWYzkjiNNQQUzBVfdDxhXvfKt7
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
