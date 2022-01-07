// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:03:39 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/ROM_DW_3_0_synth_1/ROM_DW_3_0_sim_netlist.v
// Design      : ROM_DW_3_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_3_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module ROM_DW_3_0
   (clka,
    ena,
    addra,
    douta,
    sleep);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [10:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;
  input sleep;

  wire [10:0]addra;
  wire clka;
  wire [7:0]douta;
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
  wire [7:0]NLW_U0_doutb_UNCONNECTED;
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "11" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     0.924838 mW" *) 
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
  (* C_INIT_FILE = "ROM_DW_3_0.mem" *) 
  (* C_INIT_FILE_NAME = "ROM_DW_3_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "1408" *) 
  (* C_READ_DEPTH_B = "1408" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "8" *) 
  (* C_READ_WIDTH_B = "8" *) 
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
  (* C_WRITE_DEPTH_A = "1408" *) 
  (* C_WRITE_DEPTH_B = "1408" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  ROM_DW_3_0_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[7:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[7:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19904)
`pragma protect data_block
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
pR2ghC9wEJ97kDM=
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
