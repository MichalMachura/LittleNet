`timescale 1ns / 1ps


module DepthwiseConv2dUnit
		#(
		 parameter IN_WIDTH = 360,
		 parameter IN_HEIGHT = 180,
		 parameter IN_CHANNELS = 3,
		 parameter PADDING_W = 1,
		 parameter PADDING_H = 1,
		 parameter CHANNEL_MUL = 1,
		 parameter USE_BIAS = 0,
		 parameter USE_BN = 0,
		 parameter USE_RELU = 0,
		 parameter GROUPS = 1,
		 // input data format 
		 parameter IN_DATA_BIT_WIDTH = 8,
		 parameter IN_DATA_INT_WIDTH = 1,
		 parameter IN_DATA_SIGN=1,
		 // weight data format
		 parameter WEIGHT_DATA_BIT_WIDTH = 8,
		 parameter WEIGHT_DATA_INT_WIDTH = 1,
		 parameter WEIGHT_DATA_SIGN=1,
		 // bias data format
		 parameter BIAS_DATA_BIT_WIDTH = 8,
		 parameter BIAS_DATA_INT_WIDTH = 1,
		 parameter BIAS_DATA_SIGN=1,
		 // intermediate data format
		 parameter INTER_DATA_BIT_WIDTH = 8,
		 parameter INTER_DATA_INT_WIDTH = 1,
		 parameter INTER_DATA_SIGN=1,
		 // batch norm weight data format
		 parameter BN_W_DATA_BIT_WIDTH = 8,
		 parameter BN_W_DATA_INT_WIDTH = 1,
		 parameter BN_W_DATA_SIGN=1,
		 // batch norm bias data format
		 parameter BN_B_DATA_BIT_WIDTH = 8,
		 parameter BN_B_DATA_INT_WIDTH = 1,
		 parameter BN_B_DATA_SIGN=1,
		 // output data format
		 parameter OUT_DATA_BIT_WIDTH = 8,
		 parameter OUT_DATA_INT_WIDTH = 1,
		 parameter OUT_DATA_SIGN=1,
		 // latency of data read
		 parameter READ_MEMORY_LATENCY = 2,
		 parameter READ_WEIGHT_MEMORY_LATENCY = 2,
		 // latency of data write
		 parameter WRITE_MEMORY_LATENCY = 2,
		 // constant value
		 localparam K_SIZE = 3,
		 // parameters dependent on user parameters
		 localparam PADDED_WIDTH = IN_WIDTH + 2*PADDING_W,
		 localparam PADDED_HEIGHT = IN_HEIGHT + 2*PADDING_H,
		 localparam OUT_WIDTH = PADDED_WIDTH - 2*(K_SIZE/2),
		 localparam OUT_HEIGHT = PADDED_HEIGHT- 2*(K_SIZE/2),
		 localparam OUT_CHANNELS = IN_CHANNELS*CHANNEL_MUL,
		 // fractional parts sizes
		 localparam IN_DATA_FRAC = IN_DATA_BIT_WIDTH - IN_DATA_INT_WIDTH,
		 localparam WEIGHT_DATA_FRAC = WEIGHT_DATA_BIT_WIDTH - WEIGHT_DATA_INT_WIDTH,
		 localparam BIAS_DATA_FRAC = BIAS_DATA_BIT_WIDTH - BIAS_DATA_INT_WIDTH,
		 localparam INTER_DATA_FRAC = INTER_DATA_BIT_WIDTH - INTER_DATA_INT_WIDTH,
		 localparam BN_W_DATA_FRAC = BN_W_DATA_BIT_WIDTH - BN_W_DATA_INT_WIDTH,
		 localparam BN_B_DATA_FRAC = BN_B_DATA_BIT_WIDTH - BN_B_DATA_INT_WIDTH,
		 localparam OUT_DATA_FRAC = OUT_DATA_BIT_WIDTH - OUT_DATA_INT_WIDTH,
		 // number of additional weights to load
		 // like batch norm or just bias
		 localparam ADDITIONAL_WEIGHTS = USE_BIAS + 2*USE_BN,
		 // addresses sizes
		 // input address size
		 localparam INPUT_SIZE = IN_WIDTH*IN_HEIGHT*IN_CHANNELS,
		 localparam IN_DATA_ADDRESS_BITS = $clog2(INPUT_SIZE),
		 // memory weights size
		 localparam WEIGHTS_SIZE = (K_SIZE*K_SIZE+ADDITIONAL_WEIGHTS)*OUT_CHANNELS,
		 localparam WEIGHTS_ADDRESS_BITS = $clog2(WEIGHTS_SIZE),
		 // local weights registers size 
		 localparam LOCAL_WEIGHTS_SIZE = K_SIZE*K_SIZE+ADDITIONAL_WEIGHTS,
		 localparam LOCAL_WEIGHTS_CNTR_BITS = $clog2(LOCAL_WEIGHTS_SIZE),
		 // channels counter bits
		 localparam CHANNELS_CNTR_BITS = $clog2(OUT_CHANNELS+1),
		 // pixels in channel counter
		 localparam MAP_SIZE = OUT_WIDTH*OUT_HEIGHT,
		 localparam PIXELS_CNTR = $clog2(MAP_SIZE),
		 // output==result memory size
		 localparam OUT_SIZE = OUT_WIDTH*OUT_HEIGHT*OUT_CHANNELS,
		 localparam OUT_ADDRESS_BITS = $clog2(OUT_SIZE/GROUPS),
		 // LATENCY OF OPERATIONS
		 localparam MUL_LATENCY = 4,
		 localparam ADD_LATENCY = 2
		 )
		 (
		 input clk,
		 // CONTROL SIGNALS
		 input reset,
		 input enable,
		 output finished,
		 
		 // INPUT DATA MEMORY
		 input [IN_DATA_BIT_WIDTH-1:0] in_data_memory_out,
		 output [IN_DATA_ADDRESS_BITS-1:0] in_data_memory_address,
		 output in_data_memory_read_enable,
		//  output in_data_memory_read_clk,
		 // WEIGHTS MEMORY
		 input [WEIGHT_DATA_BIT_WIDTH-1:0] weights_memory_out,
		 output [WEIGHTS_ADDRESS_BITS-1:0] weights_memory_address,
		 output weights_memory_read_enable,
		//  output weight_memory_write_clk
		// OUTPUT DATA MEMORY
		 output [OUT_DATA_BIT_WIDTH*GROUPS-1:0] out_data_memory_in,
		 output [OUT_ADDRESS_BITS-1:0] out_data_memory_address,
		 output out_data_memory_write_enable
		//  output out_data_memory_write_clk
		 );
	// computation tree latencies
	localparam CASCADE_LATENCY = 4 + 8; // same with bias or not
	localparam CASCADE_BN_LATENCY = CASCADE_LATENCY + 4*USE_BN;
	// localparam FULL_LATENCY = BN_LATENCY;
	localparam FULL_LATENCY = CASCADE_BN_LATENCY;
	// some signals delay
	localparam BN_DELAY = CASCADE_LATENCY;
	localparam KERNEL_VALIDITY_DELAY = FULL_LATENCY;
	//
	localparam IS_FINISHED_DELAY = WRITE_MEMORY_LATENCY;
	
	reg fully_complete = 1;
	
	// input kernel validity from sliding window unit
	wire kernel_validity;
	// validity of computation
	wire output_validity;
	// counting of processed pixels in single map
	reg [PIXELS_CNTR-1:0] counter_pixel = 0;
	// counting whole pixels == output address
	// reg [OUT_ADDRESS_BITS-1:0] counter_output_address = 0;
	
	// weights loading signals
	wire weights_loading_state;
	wire next_weights_batch;
	// trigger for weight loading start
	wire last_pixel_achieved;
	
	// signals of last pixel and starting of weights loading
	assign last_pixel_achieved = counter_pixel == MAP_SIZE-1;
	assign next_weights_batch = last_pixel_achieved;
	
	// COMPUTATION STATE AND STATE
	// finished if all out pixels are computed == they were pass through summary tree
	wire is_finished;
	
	// processing state when weight are loaded and module is enabled
	wire processing_state, partially_enabled;
	// assign partially_enabled = enable && !reset && !is_finished;
	assign partially_enabled = enable && !reset && !fully_complete;
	assign processing_state = partially_enabled && !weights_loading_state;

	// is finished must be delayed, because output must be written to memory
	wire delayed_is_finished;
	
	DelayLine #(
			   .WIDTH(1),
			   .DELAY(IS_FINISHED_DELAY)
			   ) delay_line_of_is_finished 
			   (
			   .clk(clk),
			   .enable(enable),
			   .data_in(is_finished),
			   .data_out(delayed_is_finished)
			   );
			   
	// fully_complete is info for 
	// main control unit that this module finish all computations
	assign finished = fully_complete;

	// SEQUENTIAL PART	
	// reset, in channel pixel iterator, weight loading and address of result
	always @(posedge clk)
		begin
		if (reset)
			begin
			counter_pixel <= 0;;
			// counter_output_address <= 0;
			fully_complete <= 0;
			end
		// make step only when module enabled and all data are not fully processed
		else if(enable)
			begin
			if (!is_finished && !weights_loading_state)
				begin
				// valid kernels counting
				if (kernel_validity)
					begin
					// pixel counter
					if (counter_pixel == MAP_SIZE-1)
						counter_pixel <= 0;
					else
						counter_pixel <= counter_pixel+1;
					end
				end
			// processing is fully complete, when last date is processed 
			// and stored in out memory
			if (delayed_is_finished && is_finished)
				fully_complete <= 1;
			end
		end
	// always end
	
	// LOAD WEIGHTS
	// cached weights
	wire [WEIGHT_DATA_BIT_WIDTH-1:0] weights [LOCAL_WEIGHTS_SIZE];
	wire loading_weight_module_enable;
	assign loading_weight_module_enable = partially_enabled && !is_finished;
	
	LoadingWeightsUnit #(
						.BIT_WIDTH(WEIGHT_DATA_BIT_WIDTH),
						.BATCH_SIZE(LOCAL_WEIGHTS_SIZE),
						.MEMORY_WEIGHTS_SIZE(WEIGHTS_SIZE),
						.ADDRESS_BITS(WEIGHTS_ADDRESS_BITS),
						.READ_MEMORY_LATENCY(READ_WEIGHT_MEMORY_LATENCY)
						)
						LWU
						(
						.clk(clk),
						.reset(reset),
						.next_batch(next_weights_batch),
						.weights_memory_out(weights_memory_out),
						.weights_memory_address(weights_memory_address),
						.weights_memory_read_enable(weights_memory_read_enable),
						.enable(loading_weight_module_enable),
						.weights(weights),
						.is_weights_loading(weights_loading_state)
						);
	
	// SLIDING WINDOW 
	wire [IN_DATA_BIT_WIDTH-1:0] kernel [K_SIZE*K_SIZE];
	
	SlidingWindowUnit#(
					  .IN_WIDTH(IN_WIDTH), 
					  .IN_HEIGHT(IN_HEIGHT), 
					  .IN_CHANNELS(IN_CHANNELS), 
					  .NUM_OF_PASS(CHANNEL_MUL), 
					  .PADDING_H(PADDING_H),
					  .PADDING_W(PADDING_W),
					  .DATA_BIT_WIDTH(IN_DATA_BIT_WIDTH),
					  .MEMORY_LATENCY(READ_MEMORY_LATENCY)
					  )
					  SW_unit
					  (
					  .clk(clk),
					  .enable(processing_state),
					  .reset(reset),
					  .memory_out(in_data_memory_out),
					  .memory_address(in_data_memory_address),
					  .memory_read_enable(in_data_memory_read_enable),
					  .kernel(kernel),
					  .kernel_validity(kernel_validity)
					  );
	
	// CASCADE of SUM-MUL on DSP48
	
	localparam RESULT_SIGNED = WEIGHT_DATA_SIGN || IN_DATA_SIGN || USE_BIAS && BIAS_DATA_SIGN;
	
	// bunch of signals for cascade od DSP
	wire [47:0] PCOUT [K_SIZE*K_SIZE-1]; // last is not connected to next dsp
	wire [47:0] P_last;
	wire [IN_DATA_BIT_WIDTH-1:0] delayed_kernel[K_SIZE*K_SIZE];
	wire [WEIGHT_DATA_BIT_WIDTH-1:0] delayed_weight[K_SIZE*K_SIZE];
	wire [17:0] kernel_aligned[K_SIZE*K_SIZE];
	wire [26:0] weight_aligned[K_SIZE*K_SIZE];
	
	genvar k;
	generate
		for(k = 0; k < K_SIZE*K_SIZE; k = k+1)
			begin
			// DELAY KERNELS AND WEIGHTS
			DelayLine#(
					  .WIDTH(IN_DATA_BIT_WIDTH + WEIGHT_DATA_BIT_WIDTH),
					  .DELAY(k)
					  )
					  delay_of_kernel_and_weight
					  (
					  .clk(clk),
					  .enable(processing_state),
					  .data_in({kernel[k], weights[k]}),
					  .data_out({delayed_kernel[k], delayed_weight[k]})
					  );
			
			// ALIGN KERNEL DATA and WEIGHTS
			SignAlignment#(
						.WIDTH(IN_DATA_BIT_WIDTH), 
						.SIGN(IN_DATA_SIGN),
						.DST_WIDTH(18)
						)
						align_kernel_
						(
						.in_signal(delayed_kernel[k]),
						.out_signal(kernel_aligned[k])
						);
			SignAlignment#(
						.WIDTH(WEIGHT_DATA_BIT_WIDTH), 
						.SIGN(WEIGHT_DATA_SIGN),
						.DST_WIDTH(27)
						)
						align_weight_
						(
						.in_signal(delayed_weight[k]),
						.out_signal(weight_aligned[k])
						);
						
			if (k == 0 && USE_BIAS)
				begin
				wire [47:0] bias_aligned;
				PointAlignment #(
						.B_BITS(BIAS_DATA_BIT_WIDTH),
						.B_INT(BIAS_DATA_INT_WIDTH),
						.B_SIGN(BIAS_DATA_SIGN),
						.W_BITS(WEIGHT_DATA_BIT_WIDTH),
						.W_INT(WEIGHT_DATA_INT_WIDTH),
						.W_SIGN(WEIGHT_DATA_SIGN),
						.DATA_BITS(IN_DATA_BIT_WIDTH),
						.DATA_INT(IN_DATA_INT_WIDTH),
						.DATA_SIGN(IN_DATA_SIGN),
						.DST_WIDTH(48)
						)
						align_bias
						(
						// bias is weight after last kernel weight
						.in_bias(weights[K_SIZE*K_SIZE]),
						.out_bias(bias_aligned)
						);
				
				DSP_A_mul_B_add_C_PCOUT dsp_first_bias 
										(
										.CLK(clk),
										.CE(processing_state),
										.A(weight_aligned[k]),
										.B(kernel_aligned[k]),
										.C(bias_aligned),
										// .P(), // not used
										// .PCIN(PCOUT[k-1]) // not present
										.PCOUT(PCOUT[k])
										);
				end
			else if (k == 0 && !USE_BIAS)
				begin
				DSP_A_mul_B_PCOUT dsp_first_no_bias
										(
										.CLK(clk),
										.CE(processing_state),
										.A(weight_aligned[k]),
										.B(kernel_aligned[k]),
										// .P(), // not used
										// .PCIN(PCOUT[k-1]) // not present
										.PCOUT(PCOUT[k])
										);
				end
			// for last kernel mul-added
			else if (k == K_SIZE*K_SIZE-1)
				begin
				DSP_A_mul_B_add_PCIN dsp_last 
										(
										.CLK(clk),
										.CE(processing_state),
										.A(weight_aligned[k]),
										.B(kernel_aligned[k]),
										.PCIN(PCOUT[k-1]),
										// .PCOUT(), // not present
										.P(P_last)
										);
				end
			// for intermediate kernel mul-adder
			else
				begin
				DSP_A_mul_B_add_PCIN_PCOUT dsp_intermediate
										(
										.CLK(clk),
										.CE(processing_state),
										.A(weight_aligned[k]),
										.B(kernel_aligned[k]),
										.PCIN(PCOUT[k-1]),
										// .P(), not used
										.PCOUT(PCOUT[k])
										);
				end
			end
	endgenerate
	
	// REDUCTION OF BIT WIDTH 
	wire [OUT_DATA_BIT_WIDTH-1:0] reduced_kernel;
	WidthReduction #(
					.IN_WIDTH(48),
					.IN_FRAC(IN_DATA_FRAC+WEIGHT_DATA_FRAC),
					.IN_SIGNED(RESULT_SIGNED),
					.DST_WIDTH(INTER_DATA_BIT_WIDTH),
					.DST_INT(INTER_DATA_INT_WIDTH),
					.DST_SIGNED(INTER_DATA_SIGN),
					.RELU(USE_RELU && !USE_BN),
					.CUT_TOP(3)
	 				)
					reduction_after_kernel
					(
					.in_signal(P_last),
					.out_signal(reduced_kernel)
					);
	// signal of reduced kernel or normalized reduced kernel
	wire [INTER_DATA_BIT_WIDTH-1:0] final_data;
	
	// BATCH NORMALIZATION
	generate
	if (USE_BN)
		begin
		// delay BN weight and bias
		wire [WEIGHT_DATA_BIT_WIDTH-1:0] bn_weight;
		wire [WEIGHT_DATA_BIT_WIDTH-1:0] bn_bias;
		
		DelayLine  #(
					.WIDTH(BN_W_DATA_BIT_WIDTH+BN_B_DATA_BIT_WIDTH),
					.DELAY(CASCADE_LATENCY)
					)
					delay_of_bn_weights
					(
					.clk(clk),
					.enable(processing_state),
					.data_in({weights[K_SIZE*K_SIZE-1+USE_BIAS+1],weights[K_SIZE*K_SIZE-1+USE_BIAS+2]}),
					.data_out({bn_weight, bn_bias})
					);
		
		// ALIGN BN WEIGHT, BIAS AND REDUCED KERNEL 
		wire [26:0] bn_weight_aligned;
		wire [47:0] bn_bias_aligned;
		wire [17:0] reduced_kernel_aligned;
		SignAlignment#(
					.WIDTH(BN_W_DATA_BIT_WIDTH), 
					.SIGN(BN_W_DATA_SIGN),
					.DST_WIDTH(27)
					)
					align_bn_weight
					(
					.in_signal(bn_weight),
					.out_signal(bn_weight_aligned)
					);
		SignAlignment#(
					.WIDTH(INTER_DATA_BIT_WIDTH), 
					.SIGN(INTER_DATA_SIGN),
					.DST_WIDTH(18)
					)
					align_reduced_kernel
					(
					.in_signal(reduced_kernel),
					.out_signal(reduced_kernel_aligned)
					);
		PointAlignment #(
				
				.B_BITS(BN_B_DATA_BIT_WIDTH),
				.B_INT(BN_B_DATA_INT_WIDTH),
				.B_SIGN(BN_B_DATA_SIGN),
				
				.W_BITS(BN_W_DATA_BIT_WIDTH),
				.W_INT(BN_W_DATA_INT_WIDTH),
				.W_SIGN(BN_W_DATA_SIGN),
				
				.DATA_BITS(INTER_DATA_BIT_WIDTH),
				.DATA_INT(INTER_DATA_INT_WIDTH),
				.DATA_SIGN(INTER_DATA_SIGN),
				
				.DST_WIDTH(48)
				)
				align_bn_bias
				(
				// bias is weight after last kernel weight
				.in_bias(bn_bias),
				.out_bias(bn_bias_aligned)
				);
		wire [47:0] normalized;
		DSP_A_mul_B_add_C dsp_bn
						(
						.CLK(clk),
						.CE(processing_state),
						.A(bn_weight_aligned),
						.B(reduced_kernel_aligned),
						.C(bn_bias_aligned),
						.P(normalized)
						);
		
		WidthReduction #(
					.IN_WIDTH(48),
					.IN_FRAC(INTER_DATA_FRAC+BN_W_DATA_FRAC),
					// after bn were applied output quantization/reduction
					.IN_SIGNED(INTER_DATA_SIGN || BN_W_DATA_SIGN || BN_B_DATA_SIGNED),
					
					.DST_WIDTH(OUT_DATA_BIT_WIDTH),
					.DST_INT(OUT_DATA_INT_WIDTH),
					.DST_SIGNED(OUT_DATA_SIGN),
					
					.RELU(USE_RELU),
					.CUT_TOP(3)
	 				)
					reduction_after_normalization
					(
					.in_signal(normalized),
					.out_signal(final_data)
					);
		end
	else
		begin
		// no change
		assign final_data = reduced_kernel;
		end
	endgenerate
	
	// delay validity by processing latency
	DelayLine #(
			   .WIDTH(1),
			   .DELAY(FULL_LATENCY)
			   ) 
			   delay_line_of_validity 
			   (
			   .clk(clk),
			   .enable(processing_state),
			   .data_in(kernel_validity),
			   .data_out(output_validity)
			   );
	
	wire [OUT_DATA_BIT_WIDTH*GROUPS-1:0] grouped_data[1];
	wire grouped_data_validity[1];
	
	GrouperUnit	#(
				.BIT_WIDTH(OUT_DATA_BIT_WIDTH),
				.GROUPS(GROUPS),
				.ENDIANNESS(0)
				)
				grouping
				(
				.clk(clk),
				.reset(reset),
				.enable(processing_state),
				.data_in(final_data),
				.data_in_validity(output_validity),
				.data_out(grouped_data[0]),
				.data_out_validity(grouped_data_validity[0])
				);
	
	MuxWriterUnit
		#(
		.BIT_WIDTH(OUT_DATA_BIT_WIDTH*GROUPS),
		.WIDTH(OUT_WIDTH),
		.HEIGHT(OUT_HEIGHT),
		.CHANNELS(OUT_CHANNELS),
		.GROUPS(GROUPS),
		.PARALLELISM(1),
		.REGISTER_FOR_EACH(1),
		.WRITE_MEMORY_LATENCY(WRITE_MEMORY_LATENCY)
		)
		mwu
		(
		.clk(clk),
		.enable(processing_state),
		.reset(reset),
	
		.in_data(grouped_data),
		.in_data_validity(grouped_data_validity),
		
		.out_data_memory_in(out_data_memory_in),
		.out_data_memory_address(out_data_memory_address),
		.out_data_memory_write_enable(out_data_memory_write_enable),
		
		.finished(is_finished)
		);
	
	// assign out_data_memory_in = final_data;
	// assign out_data_memory_address = counter_output_address;
	// assign out_data_memory_write_enable = output_validity && processing_state;
	
	
endmodule // DepthwiseConv2d_3x3


