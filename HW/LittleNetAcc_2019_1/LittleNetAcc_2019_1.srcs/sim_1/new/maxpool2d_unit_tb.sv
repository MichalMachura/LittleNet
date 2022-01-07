`timescale 1ns / 1ps


module MaxPool2dUnit_tb();
	localparam IN_WIDTH = 8;
	localparam IN_HEIGHT = 6;
	localparam IN_CHANNELS = 15;
	localparam BIT_WIDTH = 8;
	localparam INT_WIDTH = 2;
	localparam SIGNED = 1;
	localparam PARALLELISM = 3;
	localparam CEIL_MODE = 1;
	localparam CMP_ZERO = 0;
	localparam CNTR_BITS = 8;
	// CLOCK GENERATOR
	reg fast_clk = 1'b0;
	reg [3:0] clk_cntr = 0;
	wire clk = clk_cntr[3];
	
	initial 
		begin
		// for end
		fast_clk <= 1'b0;
		#1;
		forever
			begin
			#1; fast_clk <= 1'b1;
			#1; fast_clk <= 1'b0;
			end
		end
		
	always @(posedge fast_clk)
		begin
		clk_cntr <= clk_cntr+1;
		end
	// always end
	
	reg enable = 0, reset = 0, all_data_in_stream = 0;
	reg [BIT_WIDTH-1:0] in_data [PARALLELISM];
	reg in_data_validity[PARALLELISM];
	wire [BIT_WIDTH-1:0] out_data [PARALLELISM];
	wire out_data_validity[PARALLELISM];
	
	MaxPool2dUnit 	#(
					.DATA_BIT_WIDTH(BIT_WIDTH),
					// .DATA_INT_WIDTH(IN_WIDTH),
					.DATA_SIGNED(SIGNED),
					
					.IN_WIDTH(IN_WIDTH),
					.IN_HEIGHT(IN_HEIGHT),
					.PARALLELISM(PARALLELISM),
					.CEIL_MODE(CEIL_MODE),
					.COMPARE_TO_ZERO(CMP_ZERO)
					)
					mp2d
					(
					.clk(clk),
					.enable(enable),
					.reset(reset),
					.all_data_in_stream(all_data_in_stream),
					.in_data(in_data),
					.in_data_validity(in_data_validity),
					.out_data(out_data),
					.out_data_validity(out_data_validity)
					);
	
	initial
		begin
		for(int i = 0; i < PARALLELISM; i = i+1)
			begin
			in_data[i] = 0;
			in_data_validity[i] = 0;
			end
		// for end
		forever
			begin
			reset = 1;
			@(posedge clk);
			@(posedge fast_clk);
			reset = 0;
			@(posedge clk);
			@(posedge fast_clk);
			enable = 1;
			@(posedge clk);
			
			for(int ch = 0; ch < IN_CHANNELS; ch = ch+1)
				begin
				for(int row = 0; row < IN_HEIGHT; row = row+1)
					begin
					for(int col = 0; col < IN_WIDTH; col = col+1)
						begin
						@(posedge clk);
						@(posedge fast_clk);
						for(int i = 0; i < PARALLELISM; i = i+1)
							begin
							in_data[i] = $random;
							in_data_validity[i] = 1;
							end
						@(posedge clk);
						@(posedge fast_clk);
						for(int i = 0; i < PARALLELISM; i = i+1)
							in_data_validity[i] = 0;
							
						for(int cc = 0; cc < 10; cc = cc+1)
							@(posedge clk);
						end
					end
				end
			// for end
			
			@(posedge clk);
			@(posedge fast_clk);
			all_data_in_stream = 1;
			
			for(int cc = 0; cc < 50; cc = cc+1)
				@(posedge clk);
			enable = 0;
			for(int cc = 0; cc < 100; cc = cc+1)
				@(posedge clk);
			end
		end
	
endmodule
