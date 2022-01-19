`timescale 1ns / 1ps


module StreamerUnit_tb();
	// localparam IN_WIDTH = 360;
	// localparam IN_HEIGHT = 180;
	localparam IN_WIDTH = 11;
	localparam IN_HEIGHT = 1;
	localparam IN_CHANNELS = 15;
	localparam BIT_WIDTH = 8;
	localparam CNTR_BITS = 10;
	localparam ADDRESS_BITS = $clog2(IN_CHANNELS*IN_WIDTH*IN_HEIGHT);
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
		
	reg [CNTR_BITS+1:0] cntr = 0;
	always @(posedge clk)
		begin
		cntr <= cntr+1;
		end
	// always end
	
	
	wire [BIT_WIDTH-1:0] in_data_memory_out;
	wire [ADDRESS_BITS-1:0] in_data_memory_address;
	wire in_data_memory_read_enable;
	
	// INPUT DATA
	FileROM #(
			  .path("F:/LittleNet_ACC_verilog/LittleNet_ACC/custom_memories/rom_point_streamer.txt"),
			  .IMG_WIDTH(IN_WIDTH),
			  .IMG_HIGHT(IN_HEIGHT),
			  .IMG_CHANNELS(IN_CHANNELS),
		 	  .WIDTH(BIT_WIDTH),
		 	  .DEPTH(2048)
		 	 )
			 file_rom_point_streamer
			 (
			 .clka(clk),
			 .douta(in_data_memory_out),
			 .addra({{(11-ADDRESS_BITS){1'b0}},in_data_memory_address}),
			 .ena(in_data_memory_read_enable),
			 .sleep(1'b0)
			 );
	
	wire enable;
	wire reset;
	wire validity;
	wire [BIT_WIDTH-1:0] pixel_value;
	wire end_point;
	wire end_pass;
	
	assign reset = cntr[7:0] == 8'b1;
	assign enable = cntr[10];
	
	PointStreamerUnit
		#(
		 .IN_WIDTH(IN_WIDTH),
		 .IN_HEIGHT(IN_HEIGHT),
		 .IN_CHANNELS(IN_CHANNELS),
		 .BIT_WIDTH(BIT_WIDTH),
		 .READ_LATENCY(2)
		 )
		 point_streamer
		 (
		 .clk(clk),
		 .enable(enable),
		 .reset(reset),
		 .pixel_value(pixel_value),
		 .validity(validity),
		 .end_point(end_point),
		 .end_pass(end_pass),
		 .in_data_memory_address(in_data_memory_address),
		 .in_data_memory_read_enable(in_data_memory_read_enable),
		 .in_data_memory_out(in_data_memory_out)
		 );
	
	
	/// CYCLIC STREAMER
	localparam CS_DATA_ADDRESS_BITS = $clog2(11*15);
	localparam CS_TOTAL_WEIGHTS = 11;
	localparam CS_CHANNELS_IN = 8;
	localparam CS_BIAS = 1;
	localparam CS_BN = 2;
	localparam CS_FILERS = 15;
	
	wire [BIT_WIDTH-1:0] cs_memory_out;
	wire [CS_DATA_ADDRESS_BITS-1:0] cs_memory_address;
	wire cs_memory_read_enable;
	
	// WEIGHT DATA
	FileROM #(
			  .path("F:/LittleNet_ACC_verilog/LittleNet_ACC/custom_memories/rom_cyclic_streamer.txt"),
			  .WIDTH(BIT_WIDTH),
		 	//   .DEPTH(CS_FILERS*CS_TOTAL_WEIGHTS) 
		 	  .DEPTH(2048) 
			 )
			 file_rom_cyclic_streamer
			 (
			 .clka(clk),
			 .douta(cs_memory_out),
			 .addra({{(11-CS_DATA_ADDRESS_BITS){1'b0}},cs_memory_address}),
			 .ena(cs_memory_read_enable),
			 .sleep(1'b0)
			 );
	
	wire cs_enable;
	wire cs_reset;
	wire cs_streaming;
	wire cs_validity;
	wire [BIT_WIDTH-1:0] cs_weight_values [1+CS_BIAS+CS_BN];
	wire cs_next_cycle;
	wire cs_end_of_data;
	wire cs_end_of_cycle_start_loading;
	
	// assign cs_reset = cntr[7:0] == 8'b1;
	// assign cs_reset = cntr[9:0] == 10'b0;
	// assign cs_enable = cntr[10];
	assign cs_enable = 1'b1;
	
	
	// cntr for number of streamed pixels
	reg [9:0] cntr_streaming = 0;
	always @(posedge clk)
		begin
		if (cs_validity)
			begin
			if (cntr_streaming != CS_FILERS*CS_CHANNELS_IN-1)
				cntr_streaming <= cntr_streaming+1;
			else
				cntr_streaming <= 0;
			end
		end
	// always end
	assign cs_next_cycle = cntr_streaming > (CS_FILERS*CS_CHANNELS_IN-1-CS_CHANNELS_IN);
	
	reg delay_of_reset [3];
	always @(posedge clk)
		begin
		delay_of_reset[0] <= cs_end_of_data && cs_next_cycle;
		for(int i=1; i < 3; i = i+1)
			delay_of_reset[i] <= delay_of_reset[i-1];
		end
	// always end
	assign cs_reset = delay_of_reset[2];
	
	CyclicStreamerUnit
		#(
		 .BIT_WIDTH(BIT_WIDTH),
		 .CYCLE_LENGTH(CS_CHANNELS_IN),
		 .PRE_DATA(CS_BIAS+CS_BN),
		 .NUM_OF_CYCLES(CS_FILERS),
		 .READ_LATENCY(2)
		 )
		 cyclic_streamer
		 (
		 .clk(clk),
		 .enable(cs_enable),
		 .reset(cs_reset),
		 
		 .output_stream(cs_weight_values),
		 
		 .next_cycle(cs_next_cycle && cs_end_of_cycle_start_loading),
		 .validity(cs_validity),
		 .streaming(cs_streaming),
		 .end_of_cycle(cs_end_of_cycle_start_loading),
		 .end_of_data(cs_end_of_data),
		 
		 .data_memory_address(cs_memory_address),
		 .data_memory_read_enable(cs_memory_read_enable),
		 .data_memory_out(cs_memory_out)
		 );
	
endmodule
