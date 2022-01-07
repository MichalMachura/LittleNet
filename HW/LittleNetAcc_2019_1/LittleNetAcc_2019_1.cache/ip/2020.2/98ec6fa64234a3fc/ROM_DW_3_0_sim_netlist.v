// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:03:38 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ROM_DW_3_0_sim_netlist.v
// Design      : ROM_DW_3_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_3_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19968)
`pragma protect data_block
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
Ffh0F3RmbDHSo6H3HTgdd6TW
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
