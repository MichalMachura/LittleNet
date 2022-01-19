// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Jan 18 21:47:50 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /media/michal/HDD_Linux_2/LittleNet/HW/LittleNetAcc/LittleNetAcc.gen/sources_1/ip/DSP_A_mul_B_add_PCIN_PCOUT/DSP_A_mul_B_add_PCIN_PCOUT_stub.v
// Design      : DSP_A_mul_B_add_PCIN_PCOUT
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dsp_macro_v1_0_1,Vivado 2020.2" *)
module DSP_A_mul_B_add_PCIN_PCOUT(CLK, CE, PCIN, A, B, PCOUT, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,CE,PCIN[47:0],A[26:0],B[17:0],PCOUT[47:0],P[47:0]" */;
  input CLK;
  input CE;
  input [47:0]PCIN;
  input [26:0]A;
  input [17:0]B;
  output [47:0]PCOUT;
  output [47:0]P;
endmodule
