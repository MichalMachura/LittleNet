// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:05:32 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/ROM_DW_4_1_synth_1/ROM_DW_4_1_sim_netlist.v
// Design      : ROM_DW_4_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_4_1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module ROM_DW_4_1
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
  ROM_DW_4_1_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27872)
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
