// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Thu Jan  6 22:00:16 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /media/michal/HDD_Linux_2/DAC_SDC_2021/HW/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/RAM_A32_75000e_17a_B8_19a_synth_1/RAM_A32_75000e_17a_B8_19a_stub.v
// Design      : RAM_A32_75000e_17a_B8_19a
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module RAM_A32_75000e_17a_B8_19a(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb, 
  sleep)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[16:0],dina[31:0],clkb,enb,addrb[18:0],doutb[7:0],sleep" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [16:0]addra;
  input [31:0]dina;
  input clkb;
  input enb;
  input [18:0]addrb;
  output [7:0]doutb;
  input sleep;
endmodule
