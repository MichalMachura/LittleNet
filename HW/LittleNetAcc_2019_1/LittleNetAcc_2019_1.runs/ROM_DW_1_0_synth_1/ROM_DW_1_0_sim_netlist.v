// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:01:44 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/ROM_DW_1_0_synth_1/ROM_DW_1_0_sim_netlist.v
// Design      : ROM_DW_1_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_1_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module ROM_DW_1_0
   (clka,
    ena,
    addra,
    douta,
    sleep);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;
  input sleep;

  wire [7:0]addra;
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
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     1.549983 mW" *) 
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
  (* C_INIT_FILE = "ROM_DW_1_0.mem" *) 
  (* C_INIT_FILE_NAME = "ROM_DW_1_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "165" *) 
  (* C_READ_DEPTH_B = "165" *) 
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
  (* C_WRITE_DEPTH_A = "165" *) 
  (* C_WRITE_DEPTH_B = "165" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  ROM_DW_1_0_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22048)
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
