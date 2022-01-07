// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:02:12 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/ROM_DW_2_1_synth_1/ROM_DW_2_1_sim_netlist.v
// Design      : ROM_DW_2_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_2_1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module ROM_DW_2_1
   (clka,
    ena,
    addra,
    douta,
    sleep);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;
  input sleep;

  wire [9:0]addra;
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
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     0.774991 mW" *) 
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
  (* C_INIT_FILE = "ROM_DW_2_1.mem" *) 
  (* C_INIT_FILE_NAME = "ROM_DW_2_1.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "704" *) 
  (* C_READ_DEPTH_B = "704" *) 
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
  (* C_WRITE_DEPTH_A = "704" *) 
  (* C_WRITE_DEPTH_B = "704" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  ROM_DW_2_1_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20560)
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
