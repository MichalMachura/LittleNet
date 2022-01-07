// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:04:06 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ROM_DW_3_2_sim_netlist.v
// Design      : ROM_DW_3_2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_3_2,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    addra,
    douta,
    sleep);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;
  input sleep;

  wire [11:0]addra;
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
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     1.558875 mW" *) 
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
  (* C_INIT_FILE = "ROM_DW_3_2.mem" *) 
  (* C_INIT_FILE_NAME = "ROM_DW_3_2.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2816" *) 
  (* C_READ_DEPTH_B = "2816" *) 
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
  (* C_WRITE_DEPTH_A = "2816" *) 
  (* C_WRITE_DEPTH_B = "2816" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27936)
`pragma protect data_block
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
mFE+MsqQ
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
