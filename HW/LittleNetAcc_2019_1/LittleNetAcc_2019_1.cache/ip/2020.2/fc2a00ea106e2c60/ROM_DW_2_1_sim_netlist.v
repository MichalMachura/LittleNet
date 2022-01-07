// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:02:11 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ROM_DW_2_1_sim_netlist.v
// Design      : ROM_DW_2_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_2_1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20608)
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
