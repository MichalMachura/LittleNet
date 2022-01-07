`timescale 1ns / 1ps


module DepthwiseConv2dUnit_tb ();
	localparam IN_WIDTH = 13;
	localparam IN_HEIGHT = 7;
	localparam IN_CHANNELS = 128;
	localparam PADDING_W = 1;
	localparam PADDING_H = 1;
	localparam CHANNEL_MUL = 2;
	localparam USE_BIAS = 0;
	localparam USE_BN = 1;
	localparam USE_RELU = 1;
	localparam GROUPS = 4;
	localparam IN_DATA_BIT_WIDTH = 8;
	localparam IN_DATA_INT_WIDTH = 1;
	localparam IN_DATA_SIGN=1;
	localparam WEIGHT_DATA_BIT_WIDTH = 8;
	localparam WEIGHT_DATA_INT_WIDTH = 3;
	localparam WEIGHT_DATA_SIGN=1;
	localparam OUT_DATA_BIT_WIDTH = 8;
	localparam OUT_DATA_INT_WIDTH = 1;
	localparam OUT_DATA_SIGN=1;
	localparam READ_MEMORY_LATENCY = 2;
	localparam WRITE_MEMORY_LATENCY = 2;
	localparam CNTR_BITS = $clog2(IN_CHANNELS*CHANNEL_MUL*IN_WIDTH*IN_HEIGHT);
	localparam WEIGHT_ADDRESS_BITS = $clog2(CHANNEL_MUL*IN_CHANNELS*(9+USE_BIAS+2*USE_BN));
	localparam IN_ADDRESS_BITS = $clog2(IN_CHANNELS*IN_WIDTH*IN_HEIGHT);
	localparam OUT_ADDRESS_BITS = $clog2(CHANNEL_MUL*IN_CHANNELS*IN_WIDTH*IN_HEIGHT / GROUPS);
	
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
	
	wire reset;
	// assign reset = cntr == 10'b0;
	assign reset = cntr == {{(CNTR_BITS-2){1'b0}}, {2{1'b1}}};
	
	wire enable, finished, in_data_memory_read_enable;
	wire out_data_memory_write_enable;
	wire weights_memory_read_enable;
	
	wire [IN_DATA_BIT_WIDTH-1:0] in_data_memory_out;
	wire [WEIGHT_DATA_BIT_WIDTH-1:0] weights_memory_out;
	wire [OUT_DATA_BIT_WIDTH*GROUPS-1:0] out_data_memory_in;
	
	wire [IN_ADDRESS_BITS-1:0] in_data_memory_address;
	wire [WEIGHT_ADDRESS_BITS-1:0] weights_memory_address;
	wire [OUT_ADDRESS_BITS-1:0] out_data_memory_address;
	
	assign enable = 1'b1;
	
	DepthwiseConv2dUnit #(
						 .IN_WIDTH(IN_WIDTH),
						 .IN_HEIGHT(IN_HEIGHT),
						 .IN_CHANNELS(IN_CHANNELS),
						 .PADDING_W(PADDING_W),
						 .PADDING_H(PADDING_H),
						 .CHANNEL_MUL(CHANNEL_MUL),
						 .USE_BIAS(USE_BIAS),
						 .USE_BN(USE_BN),
						 .USE_RELU(USE_RELU),
						 .GROUPS(GROUPS),
						 .IN_DATA_BIT_WIDTH(IN_DATA_BIT_WIDTH),
						 .IN_DATA_INT_WIDTH(IN_DATA_INT_WIDTH),
						 .IN_DATA_SIGN(IN_DATA_SIGN),
						 .WEIGHT_DATA_BIT_WIDTH(WEIGHT_DATA_BIT_WIDTH),
						 .WEIGHT_DATA_INT_WIDTH(WEIGHT_DATA_INT_WIDTH),
						 .WEIGHT_DATA_SIGN(WEIGHT_DATA_SIGN),
						 .OUT_DATA_BIT_WIDTH(OUT_DATA_BIT_WIDTH),
						 .OUT_DATA_INT_WIDTH(OUT_DATA_INT_WIDTH),
						 .OUT_DATA_SIGN(OUT_DATA_SIGN),
						 .READ_MEMORY_LATENCY(READ_MEMORY_LATENCY),
						 .WRITE_MEMORY_LATENCY(WRITE_MEMORY_LATENCY)
						 )
						dw_conv2d
						(
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.finished(finished),
						.in_data_memory_out(in_data_memory_out),
						.in_data_memory_address(in_data_memory_address),
						.in_data_memory_read_enable(in_data_memory_read_enable),
						.weights_memory_out(weights_memory_out),
						.weights_memory_address(weights_memory_address),
						.weights_memory_read_enable(weights_memory_read_enable),
						.out_data_memory_in(out_data_memory_in),
						.out_data_memory_address(out_data_memory_address),
						.out_data_memory_write_enable(out_data_memory_write_enable)
						);
	
	// WEIGHTS DATA
	FileROM #(
			.path("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/custom_memory_inits/rom_init_weights_dw.txt"),
			.IMG_WIDTH(1),
			.IMG_HIGHT(1),
			.IMG_CHANNELS( CHANNEL_MUL*IN_CHANNELS*(9+USE_BIAS+USE_BN*2)),
			.WIDTH(WEIGHT_DATA_BIT_WIDTH)
			// .DEPTH(2048)
		 	 )
			
			ROM_weights
			(
			.clka(clk),
			.douta(weights_memory_out),
			.addra(weights_memory_address),
			.ena(weights_memory_read_enable),
			.sleep(1'b0)
			);
	
	// INPUT DATA
	FileROM #(
			  .path("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/custom_memory_inits/rom_init_data_dw.txt"),
			  .IMG_WIDTH(IN_WIDTH),
			  .IMG_HIGHT(IN_HEIGHT),
			  .IMG_CHANNELS(IN_CHANNELS),
		 	  .WIDTH(8)
		 	//   .DEPTH(2048)
		 	 )
			 file_rom
			 (
			 .clka(clk),
			 .douta(in_data_memory_out),
			 .addra(in_data_memory_address),
			 .ena(in_data_memory_read_enable),
			 .sleep(1'b0)
			 );
	
	// OUTPUT DATA
	wire saving;
	wire delayed_saving;
	wire [OUT_DATA_BIT_WIDTH*GROUPS-1:0] din;
	
	genvar gen_b;
	generate
		for(gen_b = 0; gen_b < GROUPS; gen_b = gen_b+1)
			begin
			// to big endian
			assign din[(gen_b+1)*OUT_DATA_BIT_WIDTH-1:gen_b*OUT_DATA_BIT_WIDTH] 
			= out_data_memory_in[(GROUPS-gen_b)*OUT_DATA_BIT_WIDTH-1:(GROUPS-gen_b-1)*OUT_DATA_BIT_WIDTH];
			end
		// for end
	endgenerate
	
	SinglePortRAMSavable  #(
				.path("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/custom_memory_inits/ram_out_bin_dw_%0d.txt"),
				.WIDTH(OUT_DATA_BIT_WIDTH*GROUPS),
				.DEPTH(IN_WIDTH*IN_HEIGHT*IN_CHANNELS*CHANNEL_MUL / GROUPS)
				)
				file_ram_out
				(
				.clka(clk),
				.wea(out_data_memory_write_enable),
				.ena(1'b1),
				.addra(out_data_memory_address),
				// to big endian
				.dina(din),
				.save(delayed_saving),
				.sleep(1'b0)
				);
	
	reg [31:0] out_cntr = 0;
	assign saving = out_cntr == IN_CHANNELS*CHANNEL_MUL*IN_WIDTH*IN_HEIGHT/GROUPS;
	
	DelayLine#(
			  .WIDTH(1), 
			  .DELAY(4)
			  ) 
			  del 
			  (
			  .clk(clk), 
			  .enable(1), 
			  .data_in(saving), 
			  .data_out(delayed_saving)
			  );
	
	always @(posedge clk)
		begin
		if (reset || saving)
			begin
			out_cntr <= 0;
			end
		else if (out_data_memory_write_enable)
			begin
			out_cntr <= out_cntr+1;
			end
		end
	// always end
	
	
endmodule // DepthwiseConv2dUnit_tb

