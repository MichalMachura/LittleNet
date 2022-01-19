// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Tue Jan 18 23:18:07 2022
// Host        : michal-Lenovo-ideapad-700-17ISK running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /media/michal/HDD_Linux_2/LittleNet/HW/LN_Ultra96/LN_Ultra96.gen/sources_1/bd/design_1/ip/design_1_LittleNetAccAxi_0_0/design_1_LittleNetAccAxi_0_0_stub.v
// Design      : design_1_LittleNetAccAxi_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "LittleNetAccAxi,Vivado 2020.2" *)
module design_1_LittleNetAccAxi_0_0(clk, reset, s_axis_clk, s_axis_tdata, 
  s_axis_tkeep, s_axis_tlast, s_axis_tvalid, s_axis_tready, m_axis_clk, m_axis_tdata, 
  m_axis_tkeep, m_axis_tlast, m_axis_tvalid, m_axis_tready)
/* synthesis syn_black_box black_box_pad_pin="clk,reset,s_axis_clk,s_axis_tdata[31:0],s_axis_tkeep[3:0],s_axis_tlast,s_axis_tvalid,s_axis_tready,m_axis_clk,m_axis_tdata[31:0],m_axis_tkeep[3:0],m_axis_tlast,m_axis_tvalid,m_axis_tready" */;
  input clk;
  input reset;
  input s_axis_clk;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tkeep;
  input s_axis_tlast;
  input s_axis_tvalid;
  output s_axis_tready;
  input m_axis_clk;
  output [31:0]m_axis_tdata;
  output [3:0]m_axis_tkeep;
  output m_axis_tlast;
  output m_axis_tvalid;
  input m_axis_tready;
endmodule
