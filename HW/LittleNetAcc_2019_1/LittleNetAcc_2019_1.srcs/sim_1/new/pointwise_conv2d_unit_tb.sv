`timescale 1ns / 1ps


module PointwiseConv2dUnit_tb ();
	localparam IN_WIDTH = 13;
	localparam IN_HEIGHT = 7;
	localparam IN_CHANNELS = 256;
	localparam OUT_CHANNELS = 15;
	localparam USE_BIAS = 1;
	localparam USE_BN = 0;
	localparam USE_RELU = 0;
	// localparam USE_MAXPOOL = 1;
	// localparam USE_MAXPOOL_CEIL_MODE = 1;
	localparam USE_MAXPOOL = 0;
	localparam USE_MAXPOOL_CEIL_MODE = 0;
	localparam PARALLELISM = 5;
	// localparam PARALLELISM = 1;
	localparam GROUPS = 1;
	// localparam PARALLELISM = 1;
	// localparam GROUPS = 1;
	localparam USE_MAX_FINDER = 1;
	// localparam USE_MAX_FINDER = 0;
	localparam ANCHORS = 3;
	localparam IN_DATA_BIT_WIDTH = 8;
	localparam IN_DATA_INT_WIDTH = 1;
	localparam IN_DATA_SIGN = 1;
	localparam WEIGHT_DATA_BIT_WIDTH = 8;
	localparam WEIGHT_DATA_INT_WIDTH = 3;
	localparam WEIGHT_DATA_SIGN = 1;
	localparam OUT_DATA_BIT_WIDTH = 8;
	localparam OUT_DATA_INT_WIDTH = 3;
	localparam OUT_DATA_SIGN = 1;
	localparam READ_MEMORY_LATENCY = 2;
	localparam WRITE_MEMORY_LATENCY = 2;
	
	localparam OUT_WIDTH = (IN_WIDTH-USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE)/(1+USE_MAXPOOL) 
							+ USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE;
	localparam OUT_HEIGHT = (IN_HEIGHT-USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE)/(1+USE_MAXPOOL) 
							+ USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE;
	localparam ADDITIONAL_WEIGHTS = USE_BIAS + 2*USE_BN;
	localparam INPUT_SIZE = IN_WIDTH*IN_HEIGHT*IN_CHANNELS;
	localparam IN_DATA_ADDRESS_BITS = $clog2(INPUT_SIZE);
	localparam WEIGHTS_SIZE = (IN_CHANNELS+ADDITIONAL_WEIGHTS)*((OUT_CHANNELS-1)/PARALLELISM+1);
	localparam WEIGHTS_ADDRESS_BITS = $clog2(WEIGHTS_SIZE);
	localparam OUT_SIZE = USE_MAX_FINDER ? 7
										:(OUT_WIDTH*OUT_HEIGHT*OUT_CHANNELS)/GROUPS;
	localparam OUT_ADDRESS_BITS = $clog2(OUT_SIZE);
	
	// CLOCK GENERATOR
	
	reg fast_clk = 1'b0;
	reg [2:0] clk_cntr = 0;
	wire clk = clk_cntr[2];
	// wire clk = fast_clk;
	
	initial 
		begin
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
	
	wire [IN_DATA_BIT_WIDTH-1:0] in_data_memory_out;
	wire [IN_DATA_ADDRESS_BITS-1:0] in_data_memory_address;
	wire in_data_memory_read_enable;
	wire [WEIGHT_DATA_BIT_WIDTH*PARALLELISM-1:0] weights_memory_out;
	wire [WEIGHTS_ADDRESS_BITS-1:0] weights_memory_address;
	wire weights_memory_read_enable;
	wire [OUT_DATA_BIT_WIDTH*GROUPS-1:0] out_data_memory_in;
	wire [OUT_ADDRESS_BITS-1:0] out_data_memory_address;
	wire out_data_memory_write_enable;
	
	reg enable = 0;
	reg reset = 1;
	wire finished;
	
	initial
		begin
		forever
			begin
			// turn on reset
			@(posedge clk);
			@(posedge fast_clk);
			reset = 1;
			// turn of reset
			@(posedge clk);
			@(posedge fast_clk);
			reset = 0;
			// make enable
			@(posedge clk);
			@(posedge fast_clk);
			enable = 1;
			
			// wait for finish
			if (!finished)
				wait(finished);
			
			for(int i = 0; i < 30; i = i+1)
				begin
				@(posedge clk);
				end
			// disable module after some time
			@(posedge clk);
			@(posedge fast_clk);
			enable = 0;
			
			// keep disabled for some time
			for(int i = 0; i < 10000; i = i+1)
				begin
				@(posedge clk);
				end
			// for end
			end
		end
	
	PointwiseConv2dUnit#(
						.IN_WIDTH(IN_WIDTH),
						.IN_HEIGHT(IN_HEIGHT),
						.IN_CHANNELS(IN_CHANNELS),
						.OUT_CHANNELS(OUT_CHANNELS),
						.USE_BIAS(USE_BIAS),
						.USE_BN(USE_BN),
						.USE_RELU(USE_RELU),
						.USE_MAXPOOL(USE_MAXPOOL),
						.USE_MAXPOOL_CEIL_MODE(USE_MAXPOOL_CEIL_MODE),
						.PARALLELISM(PARALLELISM),
						.GROUPS(GROUPS),
						.USE_MAX_FINDER(USE_MAX_FINDER),
						.ANCHORS(ANCHORS),
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
						pw_conv2d
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
	
	
	// INPUT DATA
	FileROM #(
			  .path("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/custom_memory_inits/rom_init_data_pw.txt"),
			  .IMG_WIDTH(IN_WIDTH),
			  .IMG_HIGHT(IN_HEIGHT),
			  .IMG_CHANNELS(IN_CHANNELS),
		 	  .WIDTH(IN_DATA_BIT_WIDTH)
			//  .DEPTH(2048)
		 	 )
			 file_rom_point_streamer
			 (
			 .clka(clk),
			 .douta(in_data_memory_out),
			 .addra(in_data_memory_address),
			 .ena(in_data_memory_read_enable),
			 .sleep(1'b0)
			 );
	
	// WEIGHT DATA
	FileROM #(
			  .path("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/custom_memory_inits/rom_init_weights_pw.txt"),
			  .WIDTH(WEIGHT_DATA_BIT_WIDTH*PARALLELISM),
			  .DEPTH((IN_CHANNELS+USE_BN*2+USE_BIAS)*((OUT_CHANNELS-1)/PARALLELISM+1))
		 	 )
			 file_rom_cyclic_streamer
			 (
			 .clka(clk),
			 .douta(weights_memory_out),
			 .addra(weights_memory_address),
			 .ena(weights_memory_read_enable),
			 .sleep(1'b0)
			 );
	
	reg prev_finished = 0;
	reg saving = 0;
	
	always @(posedge clk)
		begin
		if (prev_finished == 0 && finished == 1)
			saving <= 1;
		else
			saving <= 0;
			
		prev_finished <= finished;
		end
	// always end
	
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
				.path("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/custom_memory_inits/ram_out_bin_pw_%0d.txt"),
				.WIDTH(GROUPS*OUT_DATA_BIT_WIDTH),
				.DEPTH(OUT_SIZE)
				)
				file_ram_out
				(
				.clka(clk),
				.wea(out_data_memory_write_enable),
				.ena(1'b1),
				.addra(out_data_memory_address),
				.dina(din),
				.save(saving),
				.sleep(1'b0)
				);
	
	wire [7:0] registers_out [7];
	ShiftRegisters #(
				   .WIDTH(8),
				   .LENGTH(7)
				   )
				   sr
				   (
				    .clk(clk),
					.data_in(out_data_memory_in),
					.step(out_data_memory_write_enable),
					.registers_out(registers_out)
				   );
	
endmodule // PointwiseConv2dUnit_tb

