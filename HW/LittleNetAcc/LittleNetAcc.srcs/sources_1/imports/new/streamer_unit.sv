`timescale 1ns / 1ps


module PointStreamerUnit
		#(
		 parameter IN_WIDTH = 360,
		 parameter IN_HEIGHT = 180,
		 parameter IN_CHANNELS = 15,
		 parameter BIT_WIDTH = 8,
		 parameter READ_LATENCY = 2,
		 
		 localparam PIXELS = IN_CHANNELS*IN_WIDTH*IN_HEIGHT,
		 localparam ADDRESS_BITS = $clog2(PIXELS)
		 )
		 (
		 input clk,
		 input enable,
		 input reset,
		 
		 output [BIT_WIDTH-1:0] pixel_value,
		 output validity,
		 output end_point,
		 output end_pass,
		 
		 // memory interface
		 output [ADDRESS_BITS-1:0] in_data_memory_address,
		 output in_data_memory_read_enable,
		 input [BIT_WIDTH-1:0] in_data_memory_out
		 );
	
	localparam STEP=IN_WIDTH*IN_HEIGHT;
	localparam CHANNEL_CNTR_BITS = $clog2(IN_CHANNELS);
	localparam POINTS_NUM = IN_WIDTH*IN_HEIGHT;
	localparam POINTS_CNTR_BITS = $clog2(POINTS_NUM);
	
	reg [POINTS_CNTR_BITS-1:0] counter_points = 0;
	reg [CHANNEL_CNTR_BITS-1:0] counter_channels = 0;
	
	wire processing_state = enable && !reset;
	
	wire valid = processing_state; // current is valid if is processing state
	wire is_end_point = counter_channels == IN_CHANNELS-1;
	wire is_end_pass = counter_points == POINTS_NUM-1;
	
	always @(posedge clk)
		begin
		if (reset)
			begin
			counter_points = 0;
			counter_channels = 0;
			end
		else if (enable)
			begin
			// go to next channel
			// last channel is achieved => go to first channel
			if (is_end_point)
				begin
				counter_channels <= 0;
				// go to next point
				// last point is achieved => go to first point
				if (is_end_pass)
					counter_points <= 0;
				else
					// next point
					counter_points <= counter_points+1;
				end
			else
				// next channel
				counter_channels <= counter_channels+1;
			end
		end
	// always end
	
	wire [47:0] address;
	wire [17:0] ch;
	wire [47:0] base;
	wire [26:0] step = STEP;
	assign ch = {{(27-CHANNEL_CNTR_BITS){1'b0}}, counter_channels};
	assign base = {{(48-POINTS_CNTR_BITS){1'b0}}, counter_points};
	
	// ADDRESS COMPUTING
	localparam DSP_STREAMER_LATENCY = 4;
	DSP_STREAMER address_computer
				(
				.CLK(clk),
				.CE(processing_state),
				.SCLR(reset),
				.A(step),
				.B(ch),
				.C(base),
				.P(address)
				);
	// get part with computed address. Rest should be zeros. 
	assign in_data_memory_address = address[ADDRESS_BITS-1:0];
	// read when module enabled
	assign in_data_memory_read_enable = processing_state;
	// value of pixel is memory cell value read from computed address
	assign pixel_value = in_data_memory_out;
	
	// delay of state
	ResettableDelayLine #(
						.WIDTH(3),
						.DELAY(DSP_STREAMER_LATENCY+READ_LATENCY)
						)
						delay_of_state
						(
						.clk(clk),
						.reset(reset),
						.enable(processing_state),
						.data_in({valid, 
								  is_end_point, 
								  is_end_pass && is_end_point}),// end pass should take one clock's period
						.data_out({validity, 
								   end_point, 
								   end_pass})
						);
	
endmodule // StreamerUnit


module CyclicStreamerUnit
		#(
		 parameter BIT_WIDTH = 8,
		 parameter CYCLE_LENGTH = 15,
		 parameter PRE_DATA = 0,
		 parameter NUM_OF_CYCLES = 16,
		 parameter READ_LATENCY = 2,
		 
		 localparam STREAM_LENGTH = (CYCLE_LENGTH+PRE_DATA)*NUM_OF_CYCLES,
		 localparam IN_STREAM_ADDRESS_BITS = $clog2(STREAM_LENGTH),
		 localparam LOCAL_CNTR_BITS = $clog2(CYCLE_LENGTH)
		 )
		 (
		 input clk,
		 input reset,
		 input enable,
		 
		 // control when go to next cycle and load pre-data
		 // should be true when end_of_cycle is true
		 input next_cycle,
		 // first element is in-stream element rest are pre-cycle-data
		 output [BIT_WIDTH-1:0] output_stream [1+PRE_DATA],
		 output validity,
		 
		 // current state of streamer
		 output streaming, 
		 // when last data of cycle loading is started
		 output end_of_cycle,
		 // is true if last data loading is started
		 output end_of_data,
		 
		 // memory interface
		 output [IN_STREAM_ADDRESS_BITS-1:0] data_memory_address,
		 input [BIT_WIDTH-1:0] data_memory_out,
		 output data_memory_read_enable
		 );
	reg is_streaming = !PRE_DATA;
	reg [BIT_WIDTH-1:0] stream_data [1+PRE_DATA];
	reg [LOCAL_CNTR_BITS-1:0] counter_local = 0;
	reg [IN_STREAM_ADDRESS_BITS-1:0] counter_in_stream = 0;
	// to easily back to begin of cycle from end
	reg [IN_STREAM_ADDRESS_BITS-1:0] cycle_begin_address = 0;
	
	initial
		begin
		for(int i=0; i < (1+PRE_DATA); i = i+1)
			stream_data[i] = 0;
		end
	
	wire processing_state = enable && !reset;
	
	// address of data
	assign data_memory_address = counter_in_stream;
	assign data_memory_read_enable = processing_state;
	wire [BIT_WIDTH-1:0] input_data = data_memory_out;
	// streamed data and pre-data assign to output port 
	assign output_stream = stream_data;
	
	// end of cycle loop
	wire cycle_end = counter_local == CYCLE_LENGTH-1;
	// assign it to output port
	assign  end_of_cycle = cycle_end;
	
	// last data_achieved
	assign end_of_data = counter_in_stream == STREAM_LENGTH-1;
	
	// delay of validity of data
	ResettableDelayLine #(
						.WIDTH(1),
						.DELAY(READ_LATENCY+1) // with save to register
						)
						delay_of_is_streaming
						(
						.clk(clk),
						.reset(reset),
						.enable(processing_state),
						.data_in(is_streaming),
						.data_out(validity)
						);
	// state of streamer
	assign streaming = is_streaming;
	
	// loading of registers
	wire registers_loaded;
	assign registers_loaded = !is_streaming && counter_local == PRE_DATA-1 && PRE_DATA;
	
	// end of cycle loop, which need to go back to beginning of cycle
	wire true_in_cycle_end;
	assign true_in_cycle_end = is_streaming && cycle_end && !next_cycle;
	
	always @(posedge clk)
		begin
		if (reset)
			begin
			is_streaming <= !PRE_DATA;
			counter_local <= 0;
			counter_in_stream <= 0;
			cycle_begin_address <= 0;
			
			for(int i=0; i < (1+PRE_DATA); i = i+1)
				stream_data[i] <= 0;
			end
		else if (enable)
			begin
			// assign data from memory to first register
			stream_data[0] <= input_data;
			
			// stop normal flow if is end of cycle, flow to registers
			// stop streaming only if sth is to load
			if (next_cycle && cycle_end && PRE_DATA) 
				begin
				is_streaming <= 0;
				end
			else if (registers_loaded)
				begin
				is_streaming <= 1;
				end
			
			// stage of loading pre-data
			// it's state of value in first register not address
			if (!validity && PRE_DATA)
				begin
				// shift loaded value to next registers
				for(int i=1; i < (1+PRE_DATA); i = i+1)
					stream_data[i] <= stream_data[i-1];
				end
			
			// reset local counter at the end of cycle 
			// (with or without going to next cycle)
			// or when registers are loaded for next cycle 
			if (cycle_end || registers_loaded)
				begin
				counter_local <= 0;
				end
			// increment local counter in cycle loop or while pre-data loading
			else
				begin
				counter_local <= counter_local+1;
				end
			
			// cycle loop end - go to beginning
			if (true_in_cycle_end)
				begin
				counter_in_stream <= cycle_begin_address;
				end
			// incrementation of in-stream counter if inside cycle
			// or end of cycle with go to next cycle
			else
				begin
				counter_in_stream <= counter_in_stream+1;
				end
			
			// zero local counter is begin of cycle
			// possible it can be also begin of registers loading,
			// but after loading is reset to be beginning of cycle
			if (!counter_local)
				begin
				cycle_begin_address <= counter_in_stream;
				end
			
			end
		end
	// always end
	
endmodule // CyclicStreamer
