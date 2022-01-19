`timescale 1ns / 1ps


module MaxPool2dUnit
		#(
		 parameter DATA_BIT_WIDTH = 8,
		 parameter DATA_SIGNED = 1,
		 
		 parameter IN_WIDTH = 360,
		 parameter IN_HEIGHT = 180,
		 parameter PARALLELISM = 1,
		 
		 parameter CEIL_MODE = 1,
		 parameter COMPARE_TO_ZERO = 0,
		 
		 // const block size
		 localparam K_SIZE = 2,
		 localparam STRIDE = K_SIZE,
		 
		 localparam WIDTH_BITS = $clog2(IN_WIDTH),
		 localparam HEIGHT_BITS = $clog2(IN_HEIGHT),
		 
		 localparam OUT_WIDTH = (IN_WIDTH - CEIL_MODE) / STRIDE + CEIL_MODE,
		 localparam OUT_HEIGHT = (IN_HEIGHT - CEIL_MODE) / STRIDE + CEIL_MODE,
		 
		 localparam COL_CNTR_BITS = $clog2(IN_WIDTH),
		 localparam ROW_CNTR_BITS = $clog2(IN_HEIGHT)
		 )
		 (
		 input clk,
		 input enable,
		 input reset,
		 
		 input all_data_in_stream,
		 input [DATA_BIT_WIDTH-1:0] in_data [PARALLELISM],
		 input in_data_validity [PARALLELISM],
		 
		 output [DATA_BIT_WIDTH-1:0] out_data [PARALLELISM],
		 
		 output out_data_validity [PARALLELISM]		 
		 );
	reg [DATA_BIT_WIDTH-1:0] prev [PARALLELISM];
	reg [DATA_BIT_WIDTH*PARALLELISM-1:0] bottom_flatten_reg = 0;
	// reg prev_validity[PARALLELISM];
	
	wire processing_state = enable && !reset;
	wire [PARALLELISM-1:0] in_data_validity_bus;
	genvar s;
	generate
		for(s = 0; s < PARALLELISM; s = s+1)
			assign in_data_validity_bus[s] = in_data_validity[s];
		// for end
	endgenerate
	
	// wire step = processing_state && (in_data_validity.or() || all_data_in_stream);
	wire step = processing_state && (|in_data_validity_bus || all_data_in_stream);
	
	reg [COL_CNTR_BITS-1:0] counter_col = 0;
	reg [ROW_CNTR_BITS-1:0] counter_row = 0;
	
	wire col_end = counter_col == IN_WIDTH-1;
	wire row_end = counter_row == IN_HEIGHT-1;
	
	// if parity bit is set or if ceil mode and last unpaired element
	wire col_block_end = counter_col[0] || CEIL_MODE && col_end;
	wire row_block_end = counter_row[0] || CEIL_MODE && row_end;
	wire block_end = col_block_end && row_block_end;
	// store final result
	reg [DATA_BIT_WIDTH-1:0] pooled_max_reg[PARALLELISM];
	
	wire [DATA_BIT_WIDTH*PARALLELISM-1:0] top_flatten;
	
	wire horizontal_step = col_block_end && step;
	wire delayed_horizontal_step;
	
	// move horizontal max to delay line
	DelayLine #(
			.WIDTH(DATA_BIT_WIDTH*PARALLELISM),
			.DELAY(OUT_WIDTH)
			)
			delay_of_horizontal_max
			(
			.clk(clk),
			.enable(delayed_horizontal_step),
			.data_in(bottom_flatten_reg),
			.data_out(top_flatten)
			);
	// result of horizontal max is stored in register, so step validity must be delayed
	ResettableDelayLine #(
			.WIDTH(1),
			.DELAY(1)
			)
			delay_of_horizontal_step
			(
			.clk(clk),
			.enable(processing_state),
			.reset(reset),
			.data_in(horizontal_step),
			.data_out(delayed_horizontal_step)
			);
	
	// HORIZONTAL MAX
	wire [DATA_BIT_WIDTH*PARALLELISM-1:0] bottom_flatten;
	wire [DATA_BIT_WIDTH-1:0] bottom_right[PARALLELISM] = in_data;
	wire [DATA_BIT_WIDTH-1:0] bottom_left[PARALLELISM] = prev;
	// if current column is last unpaired
	wire unpaired_col = (!counter_col[0] && col_end) && CEIL_MODE;
	
	genvar i;
	generate
		for(i = 0; i < PARALLELISM; i = i+1)
			begin
			wire [DATA_BIT_WIDTH-1:0] tmp_bottom_max;
			assign bottom_flatten[(i+1)*DATA_BIT_WIDTH-1 
									:i*DATA_BIT_WIDTH] = tmp_bottom_max;
			// for unsigned data
			if (!DATA_SIGNED)
				begin
				assign tmp_bottom_max = bottom_left[i] < bottom_right[i] 
										|| unpaired_col ? bottom_right[i]
														: bottom_left[i];
				end
			// for signed data
			else
				begin
				wire signed [DATA_BIT_WIDTH-1:0] signed_bottom_right = bottom_right[i];
				wire signed [DATA_BIT_WIDTH-1:0] signed_bottom_left = bottom_left[i];
				// with checking if max value is negative
				if (COMPARE_TO_ZERO)
					begin
					assign tmp_bottom_max = signed_bottom_left < signed_bottom_right 
											|| unpaired_col ? unpaired_col // if unpaired
															&& signed_bottom_right < 0 ? 0 // and signed right value is lower than 0 (filler is 0)
																						:bottom_right[i]
															: bottom_left[i];
					end
				else
					begin
					assign tmp_bottom_max = signed_bottom_left < signed_bottom_right 
											|| unpaired_col ? bottom_right[i]
															: bottom_left[i];
					end
				end
			end
		// for end
	endgenerate
	
	// VERTICAL MAX
	wire [DATA_BIT_WIDTH-1:0] pooled_max [PARALLELISM];
	// if current row is last unpaired
	wire unpaired_row;
	// delay because of bottom max is stored in register
	ResettableDelayLine #(
					.WIDTH(1),
					.DELAY(1)
					)
					delay_of_unpaired_row
					(
					.clk(clk),
					.enable(processing_state),
					.reset(reset),
					.data_in((!counter_row[0] && row_end) && CEIL_MODE),
					.data_out(unpaired_row)
					);
	
	genvar j;
	generate
		for(j = 0; j < PARALLELISM; j = j+1)
			begin
			wire [DATA_BIT_WIDTH-1:0] top_max = top_flatten[(j+1)*DATA_BIT_WIDTH-1 :j*DATA_BIT_WIDTH];
			wire [DATA_BIT_WIDTH-1:0] bottom_max = bottom_flatten_reg[(j+1)*DATA_BIT_WIDTH-1 :j*DATA_BIT_WIDTH];
			// for unsigned data
			if (!DATA_SIGNED)
				begin
				assign pooled_max[j] = top_max < bottom_max 
									   || unpaired_row ? bottom_max
													   : top_max;
				end
			// for signed data
			else
				begin
				wire signed [DATA_BIT_WIDTH-1:0] signed_top_max = top_max;
				wire signed [DATA_BIT_WIDTH-1:0] signed_bottom_max = bottom_max;
				// with checking if max value is negative
				if (COMPARE_TO_ZERO)
					begin
					assign pooled_max[j] = signed_top_max < signed_bottom_max 
										   || unpaired_row ? unpaired_row // if unpaired
															 && signed_bottom_max < 0 ? 0 // and signed right value is lower than 0 (filler is 0)
																					  :bottom_max
														   : top_max;
					end
				else
					begin
					assign pooled_max[j] = signed_top_max < signed_bottom_max 
										   || unpaired_row ? bottom_max
														   : top_max;
					end
				end
			end
		// for end
	endgenerate
	
	// initialize arrays
	initial
	begin
		for(int i = 0; i < PARALLELISM; i = i+1)
			begin
			prev[i] <= 0;
			// prev_validity[i] <= 0;
			pooled_max_reg[i] <= 0;
			end
	end
	
	always @(posedge clk)
		begin
		if (reset)
			begin
			counter_col <= 0;
			counter_row <= 0;
			bottom_flatten_reg <= 0;
			
			for(int k = 0; k < PARALLELISM; k = k+1)
				begin
				prev[k] <= 0;
				// prev_validity[k] <= 0;
				pooled_max_reg[k] <= 0;
				end
			// for end
			end
		else if (processing_state)
			begin
			// store current horizontal max
			bottom_flatten_reg <= bottom_flatten;
			// and final vertical max
			for (int k = 0; k < PARALLELISM; k = k+1)
				pooled_max_reg[k] <= pooled_max[k];
			
			if (step)
				begin
				for (int k = 0; k < PARALLELISM; k = k+1)
					prev[k] <= in_data[k];
				
				if (col_end)
					begin
					counter_col <= 0;
					if (row_end)
						counter_row <= 0;
					else
						counter_row <= counter_row+1;
					end
				else
					counter_col <= counter_col+1;
				end
			end
		end
	// always end
	
	wire [PARALLELISM-1:0] final_pooled_data_max_validity;
	wire [PARALLELISM-1:0] pooled_data_validity;
	genvar m;
	generate
		for(m = 0; m < PARALLELISM; m = m+1)
			assign pooled_data_validity[m] = in_data_validity[m] 
											 && block_end
											 && processing_state;
	endgenerate
		
	ResettableDelayLine #(
						.WIDTH(PARALLELISM),
						.DELAY(2)
						)
						delay_of_pooled_max_validity
						(
						.clk(clk),
						.enable(processing_state),
						.reset(reset),
						.data_in(pooled_data_validity),
						.data_out(final_pooled_data_max_validity)
						);
	
	// assign to output ports
	assign out_data = pooled_max_reg;
	
	genvar n;
	generate
		// convert wide signal into array of signal's width elements
		for(n = 0; n < PARALLELISM; n = n+1)
			assign out_data_validity[n] = final_pooled_data_max_validity[n];
	endgenerate
	
endmodule // MaxPool2dUnit

