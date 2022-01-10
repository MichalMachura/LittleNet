`timescale 1ns / 1ns


module Tmp_tb
		(
		);
	
	// CLOCK GENERATOR
	reg clk = 1'b0;
	initial 
		begin
		clk <= 1'b0;
		#1;
		forever
			begin
			#1; clk <= 1'b0;
			#1; clk <= 1'b1;
			end
		end
		
	reg val = 0;
	reg pt_end = 0;
	reg rst = 0;
	reg [7:0] weight = 0;
	reg [7:0] data = 0;
	reg [7:0] bias = 0;
	
	initial
	   forever
            begin
            #10;
            
			for(int f=0; f < 5; f = f+1)
				begin
				// filter change
				val <= 1'b0;
				pt_end <= 1'b0;
				@(posedge clk);
				wait(clk);
				weight <= f*15;
				@(posedge clk);
				wait(clk);
				bias <= f+3;
				
				for(int j=0; j < 2; j = j+1)
					begin
					for(int i=0; i < 5; i = i+1)
						begin
						@(posedge clk);
						wait(clk);
						pt_end <= 1'b0;
						data <= j+i+1;
						val <= 1'b1;
						end
					pt_end <= 1'b1;
					end
				
				@(posedge clk);
				wait(clk);
				val <= 1'b0;
				pt_end <= 1'b0;
				end
			
			// wait before next conv
			for(int j=0; j < 14; j = j+1)
				begin
				@(posedge clk);
				wait(clk);
				end
			
			// end of all filters
			@(posedge clk);
			wait(clk);
			rst <= 1'b1;
			
			// wait before next conv
			for(int j=0; j < 2; j = j+1)
				begin
				@(posedge clk);
				wait(clk);
				rst <= 1'b0;
				end
            end
	
	reg [7:0] cntr = 0;
	always @(posedge clk)
		begin
        cntr <= cntr+1;
		end
	// always end
	
	wire [47:0] P;
	wire [7:0] out;
	wire out_val;
	wire [7:0] weight_array [2];
	assign weight_array[0] = weight;
	assign weight_array[1] = bias;
	
	
	PointwiseComputationUnit
		#(
		 .USE_BIAS(1),
		 .USE_BN(0),
		 .USE_RELU(0),
		 .IN_DATA_BIT_WIDTH(8),
		 .IN_DATA_INT_WIDTH(8),
		 .IN_DATA_SIGN(0),
		 .WEIGHT_DATA_BIT_WIDTH(8),
		 .WEIGHT_DATA_INT_WIDTH(8),
		 .WEIGHT_DATA_SIGN(0),
		 .BIAS_DATA_BIT_WIDTH(8),
		 .BIAS_DATA_INT_WIDTH(8),
		 .BIAS_DATA_SIGN(0),
		 .INTER_DATA_BIT_WIDTH(8),
		 .INTER_DATA_INT_WIDTH(8),
		 .INTER_DATA_SIGN(0),
		 .BN_W_DATA_BIT_WIDTH(8),
		 .BN_W_DATA_INT_WIDTH(8),
		 .BN_W_DATA_SIGN(0),
		 .BN_B_DATA_BIT_WIDTH(8),
		 .BN_B_DATA_INT_WIDTH(8),
		 .BN_B_DATA_SIGN(0),
		 .OUT_DATA_BIT_WIDTH(8),
		 .OUT_DATA_INT_WIDTH(8),
		 .OUT_DATA_SIGN(0)
		 )
		pw_PE
		 (
		  .clk(clk),
		  .enable(1'b1),
		  .reset(rst),
		  .input_data(data),
		  .input_weights(weight_array),
		  .input_validity(val),
		  .input_end_of_point(pt_end),
		  .output_data(out),
		  .output_data_validity(out_val)
		 );
	
//	wire [127:0] rom_0_0_douta;
//	wire rom_0_0_ena = 1;
	
//	ROM_PW_1_1 ROM_1_1
//			(
//			.clka(clk),
//			.sleep(0),
//			.addra(cntr),
//			.douta(rom_0_0_douta),
//			.ena(rom_0_0_ena)
//			);
	
//	wire [7:0] douta[16];
//	genvar gen_i;
//	generate
//		for(gen_i = 0; gen_i < 16; gen_i = gen_i+1)
//			begin
//			assign douta[16-gen_i-1] = rom_0_0_douta[(gen_i+1)*8-1:gen_i*8];
//			end
//		// for end
//	endgenerate
/*
00001011
00000010
00000111
11111011
11111111
11111100
11111110
00000110
11110101
00001010
11111111
11111011
00000000
00011001
00000111
11111100
*/
endmodule // Tmp_tb


