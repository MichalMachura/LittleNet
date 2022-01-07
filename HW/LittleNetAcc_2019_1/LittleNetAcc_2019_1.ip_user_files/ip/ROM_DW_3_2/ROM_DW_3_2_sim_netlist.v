// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:04:06 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/ROM_DW_3_2_synth_1/ROM_DW_3_2_sim_netlist.v
// Design      : ROM_DW_3_2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ROM_DW_3_2,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module ROM_DW_3_2
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
  ROM_DW_3_2_blk_mem_gen_v8_4_4 U0
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
