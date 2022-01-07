// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:01:43 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ROM_DW_1_0_sim_netlist.v
// Design      : ROM_DW_1_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_1_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22096)
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
