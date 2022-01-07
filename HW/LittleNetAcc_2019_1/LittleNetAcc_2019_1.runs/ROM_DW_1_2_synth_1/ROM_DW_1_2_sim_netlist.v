// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 21:55:54 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/ROM_DW_1_2_synth_1/ROM_DW_1_2_sim_netlist.v
// Design      : ROM_DW_1_2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_1_2,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module ROM_DW_1_2
   (clka,
    ena,
    addra,
    douta,
    sleep);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;
  input sleep;

  wire [8:0]addra;
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
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
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
  (* C_INIT_FILE = "ROM_DW_1_2.mem" *) 
  (* C_INIT_FILE_NAME = "ROM_DW_1_2.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "352" *) 
  (* C_READ_DEPTH_B = "352" *) 
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
  (* C_WRITE_DEPTH_A = "352" *) 
  (* C_WRITE_DEPTH_B = "352" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  ROM_DW_1_2_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22112)
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
