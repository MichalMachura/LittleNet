// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 21:49:29 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/DSP_A_mul_B_PCOUT_synth_1/DSP_A_mul_B_PCOUT_stub.v
// Design      : DSP_A_mul_B_PCOUT
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "xbip_dsp48_macro_v3_0_18,Vivado 2020.2" *)
module DSP_A_mul_B_PCOUT(CLK, CE, A, B, PCOUT, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,CE,A[26:0],B[17:0],PCOUT[47:0],P[44:0]" */;
  input CLK;
  input CE;
  input [26:0]A;
  input [17:0]B;
  output [47:0]PCOUT;
  output [44:0]P;
endmodule
