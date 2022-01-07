// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 21:55:53 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ROM_DW_1_2_sim_netlist.v
// Design      : ROM_DW_1_2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_1_2,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22160)
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
