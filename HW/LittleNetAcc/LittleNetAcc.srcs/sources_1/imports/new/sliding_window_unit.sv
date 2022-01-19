`timescale 1ns / 1ps


module SlidingWindowUnit
		#(
		 // input shape
		 parameter IN_WIDTH = 360,
		 parameter IN_HEIGHT = 180,
		 parameter IN_CHANNELS = 3,
		 // !!!!
		 // kernel_validity is false, while redundant pass is achieved,
		 // BUT ONLY FIRST REDUNDANT PASS
		 // NEXT PASS ARE CONSIDERED AS VALID,
		 // it's caused by optimized use of operator != instead of <
		 parameter NUM_OF_PASS = 1, 
		 // !!!
		 // padding size
		 parameter PADDING_W = 1,
		 parameter PADDING_H = 1,
		 parameter DATA_BIT_WIDTH = 8,
		 parameter MEMORY_LATENCY = 2,
		 // parameters depends on user parameters
		 // padded shape
		 localparam PADDED_WIDTH = IN_WIDTH + 2*PADDING_W,
		 localparam PADDED_HEIGHT = IN_HEIGHT + 2*PADDING_H,
		 localparam PADDED_SIZE= PADDED_HEIGHT*PADDED_WIDTH,
		 // number of elements in input and output features maps
		 localparam INPUT_SIZE = IN_WIDTH*IN_HEIGHT*IN_CHANNELS,
		 // minimum number of bits per addresses
		 localparam IN_ADDRESS_SIZE = $clog2(INPUT_SIZE),
		 // minimum number of bits per counters
		 localparam ROW_CNTR_BITS = $clog2(PADDED_HEIGHT),
		 localparam COL_CNTR_BITS = $clog2(PADDED_WIDTH),
		 localparam CHANNEL_CNTR_BITS = $clog2(IN_CHANNELS),
		 localparam PASS_CNTR_BITS = $clog2(NUM_OF_PASS+1),
		 localparam INPUT_IDX_CNTR_BITS = $clog2(INPUT_SIZE),
		 // constant
		 localparam K_SIZE = 3
		 )
		 (
		 input clk,
		 input enable,
		 input reset,
		 
		 input [DATA_BIT_WIDTH-1:0] memory_out,
		 output [IN_ADDRESS_SIZE-1:0] memory_address,
		 output memory_read_enable,
		 
		 // pixel surroundings
		 output [DATA_BIT_WIDTH-1:0] kernel [K_SIZE*K_SIZE],
		 // validity of kernel 
		 output kernel_validity
		 );
		 
	localparam END_COUNTER_COL = PADDED_WIDTH-1;
	localparam END_COUNTER_ROW = PADDED_HEIGHT-1;
	localparam END_COUNTER_CHANNEL = IN_CHANNELS-1;
	localparam END_COUNTER_INPUT_IDX = INPUT_SIZE-1;
	// length of delay without two pixels represented by registers
	localparam DELAY_LINE_LENGTH = PADDED_WIDTH-K_SIZE;
	// counters
	reg [COL_CNTR_BITS-1:0] counter_col = 0;
	reg [ROW_CNTR_BITS-1:0] counter_row = 0;
	reg [CHANNEL_CNTR_BITS-1:0] counter_channel = 0;
	reg [PASS_CNTR_BITS-1:0] counter_pass = 0;
	reg [INPUT_IDX_CNTR_BITS-1:0] input_idx = 0;
	
	// registers and wires for kernel pixels
	// first row
	wire [DATA_BIT_WIDTH-1:0] to_kernel_0;
	reg [DATA_BIT_WIDTH-1:0] kernel_0 = 0;
	reg [DATA_BIT_WIDTH-1:0] kernel_1 = 0;
	reg [DATA_BIT_WIDTH-1:0] kernel_2 = 0;
	//second row
	wire [DATA_BIT_WIDTH-1:0] to_kernel_3;
	reg [DATA_BIT_WIDTH-1:0] kernel_3 = 0;
	reg [DATA_BIT_WIDTH-1:0] kernel_4 = 0;
	reg [DATA_BIT_WIDTH-1:0] kernel_5 = 0;
	// third row
	wire [DATA_BIT_WIDTH-1:0] to_kernel_6;
	reg [DATA_BIT_WIDTH-1:0] kernel_6 = 0;
	reg [DATA_BIT_WIDTH-1:0] kernel_7 = 0;
	reg [DATA_BIT_WIDTH-1:0] kernel_8 = 0;
	
	// validity of input pixel depends on padding
	wire input_is_valid;
	generate	
		// both paddings
		if (PADDING_H > 0 && PADDING_W > 0)
			assign input_is_valid = counter_col >= PADDING_W && counter_col < PADDED_WIDTH-PADDING_W 
								&& counter_row >= PADDING_H && counter_row < PADDED_HEIGHT-PADDING_H;
		// only vertical padding
		else if (PADDING_H > 0 && PADDING_W == 0)
			assign input_is_valid = counter_col >= PADDING_W && counter_col < PADDED_WIDTH-PADDING_W;
		// only horizontal padding
		else if (PADDING_H > 0 && PADDING_W == 0)
			assign input_is_valid = counter_row >= PADDING_H && counter_row < PADDED_HEIGHT-PADDING_H;
		// no padding
		else
			// no padding => all pixels are valid
			assign input_is_valid = 1;
	endgenerate
	
	// enable clock when module is enabled
	// wire clk_en;
	// assign clk_en = clk & enable & !reset; 
		
	// delay validity pixel for given address by memory latency
	wire delayed_input_is_valid;
	DelayLine #(.WIDTH(1), .DELAY(MEMORY_LATENCY)) 
				delay_validity_by_memory_latency (.clk(clk),
												  .enable(enable),
												  .data_in(input_is_valid), 
												  .data_out(delayed_input_is_valid));
	// apply padding if read data from address was invalid
	assign to_kernel_0 = delayed_input_is_valid ? memory_out 
											    : 0;
	
	// reset should be not at the same time as enabled
	assign memory_read_enable = enable && !reset;
	// address is idx of valid data
	assign memory_address = input_idx;
	
	// reset, counters and kernels update
	always @(posedge clk)
		begin
		if (reset)
			begin
				counter_col <= 0;
				counter_row <= 0;
				counter_channel <= 0;
				counter_pass <= 0;
				input_idx <= 0;
			end
		else if (enable)
			begin
			// column iteration
			if (counter_col == END_COUNTER_COL)
				begin
				counter_col <= 0;
				// row iteration
				// do not pad bottom, 
				// it will be achieved by
				//  padding top of next channel
				if (counter_row == END_COUNTER_ROW-1) 
					// && counter_channel != END_COUNTER_CHANNEL 
					// || counter_row == END_COUNTER_ROW && counter_channel == END_COUNTER_CHANNEL)
					begin
					counter_row <= 0;
					// channel iteration
					if (counter_channel == END_COUNTER_CHANNEL)
						begin
						counter_channel <= 0;
						counter_pass <= counter_pass + 1;
						end
					else
						counter_channel <= counter_channel +1;
					end
				else
					counter_row <= counter_row +1;
				end
			else
				counter_col <= counter_col +1;
			
			// input data iterator
			if (input_idx == END_COUNTER_INPUT_IDX)
				// here also input data idx reset is needed 
				input_idx <= 0;
			else if (input_is_valid)
				// incremented only when padding is not achieved
				input_idx <= input_idx + 1;
			else
				// the same
				input_idx <= input_idx;
			
			// move pixels of kernel to next one
			// first row
			kernel_0 <= to_kernel_0;
			kernel_1 <= kernel_0;
			kernel_2 <= kernel_1;
			// second row
			kernel_3 <= to_kernel_3;
			kernel_4 <= kernel_3;
			kernel_5 <= kernel_4;
			// third row
			kernel_6 <= to_kernel_6;
			kernel_7 <= kernel_6;
			kernel_8 <= kernel_7;
			end
		end
	// always end
	
	// delay lines for right side pixels
	DelayLine #(.WIDTH(DATA_BIT_WIDTH+DATA_BIT_WIDTH), 
			   .DELAY(DELAY_LINE_LENGTH)) 
			   line_from_kernel2(
			                     .clk(clk), 
			                     .enable(enable), 
			                     .data_in({kernel_2,kernel_5}), 
			                     .data_out({to_kernel_3,to_kernel_6}));
	
	// validity of whole kernel
	wire early_kernel_is_valid;
	 								// if left and right borders are not achieved
	assign early_kernel_is_valid = counter_col != 0 && counter_col != PADDED_WIDTH-1 
									// if top and bottom border are not achieved
								   && counter_row != 0 && counter_row != PADDED_HEIGHT-1
									// if input map is passed given times, next passed kernels are invalid.
									// Because it would be old map, while will be expected new map, so these pixels 
									// must be considered as invalid.
								   && counter_pass != NUM_OF_PASS;
	
	// delay kernel validity
	DelayLine #(.WIDTH(1), 
			   .DELAY(PADDED_WIDTH+MEMORY_LATENCY+K_SIZE/2+1)) // +move in second row
			 kernel_validity_delay(.clk(clk),
								   .enable(enable),
			 					   .data_in(early_kernel_is_valid),
								   .data_out(kernel_validity));
		
	// connect kernel output with local kernel
	// with notation left to right, top to bottom
	// => inverse order
	assign kernel[0] = kernel_8;
	assign kernel[1] = kernel_7;
	assign kernel[2] = kernel_6;
	assign kernel[3] = kernel_5;
	assign kernel[4] = kernel_4;
	assign kernel[5] = kernel_3;
	assign kernel[6] = kernel_2;
	assign kernel[7] = kernel_1;
	assign kernel[8] = kernel_0;
	
endmodule

