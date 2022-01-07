`timescale 1ns / 1ps


module tb_SlidingWindow();

	localparam WIDTH = 15;
	localparam HEIGHT = 13;
	localparam CHANNELS = 3;
	localparam NUM_OF_PASS = 5;
	localparam ADDR_W = $clog2(WIDTH*HEIGHT*CHANNELS);
	localparam DATA_WIDTH = 8;
	localparam LATENCY = 2;
	
	wire [8-ADDR_W-1:0] V = 0;
	
	// CLOCK GENERATOR
	reg clk = 1'b0;
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
		
	wire read_enable;
	wire [ADDR_W-1:0] addr_in;
	wire [DATA_WIDTH-1:0] data_out;
	
	
	 ROM_8b_11addr_2048_elem ROM(
	 						   .clka(clk),
	 						   .ena(read_enable),
	 						   .addra({V,addr_in}),
	 						   .douta(data_out),
	 						   .sleep(1'b0)
	 						   );
	
	wire kernel_validity;
	wire [DATA_WIDTH-1:0] kernel [9];
	
	SlidingWindowUnit #(.IN_WIDTH(WIDTH), 
					   .IN_HEIGHT(HEIGHT),
					   .IN_CHANNELS(CHANNELS),
					   .NUM_OF_PASS(NUM_OF_PASS),
					   .PADDING_W(1),
					   .PADDING_H(1),
					   .DATA_BIT_WIDTH(DATA_WIDTH),
					   .MEMORY_LATENCY(LATENCY)) 
					   SW (.clk(clk), 
					   	   .enable(1'b1), 
						   .reset(1'b0), 
					   	//    .enable(1'b0), 
						//    .reset(1'b1), 
						   .memory_out(data_out), 
						   .memory_address(addr_in),
						   .memory_read_enable(read_enable),
						   .kernel_validity(kernel_validity),
						   .kernel(kernel)
						   );

	
	
endmodule // tb_SlidingWindow


