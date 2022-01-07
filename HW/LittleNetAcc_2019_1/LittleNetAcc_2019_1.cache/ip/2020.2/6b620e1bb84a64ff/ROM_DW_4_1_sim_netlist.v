// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:05:31 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ ROM_DW_4_1_sim_netlist.v
// Design      : ROM_DW_4_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_4_1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
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
  (* C_INIT_FILE = "ROM_DW_4_1.mem" *) 
  (* C_INIT_FILE_NAME = "ROM_DW_4_1.mif" *) 
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
Gt+DIroT
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
