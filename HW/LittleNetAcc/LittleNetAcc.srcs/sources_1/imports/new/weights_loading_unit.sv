`timescale 1ns / 1ps


module LoadingWeightsUnit
		#(
		 parameter BIT_WIDTH = 8,
		 parameter BATCH_SIZE = 9,
		 parameter MEMORY_WEIGHTS_SIZE = 9,
		 parameter ADDRESS_BITS = 4,
		 parameter READ_MEMORY_LATENCY = 2,
		 
		 // counter counts up to the number of weights
		 localparam BATCH_CNTR_BITS = $clog2(BATCH_SIZE+1)
		 )
	// ports
		 (
		 input clk,
		 // WEIGHTS MEMORY
		 input [BIT_WIDTH-1:0] weights_memory_out,
		 output [ADDRESS_BITS-1:0] weights_memory_address,
		 output weights_memory_read_enable,
		
		 // control signals
		 input enable,
		 input reset,
		 input next_batch,
		 
		 // output connection to weights registers
		 output [BIT_WIDTH-1:0] weights [BATCH_SIZE],
		 output is_weights_loading
		 );
	/*
	To load weight use signal should remain for at least 1 clk
	*/
	// WEIGHT variables
	reg is_loading = 0;
	wire is_counter_end;
	wire delayed_is_counter_end;
	
	// for weight loading are needed counters
	reg [BATCH_CNTR_BITS-1:0] counter_local_weights = 0;
	reg [ADDRESS_BITS-1:0] counter_memory_weights = 0;
	
	wire fully_enabled;
	assign fully_enabled = enable && !reset && is_loading;
	
	// counter end if last address is achieved
	assign is_counter_end = counter_local_weights == BATCH_SIZE;
	DelayLine  #(
				.WIDTH(1),
				.DELAY(READ_MEMORY_LATENCY) 
				) 
				delay_line_of_is_counter_end 
				(
				.clk(clk),
				.enable(fully_enabled),
				.data_in(is_counter_end),
				.data_out(delayed_is_counter_end)
				);
				
	always @(posedge clk)
		begin
		if (reset)
			begin
			counter_local_weights <= 0;
			counter_memory_weights <= 0;
			is_loading <= 1;
			end
		else if (enable)
			begin
			// load next batch of weights
			if (next_batch)
				begin
				// set loading flag 
				is_loading <= 1;
				// reset local counter
				counter_local_weights <= 0;
				end
			// weight loading counters and flags
			else if (is_loading)
				begin
				// still sth to load
				if (!is_counter_end)
					begin
					counter_local_weights <= counter_local_weights+1;
					counter_memory_weights <= counter_memory_weights+1;
					end
				// if whole batch is loaded to registers
				else if (delayed_is_counter_end) 
					begin
					// reset loading flag
					is_loading <= 0;
					end
				end
			end
		end
	// always end
	
	// load weights to shift registers
	ShiftRegisters #(
					.WIDTH(BIT_WIDTH), 
					.LENGTH(BATCH_SIZE)
					)
					weights_registers
					(
					.clk(clk),
					.step(!delayed_is_counter_end),
					// .step(is_loading),
					.data_in(weights_memory_out),
					.registers_out(weights)
					);
					
	assign weights_memory_address = counter_memory_weights;
	assign weights_memory_read_enable = is_loading && enable;
	
	assign is_weights_loading = is_loading;

endmodule // LoadWeights

