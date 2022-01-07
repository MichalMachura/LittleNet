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
		
		// debug
//		input debug_addr,
//        output [31:0] debug_reg_data
		);
	
	wire write_possible;
	wire data_in_validity;
	wire [31:0] data_in;
	ReceiveFromAxis #(
					.BIT_WIDTH(32),
					.DATA_SIZE((100*200*3) / 4),
					.AXI_SAME_CLK(1)
					)
					receiver
					(
					.axis_clk(s_axis_clk),
					.axis_tdata(s_axis_tdata),
					.axis_tkeep(s_axis_tkeep),
					.axis_tlast(s_axis_tlast),
					.axis_tvalid(s_axis_tvalid),
					.axis_tready(s_axis_tready),
					
					.clk(clk),
					.reset(reset),
					
					.write_possible(write_possible),
					.data_out(data_in),
					.data_out_validity(data_in_validity)
					);
	
	wire output_was_read;
	wire out_data_ready;
	wire [7:0] out_data [7];
	
	// debug beg
//	wire [32:0] data1;
//	wire [32:0] data2;
	
//	assign data1 = {out_data[0],out_data[1],out_data[2],out_data[3]};
//	assign data2 = {out_data[4],out_data[5],out_data[6],6'b0,out_data_ready,output_was_read};
	  
//	assign debug_reg_data = debug_addr? data2 : data1;
	// debug end
	
	 LittleNetAcc ln
	 			(
	 			.clk(clk),
	 			.reset(reset),
				
	 			.data_in(data_in),
	 			.data_in_validity(data_in_validity),
	 			.write_possible(write_possible),
				
	 			.output_data_ready(out_data_ready),
	 			.output_data(out_data),
	 			.output_was_read(output_was_read)
				 
				// .state_read(state)
	 			);
	
	
	SendToAxis	#(
				.AXIS_BIT_WIDTH(32),
				.DATA_BIT_WIDTH(8),
				.DATA_COUNT(7)
				)
				sender
				(
				.axis_clk(m_axis_clk),
				.axis_tdata(m_axis_tdata),
				.axis_tkeep(m_axis_tkeep),
				.axis_tlast(m_axis_tlast),
				.axis_tvalid(m_axis_tvalid),
				.axis_tready(m_axis_tready),
				
				.clk(clk),
				.reset(reset),
				
				.data_ready_to_send(out_data_ready),
				.data(out_data),
				.data_were_send(output_was_read)
				);
	
endmodule // LittleNetAccWrapped

