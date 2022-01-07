`timescale 1ns / 1ps


module MuxWriterUnit_tb ();
	localparam IN_WIDTH = 7;
	localparam IN_HEIGHT = 5;
	localparam IN_CHANNELS = 15;
	localparam BIT_WIDTH = 8;
	localparam PARALLELISM = 10;
	localparam CNTR_BITS = 8;
	localparam LATCH = IN_CHANNELS;
	localparam LATCH_BITS = $clog2(LATCH);
	localparam OUT_SIZE = IN_WIDTH*IN_HEIGHT*IN_CHANNELS;
	localparam ADDRESS_BITS = $clog2(OUT_SIZE);
	localparam VALID_SIZE = IN_HEIGHT*IN_WIDTH*((IN_CHANNELS-1)/PARALLELISM+1);
	localparam VALID_CNTR_BITS = $clog2(VALID_SIZE);
	
	// CLOCK GENERATOR
	reg clk = 1'b0;
	reg [CNTR_BITS-1:0] cntr [PARALLELISM];
	reg [LATCH_BITS-1:0] latch_cntr[PARALLELISM];
	wire latch_now [PARALLELISM] ;
	reg [VALID_CNTR_BITS-1:0] valid_cntr[PARALLELISM];
	
	reg [11:0] reset_cntr = 0;
	initial 
		begin
		for(int k = 0; k < PARALLELISM; k = k+1)
			begin
			cntr[k] = k;
			latch_cntr[k] = 0;
			valid_cntr[k] = 0;
			end
		// for end
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
		reset_cntr <= reset_cntr+1;
		
		for(int k = 0; k < PARALLELISM; k = k+1)
			cntr[k] <= cntr[k]+1;
		// for end
		
		for(int k = 0; k < PARALLELISM; k = k+1)
			begin
			if (latch_cntr[k] == LATCH)
				begin
				latch_cntr[k] <= 0;
				end
			else
				latch_cntr[k] <= latch_cntr[k]+1;
			
			// count valid latches
			if (latch_now[k] && reset_cntr != 0)
				begin
				valid_cntr[k] <= valid_cntr[k] + 1;
				end
			end
			end
		// for end
	// always end
	genvar gen_i;
	generate
		for(gen_i = 0; gen_i < PARALLELISM; gen_i = gen_i+1)
			begin
			assign latch_now[gen_i] = latch_cntr[gen_i] == 0;
			end
		// for end
	endgenerate
	
	
	wire enable = 1'b1;
	wire reset = reset_cntr == 0;
	wire [BIT_WIDTH-1:0] in_data[PARALLELISM] = cntr;
	wire in_data_validity[PARALLELISM] = latch_now;
	wire [BIT_WIDTH-1:0] out_data_memory_in;
	wire [ADDRESS_BITS-1:0] out_data_memory_address;
	wire out_data_memory_write_enable;
	wire finished;
	
	
	MuxWriterUnit
		#(
		.BIT_WIDTH(BIT_WIDTH),
		.WIDTH(IN_WIDTH),
		.HEIGHT(IN_HEIGHT),
		.CHANNELS(IN_CHANNELS),
		.PARALLELISM(PARALLELISM),
		.REGISTER_FOR_EACH(1),
		.WRITE_MEMORY_LATENCY(2)
		)
		mwu
		(
		.clk(clk),
		.enable(enable),
		.reset(reset),
		.in_data(in_data),
		.in_data_validity(in_data_validity),
		
		.out_data_memory_in(out_data_memory_in),
		.out_data_memory_address(out_data_memory_address),
		.out_data_memory_write_enable(out_data_memory_write_enable),
		.finished(finished)
		);
	
	
endmodule // MuxWriterUnit_tb

