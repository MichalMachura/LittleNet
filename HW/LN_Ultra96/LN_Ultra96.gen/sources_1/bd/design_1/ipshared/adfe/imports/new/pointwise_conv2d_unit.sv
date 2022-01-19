`timescale 1ns / 1ps


module PointwiseComputationUnit
		#(
		 parameter USE_BIAS = 0,
		 parameter USE_BN = 0,
		 parameter USE_RELU = 0,
		 // input data format 
		 parameter IN_DATA_BIT_WIDTH = 8,
		 parameter IN_DATA_INT_WIDTH = 1,
		 parameter IN_DATA_SIGN = 1,
		 // weight data format
		 parameter WEIGHT_DATA_BIT_WIDTH = 8,
		 parameter WEIGHT_DATA_INT_WIDTH = 1,
		 parameter WEIGHT_DATA_SIGN = 1,
		 // bias data format
		 parameter BIAS_DATA_BIT_WIDTH = 8,
		 parameter BIAS_DATA_INT_WIDTH = 1,
		 parameter BIAS_DATA_SIGN = 1,
		 // output data format
		 parameter INTER_DATA_BIT_WIDTH = 8,
		 parameter INTER_DATA_INT_WIDTH = 1,
		 parameter INTER_DATA_SIGN = 1,
		 // output data format
		 parameter BN_W_DATA_BIT_WIDTH = 8,
		 parameter BN_W_DATA_INT_WIDTH = 1,
		 parameter BN_W_DATA_SIGN = 1,
		 // output data format
		 parameter BN_B_DATA_BIT_WIDTH = 8,
		 parameter BN_B_DATA_INT_WIDTH = 1,
		 parameter BN_B_DATA_SIGN = 1,
		 // output data format
		 parameter OUT_DATA_BIT_WIDTH = 8,
		 parameter OUT_DATA_INT_WIDTH = 1,
		 parameter OUT_DATA_SIGN = 1,
		 
		 localparam IN_DATA_FRAC = IN_DATA_BIT_WIDTH - IN_DATA_INT_WIDTH,
		 localparam WEIGHT_DATA_FRAC = WEIGHT_DATA_BIT_WIDTH - WEIGHT_DATA_INT_WIDTH,
		 localparam BIAS_DATA_FRAC = BIAS_DATA_BIT_WIDTH - BIAS_DATA_INT_WIDTH,
		 localparam INTER_DATA_FRAC = INTER_DATA_BIT_WIDTH - INTER_DATA_INT_WIDTH,
		 localparam BN_W_DATA_FRAC = BN_W_DATA_BIT_WIDTH - BN_W_DATA_INT_WIDTH,
		 localparam BN_B_DATA_FRAC = BN_B_DATA_BIT_WIDTH - BN_B_DATA_INT_WIDTH,
		 localparam OUT_DATA_FRAC = OUT_DATA_BIT_WIDTH - OUT_DATA_INT_WIDTH,
		 
		 localparam DSP_ACC_LATENCY=4,
		 localparam DSP_ADD_LATENCY=4,
		 localparam DSP_MUL_ADD_LATENCY=4,
		 localparam FULL_LATENCY = DSP_ACC_LATENCY
									 +DSP_MUL_ADD_LATENCY*USE_BN
		 )
		 (
		  input clk,
		  input enable,
		  input reset,
		  
		  input [IN_DATA_BIT_WIDTH-1:0] input_data,
		  input [WEIGHT_DATA_BIT_WIDTH-1:0] input_weights [1+USE_BIAS+2*USE_BN],
		  input input_validity,
		  input input_end_of_point,
		  
		  output [OUT_DATA_BIT_WIDTH-1:0] output_data,
		  output output_data_validity
		 );
	
	wire [17:0] aligned_data;
	wire [26:0] aligned_weight;
	wire [47:0] aligned_bias;
	wire processing_state = enable && !reset;
	reg NEW_POINT = 1;
	
	// 
	always @(posedge clk) 
		begin
		if (reset)
			NEW_POINT <= 1'b1;
		else if (enable)
			begin
			if (input_end_of_point)
				NEW_POINT <= 1'b1;
			else if (input_validity)
				NEW_POINT <= 1'b0;
			end	
		end
	
	generate
	if (USE_BIAS)
		begin
		// align bias
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
						bias_alignment
						(
						.in_bias(input_weights[1]),
						.out_bias(aligned_bias)
						);
		end
	else
		begin
		assign aligned_bias =48'd0;
		end
		
	endgenerate
	// ALIGN DATA and WEIGHT
	SignAlignment#(
				.WIDTH(IN_DATA_BIT_WIDTH), 
				.SIGN(IN_DATA_SIGN),
				.DST_WIDTH(18)
				)
				align_data_
				(
				.in_signal(input_data),
				.out_signal(aligned_data)
				);
	SignAlignment#(
				.WIDTH(WEIGHT_DATA_BIT_WIDTH), 
				.SIGN(WEIGHT_DATA_SIGN),
				.DST_WIDTH(27)
				)
				align_weight_
				(
				.in_signal(input_weights[0]),
				.out_signal(aligned_weight)
				);
	
	wire [47:0] P;
	DSP_A_mul_B_ACC accumulator
					(
					.CLK(clk),
					.CE(processing_state),
					.SCLR(reset),
					// select mode
					// 00 - normal acc -> P = P + A * B
					// 01 - by pass -> P = A * B + BIAS
					// 10 - do not add this mul P = P
					// 11 - do not add this mul,
					// but reset acc -> init acc with BIAS -> P = BIAS
					// .SEL({!input_validity, BY_PASS}),
					.SEL({!input_validity, NEW_POINT}),
					.A(aligned_weight),
					.B(aligned_data),
					.C(aligned_bias), // signal from accumulator output
					.P(P)
					);
	
	localparam RESULT_ACC_SIGNED = IN_DATA_SIGN || WEIGHT_DATA_SIGN || BIAS_DATA_SIGN;
	
	
	// quantize / limit range
	// REDUCTION OF BIT WIDTH 
	wire [OUT_DATA_BIT_WIDTH-1:0] reduced_P;
	WidthReduction #(
					.IN_WIDTH(48),
					.IN_FRAC(IN_DATA_FRAC+WEIGHT_DATA_FRAC),
					.IN_SIGNED(RESULT_ACC_SIGNED),
					.DST_WIDTH(INTER_DATA_BIT_WIDTH),
					.DST_INT(INTER_DATA_INT_WIDTH),
					.DST_SIGNED(INTER_DATA_SIGN),
					.RELU(USE_RELU && !USE_BN),
					.CUT_TOP(3)
	 				)
					reduction_after_acc
					(
					.in_signal(P),
					.out_signal(reduced_P)
					);
	
	wire [OUT_DATA_BIT_WIDTH-1:0] final_data;
	
	// BATCH NORMALIZATION
	generate
	if (USE_BN)
		begin
		// delay BN weight and bias
		wire [WEIGHT_DATA_BIT_WIDTH-1:0] delayed_bn_weight;
		wire [WEIGHT_DATA_BIT_WIDTH-1:0] delayed_bn_bias;
		
		DelayLine  #(
					.WIDTH(BN_W_DATA_BIT_WIDTH + BN_B_DATA_BIT_WIDTH),
					.DELAY(DSP_ACC_LATENCY)
					)
					delay_of_bn_weights
					(
					.clk(clk),
					.enable(processing_state),
					.data_in({input_weights[USE_BIAS+1], input_weights[USE_BIAS+2]}),
					.data_out({delayed_bn_weight, delayed_bn_bias})
					);
		
		// ALIGN BN WEIGHT, BIAS AND REDUCED KERNEL 
		wire [26:0] bn_weight_aligned;
		wire [47:0] bn_bias_aligned;
		wire [17:0] reduced_P_sign_aligned;
		SignAlignment#(
					.WIDTH(BN_W_DATA_BIT_WIDTH), 
					.SIGN(BN_W_DATA_SIGN),
					.DST_WIDTH(27)
					)
					align_bn_weight
					(
					.in_signal(delayed_bn_weight),
					.out_signal(bn_weight_aligned)
					);
		SignAlignment#(
					.WIDTH(OUT_DATA_BIT_WIDTH), 
					.SIGN(OUT_DATA_SIGN),
					.DST_WIDTH(18)
					)
					align_reduced_added_bias
					(
					.in_signal(reduced_P),
					.out_signal(reduced_P_sign_aligned)
					);
		PointAlignment #(
				.B_BITS(BN_B_DATA_BIT_WIDTH),
				.B_INT(BN_B_DATA_INT_WIDTH),
				.B_SIGN(BN_B_DATA_SIGN),
				.W_BITS(BN_W_DATA_BIT_WIDTH),
				.W_INT(BN_W_DATA_INT_WIDTH),
				.W_SIGN(BN_W_DATA_SIGN),
				.DATA_BITS(OUT_DATA_BIT_WIDTH),
				.DATA_INT(OUT_DATA_INT_WIDTH),
				.DATA_SIGN(OUT_DATA_SIGN),
				.DST_WIDTH(48)
				)
				align_bn_bias
				(
				.in_bias(delayed_bn_bias),
				.out_bias(bn_bias_aligned)
				);
		wire [47:0] normalized;
		DSP_A_mul_B_add_C dsp_bn
						(
						.CLK(clk),
						.CE(processing_state),
						// SCLR is not needed here, enough is validity delay clear
						.A(bn_weight_aligned),
						.B(reduced_added_bias_aligned),
						.C(bn_bias_aligned),
						.P(normalized)
						);
		
		WidthReduction #(
					.IN_WIDTH(48),
					.IN_FRAC(OUT_DATA_FRAC+WEIGHT_DATA_FRAC),
					// before bn were applied output quantization/reduction
					.IN_SIGNED(OUT_DATA_SIGN || WEIGHT_DATA_SIGN),
					
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
		assign final_data = reduced_P;
		end
	endgenerate
	
	// LAST STAGE
	// delay of validity
	ResettableDelayLine #(
					.WIDTH(1),
					.DELAY(FULL_LATENCY)
					)
					delay_of_validity
					(
					.clk(clk),
					.reset(reset),
					.enable(processing_state),
					.data_in(input_validity && input_end_of_point),
					.data_out(output_data_validity)
					);
	
	// data of pointwise conv
	assign output_data = final_data;
	
endmodule // PointwiseComputationUnit



module PointwiseConv2dUnit
		#(
		 parameter IN_WIDTH = 360,
		 parameter IN_HEIGHT = 180,
		 parameter IN_CHANNELS = 15,
		 parameter OUT_CHANNELS = 16,
		 parameter USE_BIAS = 0,
		 parameter USE_BN = 0,
		 parameter USE_RELU = 0,
		 parameter USE_MAXPOOL = 1,
		 parameter USE_MAXPOOL_CEIL_MODE = 1,
		 parameter PARALLELISM = 1,
		 parameter GROUPS = 1,
		 parameter USE_MAX_FINDER = 0,
		 parameter ANCHORS = 3,
		 // input data format 
		 parameter IN_DATA_BIT_WIDTH = 8,
		 parameter IN_DATA_INT_WIDTH = 1,
		 parameter IN_DATA_SIGN = 1,
		 // weight data format
		 parameter WEIGHT_DATA_BIT_WIDTH = 8,
		 parameter WEIGHT_DATA_INT_WIDTH = 1,
		 parameter WEIGHT_DATA_SIGN = 1,
		 // bias data format
		 parameter BIAS_DATA_BIT_WIDTH = 8,
		 parameter BIAS_DATA_INT_WIDTH = 1,
		 parameter BIAS_DATA_SIGN = 1,
		 // output data format
		 parameter INTER_DATA_BIT_WIDTH = 8,
		 parameter INTER_DATA_INT_WIDTH = 1,
		 parameter INTER_DATA_SIGN = 1,
		 // output data format
		 parameter BN_W_DATA_BIT_WIDTH = 8,
		 parameter BN_W_DATA_INT_WIDTH = 1,
		 parameter BN_W_DATA_SIGN = 1,
		 // output data format
		 parameter BN_B_DATA_BIT_WIDTH = 8,
		 parameter BN_B_DATA_INT_WIDTH = 1,
		 parameter BN_B_DATA_SIGN = 1,
		 // output data format
		 parameter OUT_DATA_BIT_WIDTH = 8,
		 parameter OUT_DATA_INT_WIDTH = 1,
		 parameter OUT_DATA_SIGN = 1,
		 // latency of data read
		 parameter READ_MEMORY_LATENCY = 2,
		 parameter READ_WEIGHT_MEMORY_LATENCY = 2,
		 // latency of data write
		 parameter WRITE_MEMORY_LATENCY = 2,
		 // parameters dependent on user parameters
		 localparam OUT_WIDTH = (IN_WIDTH-USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE)/(1+USE_MAXPOOL) 
		 							+ USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE,
		 localparam OUT_HEIGHT = (IN_HEIGHT-USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE)/(1+USE_MAXPOOL) 
		 							+ USE_MAXPOOL*USE_MAXPOOL_CEIL_MODE,
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
		 localparam IN_DATA_ADDRESS_BITS_32 = 32,
		 // memory weights size = kernel weights + BN_weights + bias
		 // number of weights batches - weights / threads number
		 localparam WEIGHTS_SIZE = (IN_CHANNELS+ADDITIONAL_WEIGHTS)*((OUT_CHANNELS-1)/PARALLELISM+1),
		 localparam WEIGHTS_ADDRESS_BITS = $clog2(WEIGHTS_SIZE),
		 localparam WEIGHTS_ADDRESS_BITS_32 = 32,
		 // output==result memory size
		 localparam OUT_SIZE = (OUT_WIDTH*OUT_HEIGHT*OUT_CHANNELS),
		 localparam OUT_ADDRESS_BITS = USE_MAX_FINDER ? $clog2(7) // for max finder
		 											  : $clog2(OUT_SIZE / GROUPS), // for std pw conv
		 localparam OUT_ADDRESS_BITS_32 = 32
		 )
		 (
		 input clk,
		 // CONTROL SIGNALS
		 input reset,
		 input enable,
		 output finished,
		 
		 // INPUT DATA MEMORY
		 input [IN_DATA_BIT_WIDTH-1:0] in_data_memory_out,
		 output [IN_DATA_ADDRESS_BITS_32-1:0] in_data_memory_address,
		 output in_data_memory_read_enable,
		 // WEIGHTS MEMORY
		 input [WEIGHT_DATA_BIT_WIDTH*PARALLELISM-1:0] weights_memory_out,
		 output [WEIGHTS_ADDRESS_BITS_32-1:0] weights_memory_address,
		 output weights_memory_read_enable,
		// OUTPUT DATA MEMORY
		 output [OUT_DATA_BIT_WIDTH*GROUPS-1:0] out_data_memory_in,
		 output [OUT_ADDRESS_BITS_32-1:0] out_data_memory_address,
		 output out_data_memory_write_enable
		 );
	// reg fully_complete = 1;
	wire fully_complete;
	assign finished = fully_complete;
	reg all_data_in_stream = 1;
	wire processing_state = enable && !reset;
	wire delayed_last_valid_data;
	
	always @(posedge clk)
		begin
		if (reset)
			begin
			// fully_complete <= 0;
			all_data_in_stream <= 0;
			end
		else if (processing_state && delayed_last_valid_data)
			begin
			// set flag of all data in stream
			all_data_in_stream <= 1'b1;
			end
		end
	// always end
	
	// enabling of modules
	wire point_streamer_enable;
	wire cyclic_streamer_enable;
	
	// stream for data
	wire [IN_DATA_BIT_WIDTH-1:0] point_data;
	wire point_data_validity;
	wire end_of_point;
	wire end_of_pass;
	wire [IN_DATA_ADDRESS_BITS_32-1:0] local_in_data_memory_address;
	
	PointStreamerUnit  #(
						.IN_WIDTH(IN_WIDTH),
						.IN_HEIGHT(IN_HEIGHT),
						.IN_CHANNELS(IN_CHANNELS),
						.BIT_WIDTH(IN_DATA_BIT_WIDTH),
						.READ_LATENCY(READ_MEMORY_LATENCY)
						)
						data_point_streamer
						(
						.clk(clk),
						.enable(point_streamer_enable),
						.reset(reset),
						.pixel_value(point_data),
						.validity(point_data_validity),
						.end_point(end_of_point),
						.end_pass(end_of_pass),
						
						.in_data_memory_address(local_in_data_memory_address),
						.in_data_memory_read_enable(in_data_memory_read_enable),
						.in_data_memory_out(in_data_memory_out)
						);
	assign in_data_memory_address = {{(IN_DATA_ADDRESS_BITS_32-IN_DATA_ADDRESS_BITS){1'b0}}, 
									 local_in_data_memory_address};
	
	// stream for weights
	wire [WEIGHT_DATA_BIT_WIDTH*PARALLELISM-1:0] weights [1+ADDITIONAL_WEIGHTS];
	wire weight_validity;
	wire weight_streaming;
	wire next_filter;
	wire end_of_cycle;
	wire end_of_weights;
	wire [WEIGHTS_ADDRESS_BITS_32-1:0] local_weights_memory_address;
	CyclicStreamerUnit #(
						.BIT_WIDTH(WEIGHT_DATA_BIT_WIDTH*PARALLELISM),
						.CYCLE_LENGTH(IN_CHANNELS),
						.PRE_DATA(ADDITIONAL_WEIGHTS),
						.NUM_OF_CYCLES((OUT_CHANNELS-1)/PARALLELISM+1),
						.READ_LATENCY(READ_WEIGHT_MEMORY_LATENCY)
						)
						weight_cyclic_streamer
						(
						.clk(clk),
						.reset(reset),
						.enable(cyclic_streamer_enable),
						
						.next_cycle(next_filter),
						
						.output_stream(weights),
						.validity(weight_validity),
						.streaming(weight_streaming),
						.end_of_cycle(end_of_cycle),
						.end_of_data(end_of_weights),
						
						.data_memory_address(local_weights_memory_address),
						.data_memory_out(weights_memory_out),
						.data_memory_read_enable(weights_memory_read_enable)
						);
	assign weights_memory_address = {{(WEIGHTS_ADDRESS_BITS_32-WEIGHTS_ADDRESS_BITS){1'b0}}, 
									 local_weights_memory_address};
	// enabling control
	wire delayed_data_validity;
	wire [IN_DATA_BIT_WIDTH-1:0] delayed_data;
	wire last_valid_data;
	wire delayed_end_of_point;
	
	// when last data is passed into stream (at the level of weight reading)
	assign last_valid_data = end_of_weights && end_of_pass;
	
	assign point_streamer_enable = processing_state 
									&& (weight_validity == delayed_data_validity 
										|| weight_validity && !delayed_data_validity)
									&& !all_data_in_stream;
	assign cyclic_streamer_enable = processing_state
									&& (weight_validity == delayed_data_validity
										|| delayed_data_validity && !weight_validity)
									&& !all_data_in_stream;
	assign next_filter = end_of_pass && end_of_point && end_of_cycle;
	
	
	// delay of data. it's validity and flag is this data is last, 
	// by latency of cyclic streamer
	ResettableDelayLine #(
					.WIDTH(IN_DATA_BIT_WIDTH+1+1+1),
					.DELAY(READ_WEIGHT_MEMORY_LATENCY+1)
					)
					delay_of_in_data_by_cyclic_streamer_latency
					(
					.clk(clk),
					.reset(reset),
					.enable(point_streamer_enable),
					.data_in({point_data, point_data_validity, last_valid_data, end_of_point}),
					.data_out({delayed_data, delayed_data_validity, delayed_last_valid_data,delayed_end_of_point})
					);
	
	// ready for computing signals of data, weight and their validities
	wire [IN_DATA_BIT_WIDTH-1:0] ready_data = delayed_data;
	wire [WEIGHT_DATA_BIT_WIDTH*PARALLELISM-1:0] ready_weights [1+ADDITIONAL_WEIGHTS] = weights;
	wire ready_validity = !all_data_in_stream && delayed_data_validity && weight_validity;
	wire ready_end_of_point = delayed_end_of_point && ready_validity;
	
	
	wire [OUT_DATA_BIT_WIDTH-1:0] computed_value[PARALLELISM];
	wire computed_value_validity[PARALLELISM];
	genvar gen_i, gen_j;
	generate
		for(gen_i = 0; gen_i < PARALLELISM; gen_i = gen_i+1)
			begin
			wire [WEIGHT_DATA_BIT_WIDTH-1:0] ready_weights_for_th [1+ADDITIONAL_WEIGHTS];
			
			for(gen_j = 0; gen_j < 1+ADDITIONAL_WEIGHTS; gen_j = gen_j+1)
				begin
				assign ready_weights_for_th[gen_j] = ready_weights[gen_j][(PARALLELISM - gen_i)*WEIGHT_DATA_BIT_WIDTH-1:(PARALLELISM - gen_i-1)*WEIGHT_DATA_BIT_WIDTH];
				end
			// for end
			
			PointwiseComputationUnit	#(
										.USE_BIAS(USE_BIAS),
										.USE_BN(USE_BN),
										.USE_RELU(USE_RELU),
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
		 								.OUT_DATA_SIGN(OUT_DATA_SIGN)
										)
										pw_unit
										(
										.clk(clk),
										.enable(processing_state),
										.reset(reset),
										.input_data(ready_data),
										.input_weights(ready_weights_for_th),
										.input_validity(ready_validity),
										.input_end_of_point(ready_end_of_point),
										.output_data(computed_value[gen_i]),
										.output_data_validity(computed_value_validity[gen_i])
										);
			end
		// for end
	endgenerate
	
	wire [OUT_DATA_BIT_WIDTH-1:0] grouper_in_data [PARALLELISM];
	wire grouper_in_data_validity [PARALLELISM];
	
	generate
		if (USE_MAXPOOL)
			begin
			wire delayed_all_data_in_stream;
			ResettableDelayLine	#(
								.WIDTH(1),
								// delay of pw_comp_unit
								.DELAY(4+(USE_BN)*4)
								)
								delay_of_all_in_stream
								(
								.clk(clk),
								.enable(enable),
								.reset(reset),
								.data_in(all_data_in_stream),
								.data_out(delayed_all_data_in_stream)
								);
			
			MaxPool2dUnit 	#(
					.DATA_BIT_WIDTH(OUT_DATA_BIT_WIDTH),
					.DATA_SIGNED(OUT_DATA_SIGN),
					
					.IN_WIDTH(IN_WIDTH),
					.IN_HEIGHT(IN_HEIGHT),
					.PARALLELISM(PARALLELISM),
					.CEIL_MODE(USE_MAXPOOL_CEIL_MODE),
					// because usually ReLU is applied previously
					.COMPARE_TO_ZERO(0)
					)
					mp2d
					(
					.clk(clk),
					.enable(enable),
					.reset(reset),
					.all_data_in_stream(delayed_all_data_in_stream),
					.in_data(computed_value),
					.in_data_validity(computed_value_validity),
					.out_data(grouper_in_data),
					.out_data_validity(grouper_in_data_validity)
					);
			end
		else
			begin
			assign grouper_in_data = computed_value;
			assign grouper_in_data_validity = computed_value_validity;
			end
	endgenerate
	
	// grouping next GROUP-values into wider type
	wire [OUT_DATA_BIT_WIDTH*GROUPS-1:0] mux_in_data [PARALLELISM];
	wire mux_in_data_validity [PARALLELISM];
	genvar gen_k;
	generate
		for(gen_k = 0; gen_k < PARALLELISM; gen_k = gen_k+1)
			begin
			GrouperUnit	#(
						.BIT_WIDTH(OUT_DATA_BIT_WIDTH),
						.GROUPS(GROUPS),
						.ENDIANNESS(0)
						)
						grouping
						(
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.data_in(grouper_in_data[gen_k]),
						.data_in_validity(grouper_in_data_validity[gen_k]),
						.data_out(mux_in_data[gen_k]),
						.data_out_validity(mux_in_data_validity[gen_k])
						);
			end
		// for end
	endgenerate
	
	wire [OUT_ADDRESS_BITS_32-1:0] local_out_data_memory_address;
	generate
		if (!USE_MAX_FINDER)
			begin
			MuxWriterUnit	#(
							.BIT_WIDTH(OUT_DATA_BIT_WIDTH*GROUPS),
							.WIDTH(OUT_WIDTH),
							.HEIGHT(OUT_HEIGHT),
							.CHANNELS(OUT_CHANNELS),
							.GROUPS(GROUPS),
							.PARALLELISM(PARALLELISM),
							.REGISTER_FOR_EACH(1),
							.WRITE_MEMORY_LATENCY(WRITE_MEMORY_LATENCY)
							)
							mwu
							(
							.clk(clk),
							.enable(processing_state),
							.reset(reset),
						
							.in_data(mux_in_data),
							.in_data_validity(mux_in_data_validity),
							
							.out_data_memory_in(out_data_memory_in),
							.out_data_memory_address(local_out_data_memory_address),
							.out_data_memory_write_enable(out_data_memory_write_enable),
							
							.finished(fully_complete)
							);
			end
		else
			begin
			MaxFinderUnit	#(
							.BIT_WIDTH(OUT_DATA_BIT_WIDTH),
							.SIGNED(OUT_DATA_SIGN),
							.WIDTH(OUT_WIDTH),
							.HEIGHT(OUT_HEIGHT),
							.PARALLELISM(PARALLELISM),
							.ANCHORS_NUM(ANCHORS),
							.WRITE_MEMORY_LATENCY(WRITE_MEMORY_LATENCY)
							)
							mfu
							(
							.clk(clk),
							.enable(processing_state),
							.reset(reset),
							
							.data_in(mux_in_data),
							.data_in_validity(mux_in_data_validity),
							
							.out_data_memory_in(out_data_memory_in),
							.out_data_memory_address(local_out_data_memory_address),
							.out_data_memory_write_enable(out_data_memory_write_enable),
							
							.finished(fully_complete)
							);
			end
	endgenerate
	
	assign out_data_memory_address = {{(OUT_ADDRESS_BITS_32-OUT_ADDRESS_BITS){1'b0}},
									  local_out_data_memory_address};
endmodule // PointwiseConv2dUnit

