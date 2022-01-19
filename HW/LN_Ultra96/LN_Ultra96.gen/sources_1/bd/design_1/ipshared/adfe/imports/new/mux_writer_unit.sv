`timescale 1ns / 1ps


module AddressCounter
		#(
		parameter BIT_WIDTH = 8,
		parameter DELAY = 0,
		parameter BEGIN_ADDRESS = 0,
		parameter END_ADDRESS = 0,
		parameter ADDRESS_BITS = 0
		)
		(
		input clk,
		input enable,
		input reset,
		
		input [BIT_WIDTH-1:0] in_data,
		input in_data_validity,
		
		output [BIT_WIDTH-1:0] out_data,
		output [ADDRESS_BITS-1:0] out_data_address,
		output out_data_validity,
		output finished
		);
		
	generate
		if (BEGIN_ADDRESS != END_ADDRESS)
			begin
			reg [ADDRESS_BITS-1:0] counter = END_ADDRESS;
			reg is_address_valid = 0;
			
			wire [BIT_WIDTH-1:0] delayed_data;
			wire delayed_data_validity;
			// delay of data
			DelayLine 	#(
						.WIDTH(BIT_WIDTH),
						.DELAY(DELAY)
						)
						delay_of_data
						(
						.clk(clk),
						.enable(enable),
						.data_in(in_data),
						.data_out(delayed_data)
						);
			// delay of validity
			ResettableDelayLine	#(
						.WIDTH(1),
						.DELAY(DELAY)
						)
						delay_of_validity
						(
						.clk(clk),
						.reset(reset),
						.enable(enable),
						.data_in(in_data_validity),
						.data_out(delayed_data_validity)
						);
			
			wire is_last_address = counter == END_ADDRESS;
			
			always @(posedge clk)
				begin
				if (reset)
					begin
					counter <= BEGIN_ADDRESS;
					is_address_valid <= 1;
					end
				// make step if enable and data is valid
				else if (enable && delayed_data_validity)
					begin
					// current delayed data will be stored under current counter address
					if (!is_last_address)
						begin
						// update for next data
						counter <= counter+1;
						end
					// allow last data for storing under current address
					// without delay last data cannot be saved 
					is_address_valid <= !is_last_address;
					end
				end
			// always end
			
			assign out_data = delayed_data;
			assign out_data_address = counter;
			assign out_data_validity = delayed_data_validity && is_address_valid;
			// assign finished = is_last_address;
			assign finished = !is_address_valid;
			end
		else
			begin
			assign out_data = 0;
			assign out_data_address = END_ADDRESS;
			assign out_data_validity = 1'b0;
			// assign finished = is_last_address;
			assign finished = 1'b1;
			end
	endgenerate
	
endmodule // AddressCounter



module MuxWriterUnit
		#(
		parameter BIT_WIDTH = 8,
		parameter WIDTH = 360,
		parameter HEIGHT = 180,
		parameter CHANNELS = 16,
		parameter GROUPS = 1, // used only for channel division
		parameter PARALLELISM = 2,
		parameter REGISTER_FOR_EACH = 1,
		parameter WRITE_MEMORY_LATENCY = 2,
		
		localparam OUT_SIZE = WIDTH*HEIGHT*CHANNELS / GROUPS,
		localparam ADDRESS_BITS = $clog2(OUT_SIZE),
		
		localparam RANGE_PER_THREAD = WIDTH*HEIGHT*((CHANNELS-1)/PARALLELISM+1) / GROUPS,
		localparam GLOBAL_LAST_ADDRESS = WIDTH*HEIGHT*CHANNELS-1,
		
		localparam SELECTOR_CNTR_BITS = $clog2(PARALLELISM)
		)
		(
		input clk,
		input enable,
		input reset,
		
		input [BIT_WIDTH-1:0] in_data[PARALLELISM],
		input in_data_validity[PARALLELISM],
		
		output [BIT_WIDTH-1:0] out_data_memory_in,
		output [ADDRESS_BITS-1:0] out_data_memory_address,
		output out_data_memory_write_enable,
		
		output finished
		);
	
	wire processing_state = enable && !reset;
	
	wire [PARALLELISM-1:0] in_data_validity_vec;
	wire input_valid;
	genvar gen_j;
	generate
		for(gen_j = 0; gen_j < PARALLELISM; gen_j = gen_j+1)
			assign in_data_validity_vec[gen_j] = in_data_validity[gen_j];
		// for end
	endgenerate
	// if in input are valid data
	assign input_valid = |in_data_validity_vec;
	
	genvar gen_i;
	generate
	if (REGISTER_FOR_EACH)
		begin
		wire [BIT_WIDTH-1:0] delayed_data [PARALLELISM];
		wire delayed_data_validity [PARALLELISM];
		wire [ADDRESS_BITS-1:0] delayed_data_address [PARALLELISM];
		wire [PARALLELISM-1:0] is_finished;
		
		// delays of input data and their validity
		for(gen_i = 0; gen_i < PARALLELISM; gen_i = gen_i+1)
			begin
			localparam BEG_ADDR = gen_i* RANGE_PER_THREAD;
			localparam END_ADDR = (gen_i+1) * RANGE_PER_THREAD-1;
			
			AddressCounter	#(
							.BIT_WIDTH(BIT_WIDTH),
							.DELAY(gen_i+1),
							.BEGIN_ADDRESS(BEG_ADDR < GLOBAL_LAST_ADDRESS ? BEG_ADDR
																		  : GLOBAL_LAST_ADDRESS),
							// end address for last thread could be different
							.END_ADDRESS(END_ADDR < GLOBAL_LAST_ADDRESS ? END_ADDR
																		: GLOBAL_LAST_ADDRESS),
							.ADDRESS_BITS(ADDRESS_BITS)
							)
							cntr_for_thread
							(
							.clk(clk),
							.enable(processing_state),
							.reset(reset),
							
							.in_data(in_data[gen_i]),
							.in_data_validity(in_data_validity[gen_i]),
							
							.out_data(delayed_data[gen_i]),
							.out_data_address(delayed_data_address[gen_i]),
							.out_data_validity(delayed_data_validity[gen_i]),
							.finished(is_finished[gen_i])
							);
			end
		// for end
		reg [SELECTOR_CNTR_BITS-1:0] selector_cntr = 0;
		reg [BIT_WIDTH-1:0] reg_selected_data = 0;
		reg [ADDRESS_BITS-1:0] reg_selected_address = 0;
		reg reg_selected_data_validity = 0;
		
		always @(posedge clk)
			begin
			if (reset)
				begin
				reg_selected_data <= 0;
				reg_selected_address <= 0;
				reg_selected_data_validity <= 0;
				selector_cntr <= 0;
				end
			else if (enable)
				begin
				// iterate over all threads
				// reset iterator when new data is coming
				if (input_valid || selector_cntr == PARALLELISM-1)
					selector_cntr <= 0;
				else
					selector_cntr <= selector_cntr+1;
				
				// take data from iterated thread
				reg_selected_data <= delayed_data[selector_cntr];
				reg_selected_data_validity <= delayed_data_validity[selector_cntr];
				reg_selected_address <= delayed_data_address[selector_cntr];
				end
			end
		// always end
		
		assign out_data_memory_in = reg_selected_data;
		assign out_data_memory_write_enable = reg_selected_data_validity && enable;
		assign out_data_memory_address = reg_selected_address;
		
		// delay finish state of counters
		ResettableDelayLine	#(
							.WIDTH(1),
							.DELAY(WRITE_MEMORY_LATENCY+1+1) // registers afters selection
							)
							delay_of_finish
							(
							.clk(clk),
							.enable(enable),
							.reset(reset),
							
							.data_in(&is_finished),
							.data_out(finished)
							);
		end
	endgenerate
endmodule // MuxWriterUnit

