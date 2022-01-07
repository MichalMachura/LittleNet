`timescale 1ns / 1ps


module LittleNetAcc_tb ();
	
	// CLOCK GENERATOR
	reg clk = 1'b0;
	reg axi_clk = 1'b0;
	initial 
		begin
		clk <= 1'b0;
		#1;
		forever
			begin
			#1; clk <= 1'b1;
			#1; clk <= 1'b0;
			end
		end
	
	always @(posedge clk)
		begin
		axi_clk <= !axi_clk;
		end
	// always end
	
	reg [7:0] value = 0;
	wire data_valid = 1;
	
	always @(posedge axi_clk)
		begin
		value <= value+1;
		end
	// always end
	
	wire acc_tready;
	wire [31:0] acc_tdata;
	wire acc_tvalid;
	wire [3:0] acc_tkeep = 4'b1111;
	wire acc_tlast;
	
	LittleNetAccAxi ln
				(
				.clk(clk),
				.reset(1'b0),
				
				.s_axis_clk(axi_clk),
				.s_axis_tdata({4{value}}),
				.s_axis_tkeep(4'b1111),
				.s_axis_tlast(1'b1),
				.s_axis_tvalid(data_valid),
				.s_axis_tready(acc_tready),
				
				.m_axis_clk(axi_clk),
				.m_axis_tdata(acc_tdata),
				.m_axis_tkeep(acc_tkeep),
				.m_axis_tlast(acc_tlast),
				.m_axis_tvalid(acc_tvalid),
				.m_axis_tready(1'b1)
				);
	
endmodule // LittleNetAcc_tb

