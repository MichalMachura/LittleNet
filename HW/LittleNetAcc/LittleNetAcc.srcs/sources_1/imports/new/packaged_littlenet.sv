`timescale 1ns / 1ps


module LittleNetAccAxi
		(
		input clk,
		input reset,
		
		// axi input
		input s_axis_clk,
		input [31:0] s_axis_tdata,
		input [3:0] s_axis_tkeep,
		input s_axis_tlast,
		input s_axis_tvalid,
		output s_axis_tready,
		
		// axi output
		input m_axis_clk,
		output [31:0] m_axis_tdata,
		output [3:0] m_axis_tkeep,
		output m_axis_tlast,
		output m_axis_tvalid,
		input m_axis_tready
		);
	
	
	 LittleNetAcc ln
	 			(
	 			.clk(clk),
	 			.reset(reset),
				
				.s_axis_tdata(s_axis_tdata),
				.s_axis_tkeep(s_axis_tkeep),
				.s_axis_tlast(s_axis_tlast),
				.s_axis_tvalid(s_axis_tvalid),
				.s_axis_tready(s_axis_tready),
				
				.m_axis_tdata(m_axis_tdata),
				.m_axis_tkeep(m_axis_tkeep),
				.m_axis_tlast(m_axis_tlast),
				.m_axis_tvalid(m_axis_tvalid),
				.m_axis_tready(m_axis_tready)
	 			);
	
endmodule // LittleNetAccWrapped

