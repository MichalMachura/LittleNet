`timescale 1ns / 1ps


module PointwiseConv2dUnit_tb ();
	localparam IN_WIDTH = 5;
	localparam IN_HEIGHT = 5;
	localparam IN_CHANNELS = 3;
	localparam OUT_CHANNELS = 15;
	localparam USE_BIAS = 1;
	localparam USE_BN = 1;
	localparam USE_RELU = 1;
	// localparam USE_MAXPOOL = 1;
	// localparam USE_MAXPOOL_CEIL_MODE = 1;
	localparam USE_MAXPOOL = 0;
	localparam USE_MAXPOOL_CEIL_MODE = 0;
	localparam PARALLELISM = 3;
	// localparam PARALLELISM = 1;
	localparam GROUPS = 1;
	// localparam PARALLELISM = 1;
	// localparam GROUPS = 1;
	localparam USE_MAX_FINDER = 0;
	// localparam USE_MAX_FINDER = 0;
	localparam ANCHORS = 3;
	localparam IN_DATA_BIT_WIDTH = 8;
	localparam IN_DATA_INT_WIDTH = 8;
	localparam IN_DATA_SIGN = 1;
	localparam WEIGHT_DATA_BIT_WIDTH = 8;
	localparam WEIGHT_DATA_INT_WIDTH = 8;
	localparam WEIGHT_DATA_SIGN = 1;
	localparam BIAS_DATA_BIT_WIDTH = 8;
	localparam BIAS_DATA_INT_WIDTH = 8;
	localparam BIAS_DATA_SIGN = 1;
	localparam INTER_DATA_BIT_WIDTH = 8;
	localparam INTER_DATA_INT_WIDTH = 8;
	localparam INTER_DATA_SIGN = 1;
	localparam BN_W_DATA_BIT_WIDTH = 8;
	localparam BN_W_DATA_INT_WIDTH = 8;
	localparam BN_W_DATA_SIGN = 1;
	localparam BN_B_DATA_BIT_WIDTH = 8;
	localparam BN_B_DATA_INT_WIDTH = 8;
	localparam BN_B_DATA_SIGN = 1;
	localparam OUT_DATA_BIT_WIDTH = 8;
	localparam OUT_DATA_INT_WIDTH = 8;
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
	wire [32-1:0] in_data_memory_address;
	wire in_data_memory_read_enable;
	wire [WEIGHT_DATA_BIT_WIDTH*PARALLELISM-1:0] weights_memory_out;
	wire [32-1:0] weights_memory_address;
	wire weights_memory_read_enable;
	wire [OUT_DATA_BIT_WIDTH*GROUPS-1:0] out_data_memory_in;
	wire [32-1:0] out_data_memory_address;
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
						.BIAS_DATA_BIT_WIDTH(BIAS_DATA_BIT_WIDTH),
						.BIAS_DATA_INT_WIDTH(BIAS_DATA_INT_WIDTH),
						.BIAS_DATA_SIGN(BIAS_DATA_SIGN),
						.INTER_DATA_BIT_WIDTH(INTER_DATA_BIT_WIDTH),
						.INTER_DATA_INT_WIDTH(INTER_DATA_INT_WIDTH),
						.INTER_DATA_SIGN(INTER_DATA_SIGN),
						.BN_W_DATA_BIT_WIDTH(BN_W_DATA_BIT_WIDTH),
						.BN_W_DATA_INT_WIDTH(BN_W_DATA_INT_WIDTH),
						.BN_W_DATA_SIGN(BN_W_DATA_SIGN),
						.BN_B_DATA_BIT_WIDTH(BN_B_DATA_BIT_WIDTH),
						.BN_B_DATA_INT_WIDTH(BN_B_DATA_INT_WIDTH),
						.BN_B_DATA_SIGN(BN_B_DATA_SIGN),
						.OUT_DATA_BIT_WIDTH(OUT_DATA_BIT_WIDTH),
						.OUT_DATA_INT_WIDTH(OUT_DATA_INT_WIDTH),
						.OUT_DATA_SIGN(OUT_DATA_SIGN),
						.READ_MEMORY_LATENCY(READ_MEMORY_LATENCY),
						.READ_WEIGHT_MEMORY_LATENCY(2),
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
	xpm_memory_sprom #(
      .ADDR_WIDTH_A(32),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .CASCADE_HEIGHT(0),            // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE("sim_memory_input.mem"),     // String
      .MEMORY_INIT_PARAM(""),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("block"),     // String
      .MEMORY_SIZE(8*IN_WIDTH*IN_HEIGHT*IN_CHANNELS),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(8),        // DECIMAL
      .READ_LATENCY_A(2),            // DECIMAL
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(1),              // DECIMAL
      .WAKEUP_TIME("disable_sleep")  // String
   )
   input_ROM_blk (
	  .clka(clk),
	  .douta(in_data_memory_out),
	  .addra(in_data_memory_address),
	  .ena(in_data_memory_read_enable),
	  .sleep(1'b0),
	
      .injectdbiterra(1'b0),
      .injectsbiterra(1'b0),
      .regcea(in_data_memory_read_enable),
      .rsta(1'b0)
   );
   
	// WEIGHT DATA
	xpm_memory_sprom #(
      .ADDR_WIDTH_A(32),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .CASCADE_HEIGHT(0),            // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE("sim_memory_weights.mem"),     // String
      .MEMORY_INIT_PARAM(""),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("block"),     // String
      .MEMORY_SIZE((IN_CHANNELS+USE_BN*2+USE_BIAS)*((OUT_CHANNELS-1)/PARALLELISM+1)*WEIGHT_DATA_BIT_WIDTH*PARALLELISM),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(WEIGHT_DATA_BIT_WIDTH*PARALLELISM),        // DECIMAL
      .READ_LATENCY_A(2),            // DECIMAL
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(1),              // DECIMAL
      .WAKEUP_TIME("disable_sleep")  // String
   )
   weight_ROM_blk (
	  .clka(clk),
	  .douta(weights_memory_out),
	  .addra(weights_memory_address),
	  .ena(weights_memory_read_enable),
	  .sleep(1'b0),
	
      .injectdbiterra(1'b0),
      .injectsbiterra(1'b0),
      .regcea(weights_memory_read_enable),
      .rsta(1'b0)
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
				.path("/media/michal/HDD_Linux_2/LittleNet/HW/LittleNetAcc/ram_out_bin_pw_%0d.txt"),
				.WIDTH(GROUPS*OUT_DATA_BIT_WIDTH),
				.DEPTH(OUT_SIZE)
				// .DEPTH(2**32)
				// .DEPTH(4294967296)
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

