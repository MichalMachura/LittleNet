`timescale 1ns / 1ps

// align data point in reference to result of multiplication
module PointAlignment #(

					parameter B_BITS=8,
					parameter B_INT=1,
					parameter B_SIGN=1,
					
					parameter W_BITS=8,
					parameter W_INT=1,
					parameter W_SIGN=1,
					
					parameter DATA_BITS=8,
					parameter DATA_INT=1,
					parameter DATA_SIGN=1,
					parameter DST_WIDTH = 48,
					
					localparam B_FRAC = B_BITS - B_INT,
					localparam W_FRAC = W_BITS - W_INT,
					localparam DATA_FRAC = DATA_BITS - DATA_INT
					)
					(
					input [W_BITS-1:0] in_bias,
					output [DST_WIDTH-1:0] out_bias
					);
	// after bias alignment mul result point pos. minus bias frac. part size
	localparam AFTER_BIAS_BITS = (DATA_FRAC+W_FRAC)-B_FRAC;
	localparam BEFORE_BIAS_BITS = DST_WIDTH - (DATA_FRAC+W_FRAC + B_INT);
	// pre fill depends on sign
	wire pre_filler;
	
	generate
		if (W_SIGN)
			// pre filler is MSB - sign bit
			assign pre_filler = in_bias[W_BITS-1];
		else
			// fill by zero
			assign pre_filler = 1'b0;
	endgenerate
	
	assign out_bias = {
						 {BEFORE_BIAS_BITS{pre_filler}},
						 in_bias,
						 {AFTER_BIAS_BITS{1'b0}} };
endmodule // BiasAlignment


module SignAlignment #(
					  parameter WIDTH=8,
					  parameter SIGN=1,
					  parameter DST_WIDTH = 18
					  )
					  (
					  input [WIDTH-1:0] in_signal,
					  output [DST_WIDTH-1:0] out_signal
					  );
	localparam BEFORE_BITS = DST_WIDTH - WIDTH;
	
	// pre fill depends on sign
	wire pre_filler;
	generate
		if (SIGN)
			// last bit is filler
			assign pre_filler = in_signal[WIDTH-1];
		else
			// zero is filler
			assign pre_filler = 1'b0;
	endgenerate
	
	assign out_signal = {
						 {BEFORE_BITS{pre_filler}},
						 in_signal};
endmodule // SignAlignment


module WidthReduction
		#(
		 parameter IN_WIDTH=48,
		//  parameter IN_INT=1,
		 parameter IN_FRAC=16,
		 parameter IN_SIGNED=1,
		 
		 parameter DST_WIDTH=8,
		 parameter DST_INT=1,
		 parameter DST_SIGNED=1,
		 
		 parameter RELU=0,
		 parameter CUT_TOP=3,
		 
		 localparam DST_FRAC = DST_WIDTH-DST_INT
		 )
		 (
		 input [IN_WIDTH-1:0] in_signal,
		 output [DST_WIDTH-1:0] out_signal
		 );
	localparam LSB = IN_FRAC-DST_FRAC;
	localparam SIGNIFICANT_PART_WIDTH = IN_WIDTH-LSB-CUT_TOP;
	wire [DST_WIDTH-1:0] intermediate;
	
	generate
	if (!IN_SIGNED) // dst signed or not 
		begin
		wire [SIGNIFICANT_PART_WIDTH-1:0] significant_part;
		assign significant_part = in_signal[SIGNIFICANT_PART_WIDTH+LSB-1:LSB];
		// constants to compare as unsigned on the same bit width
		localparam [SIGNIFICANT_PART_WIDTH-1:0] MAX_VALUE = (2**(DST_WIDTH-DST_SIGNED))-1;
		localparam [SIGNIFICANT_PART_WIDTH-1:0] MIN_VALUE = (1-RELU)*DST_SIGNED*(-2**(DST_WIDTH-1));
		
		assign intermediate = significant_part > MAX_VALUE ? MAX_VALUE
														   : in_signal[DST_WIDTH+LSB-1:LSB];
		// if input data is higher than max output signed value, 
		// then output sign bit is not set, because max value not include this bit,
		// so negative part (MSB) is always 0.
		// For both unsigned all bits are used.
		end
	else if (IN_SIGNED) // dst signed or unsigned is captured by this 'if', 
						// because previous MIN-MAX values calculation 
		begin
		wire signed [SIGNIFICANT_PART_WIDTH-1:0] significant_part;
		assign significant_part = in_signal[SIGNIFICANT_PART_WIDTH+LSB-1:LSB];
		// constants to compare as signed on the same bit width
		localparam signed [SIGNIFICANT_PART_WIDTH-1:0] MAX_VALUE = (2**(DST_WIDTH-DST_SIGNED))-1;
		localparam signed [SIGNIFICANT_PART_WIDTH-1:0] MIN_VALUE = (1-RELU)*DST_SIGNED*(-2**(DST_WIDTH-1));
		
		wire is_less = significant_part < MIN_VALUE;
		wire is_more = significant_part > MAX_VALUE;
		
		assign intermediate = significant_part > MAX_VALUE ? MAX_VALUE
														   : significant_part < MIN_VALUE ? MIN_VALUE
														 								  : in_signal[DST_WIDTH+LSB-1:LSB];
		// if output is unsigned, then input is checked by comparison to 0 (results of MIN_VALUE)
		// and max value (for the same bit width it could by higher) 
		end
		
	endgenerate
	
	// final reduced signal
	assign out_signal = intermediate;
	
endmodule // WidthReduction


module GrouperUnit
		#(
		parameter BIT_WIDTH = 8,
		parameter GROUPS = 1,
		parameter ENDIANNESS = 0, // 1 - BIG, 0 - LITTLE
		
		localparam OUT_WIDTH = BIT_WIDTH*GROUPS,
		localparam CNTR_BITS = $clog2(GROUPS)
		)
		(
		input clk,
		input enable,
		input reset,
		
		input [BIT_WIDTH-1:0] data_in,
		input data_in_validity,
		
		output [OUT_WIDTH-1:0] data_out,
		output data_out_validity
		);
	reg [CNTR_BITS-1:0] cntr = 0;
	reg delayed_full_valid = 0;
	wire full_valid = cntr == GROUPS-1 && data_in_validity;
	
	wire [BIT_WIDTH-1:0] reg_data [GROUPS];
	ShiftRegisters	#(
					.WIDTH(BIT_WIDTH),
					.LENGTH(GROUPS)
					)
					cache
					(
					.clk(clk),
					.step(enable && data_in_validity),
					.data_in(data_in),
					.registers_out(reg_data)
					);
	
	// assign output to registers
	genvar gen_i;
	generate
		for(gen_i = 0; gen_i < GROUPS; gen_i = gen_i+1)
			begin
			// BIG ENDIAN
			if (ENDIANNESS)
				begin
				// newest at lowest bytes
				assign data_out[(gen_i+1)*BIT_WIDTH-1:gen_i*BIT_WIDTH] = reg_data[gen_i];
				end
			// LITTLE ENDIAN
			else
				begin
				// oldest at lowest bytes
				assign data_out[(gen_i+1)*BIT_WIDTH-1:gen_i*BIT_WIDTH] = reg_data[GROUPS-gen_i-1];
				end
			end
		// for end
	endgenerate
	
	always @(posedge clk)
		begin
		if (reset)
			begin
			cntr <= 0;
			delayed_full_valid <= 0;
			end
		else if (enable)
			begin
			// delay of full validity
			delayed_full_valid <= full_valid;
			// counter of stored data
			if (enable && data_in_validity)
				begin
				if (cntr == GROUPS-1)
					cntr <= 0;
				else
					cntr <= cntr+1;
				end
			end
		end
	// always end
	
	assign data_out_validity = enable && delayed_full_valid;
	
endmodule // GrouperUnit



module MaxFinderUnit
		#(
		parameter BIT_WIDTH = 8,
		parameter SIGNED = 1,
		parameter WIDTH = 13,
		parameter HEIGHT = 7,
		parameter ANCHORS_NUM = 3,
		parameter WRITE_MEMORY_LATENCY = 2,
		parameter PARALLELISM = 1,
		// number of elements to describe maximum == anchor idx, Xc,Xy,W,H, pos_row, pos_col
		// or 
		// Xc,Yc,W,H pos 3 bytes
		localparam DESCRIPTION_SIZE = 7,
		localparam CHANNELS = ANCHORS_NUM*DESCRIPTION_SIZE,
		localparam ADDR_BITS = $clog2(DESCRIPTION_SIZE),
		localparam COL_CNTR_BITS = $clog2(WIDTH),
		localparam ROW_CNTR_BITS = $clog2(HEIGHT),
		localparam ANCHOR_CNTR_BITS = $clog2(ANCHORS_NUM)
		)
		(
		input clk,
		input enable,
		input reset,
		
		input [BIT_WIDTH-1:0] data_in [PARALLELISM],
		input data_in_validity [PARALLELISM],
		
		output [BIT_WIDTH-1:0] out_data_memory_in,
		output [ADDR_BITS-1:0] out_data_memory_address,
		output out_data_memory_write_enable,
		
		output finished
		);
	localparam [BIT_WIDTH-1:0] CURRENT_MAX_INIT = {SIGNED ? 1'b1 : 1'b0, {(BIT_WIDTH-1){1'b0}}};
	
	generate
	if (PARALLELISM == 1)
		begin
			reg [BIT_WIDTH-1:0] current_max = CURRENT_MAX_INIT;
			reg [COL_CNTR_BITS-1:0] counter_col = 0, max_pos_col = 0;
			reg [ROW_CNTR_BITS-1:0] counter_row = 0, max_pos_row;
			reg [ANCHOR_CNTR_BITS-1:0] counter_anchor = 0, max_pos_anchor = 0;
			
			reg [BIT_WIDTH-1:0] out_data = 0;
			reg [ADDR_BITS-1:0] out_data_address = 0; // == counter of point description
			reg out_data_validity = 0;
			
			reg search_mode = 1;
			wire is_greater;
			
			if (SIGNED)
				begin
				// convert to signed wires
				wire signed [BIT_WIDTH-1:0] current_max_signed = current_max;
				wire signed [BIT_WIDTH-1:0] data_in_signed = data_in[0];
				
				assign is_greater = data_in_signed > current_max_signed;
				end
			else
				assign is_greater = data_in[0] > current_max;
			
			
			wire last_anchor = counter_anchor == ANCHORS_NUM-1;
			wire last_col = counter_col == WIDTH-1;
			wire last_row = counter_row == HEIGHT-1;
			
			reg data_stream_is_finished = 1;
			reg fully_is_finished = 1;
			
			always @(posedge clk)
				begin
				if (reset)
					begin
					current_max <= CURRENT_MAX_INIT;
					counter_anchor <= 0;
					counter_col <= 0;
					counter_row <= 0;
					max_pos_anchor <= 0;
					max_pos_col <= 0;
					max_pos_row <= 0;
					search_mode <= 1;
					out_data <= 0;
					out_data_address <= 0;
					out_data_validity <= 0;
					data_stream_is_finished <= 0;
					fully_is_finished <= 0;
					end
				else if (enable)
					begin
					if (search_mode)
						begin
						// first data is index of anchor
						out_data <= {{(BIT_WIDTH-ANCHOR_CNTR_BITS){1'b0}}, max_pos_anchor};
						out_data_validity <= last_anchor && last_col && last_row && data_in_validity[0];
						end
					else if (!data_stream_is_finished)
						begin
						out_data <= data_in[0];
						out_data_validity <= counter_anchor == max_pos_anchor
											&& counter_col == max_pos_col
											&& counter_row == max_pos_row
											&& data_in_validity[0];
						end
					else if (data_stream_is_finished && !fully_is_finished)
						begin
						out_data_validity <= 1;
						out_data_address <= out_data_address+1;
						
						if ( out_data_address == 5)
							begin
							out_data <= {{(BIT_WIDTH-ROW_CNTR_BITS){1'b0}},max_pos_row};
							end
						else if ( out_data_address == 6)
							begin
							out_data <= {{(BIT_WIDTH-COL_CNTR_BITS){1'b0}},max_pos_col};
							// sending data is completed
							fully_is_finished <= 1;
							end
						end
					else 
						out_data_validity <= 0;
					
					// if (out_data_validity)
					// 	begin
					// 	out_data_address <= out_data_address+1;
					// 	end
					
					if (data_in_validity[0] && !data_stream_is_finished)
						begin
						// counters update
						if (last_col)
							begin
							counter_col <= 0;
							if (last_row)
								begin
								counter_row <= 0;
								if (last_anchor)
									begin
									counter_anchor <= 0;
									// next group == next address
									if (out_data_address == 4) // anchor, xc,yc,w,h are send
										data_stream_is_finished <= 1;
									else
										begin
										// next mode is just taking the values from found maximum
										search_mode <= 0;
										end
									out_data_address <= out_data_address+1;
									end
								else
									counter_anchor <= counter_anchor+1;
								end
							else
								counter_row <= counter_row+1;
							end
						else
							counter_col <= counter_col+1;
						
						if (search_mode)
							begin
							if (is_greater)
								begin
								current_max <= data_in[0];
								max_pos_anchor <= counter_anchor;
								max_pos_col <= counter_col;
								max_pos_row <= counter_row;
								end
							end
						end
					end
				end
			// always end
			
			assign out_data_memory_in = out_data;
			assign out_data_memory_address = out_data_address;
			assign out_data_memory_write_enable = out_data_validity && enable && !reset;
			
			// delay fully_is_finished by write latency
			ResettableDelayLine	#(
								.WIDTH(1),
								.DELAY(WRITE_MEMORY_LATENCY)
								)
								delay_of_is_finished
								(
								.clk(clk),
								.enable(enable),
								.reset(reset),
								
								.data_in(fully_is_finished),
								.data_out(finished)
								);
		end
	else if (PARALLELISM == 5)
		begin
		localparam POS_SIZE = WIDTH*HEIGHT*ANCHORS_NUM;
		localparam POS_BITS = $clog2(POS_SIZE);
		reg [POS_BITS-1:0] pos_cntr = 0;
		reg [POS_BITS-1:0] pos_max = 0;
		reg [BIT_WIDTH-1:0] current_max[PARALLELISM] = {CURRENT_MAX_INIT,0,0,0,0};
		reg search_mode = 1;
		reg is_finished = 0;
		reg [BIT_WIDTH-1:0] out_data = 0;
		reg [ADDR_BITS-1:0] out_address = -1;
		reg out_data_validity = 0;
		reg [ADDR_BITS-1:0] send_cntr = 0;
		
		// compare validity channel values
		wire is_greater;
		if (SIGNED)
			begin
			// convert to signed wires
			wire signed [BIT_WIDTH-1:0] current_max_signed = current_max[0];
			wire signed [BIT_WIDTH-1:0] data_in_signed = data_in[0];
			
			assign is_greater = data_in_signed > current_max_signed;
			end
		else
			assign is_greater = data_in[0] > current_max[0];
		
		// wires for data to be send
		wire [BIT_WIDTH-1:0] local_memory [DESCRIPTION_SIZE];
		
		assign local_memory[0] = current_max[1];
		assign local_memory[1] = current_max[2];
		assign local_memory[2] = current_max[3];
		assign local_memory[3] = current_max[4];
		wire [3*BIT_WIDTH-1:0] wider_pos;
		assign wider_pos[POS_BITS-1:0] = pos_max;
		assign wider_pos[3*BIT_WIDTH-1:POS_BITS] = 0;
		// next 3 bytes are for position
		assign local_memory[4] = wider_pos[23:16];
		assign local_memory[5] = wider_pos[15:8];
		assign local_memory[6] = wider_pos[7:0];
		
		always @(posedge clk)
			begin
			if (reset)
				begin
				pos_cntr <= 0;
				pos_max <= 0;
				// current_max <= {CURRENT_MAX_INIT,0,0,0,0};
				current_max[0] <= CURRENT_MAX_INIT; // only value of validity is needed to be updated
				search_mode <= 1;
				is_finished <= 0;
				out_data_validity <= 0;
				out_address <= -1;
				send_cntr <= 0;
				end
			else
				begin
				// max search state
				if (search_mode)
					begin
					if (data_in_validity[0])
						begin
						// update maximum
						// new max or new run
						if(is_greater || pos_cntr == 0)
							begin
							pos_max <= pos_cntr;
							current_max <= data_in;
							end
						// position counter
						if (pos_cntr == POS_SIZE-1)
							search_mode <= 0;
						else
							pos_cntr <= pos_cntr+1;
						end
					end
				// sending state
				else if (!is_finished)
					begin
					if(send_cntr == DESCRIPTION_SIZE-1)
						is_finished <= 1;
					else
						send_cntr <= send_cntr+1;
					
					out_data <= local_memory[send_cntr];
					out_address <= out_address+1;
					out_data_validity <= 1;
					end
				else
					begin
					out_data_validity <= 0;
					end
				end
			end
		// always end
		
		
		assign out_data_memory_in = out_data;
		assign out_data_memory_address = out_address;
		assign out_data_memory_write_enable = out_data_validity;
		
		// delay fully_is_finished by write latency
		ResettableDelayLine	#(
							.WIDTH(1),
							.DELAY(WRITE_MEMORY_LATENCY)
							)
							delay_of_is_finished
							(
							.clk(clk),
							.enable(enable),
							.reset(reset),
							
							.data_in(is_finished),
							.data_out(finished)
							);
		end
	else
		begin
		$fatal("Parallelism for MaxFinderUnit must be 1 or 5.");
		end
	endgenerate
	
endmodule // MaxFinder



module MemoryWriterSelectorUnit
		#(
		parameter BIT_WIDTH = 8,
		parameter ADDRESS_BITS = 11,
		parameter SOURCES = 2,
		
		localparam SOURCES_BITS = $clog2(SOURCES)
		)
		(
		input clk,
		input [SOURCES_BITS-1:0] select,
		
		input [BIT_WIDTH-1:0] data_in [SOURCES],
		input [ADDRESS_BITS-1:0] data_in_address [SOURCES],
		input data_in_write_enable [SOURCES],
		
		output [BIT_WIDTH-1:0] data_out,
		output [ADDRESS_BITS-1:0] data_out_address,
		output data_out_write_enable
		);
	reg [BIT_WIDTH-1:0] reg_out_data = 0;
	reg [ADDRESS_BITS-1:0] reg_out_data_address = 0;
	reg reg_out_data_write_enable = 0;
	
	always @(posedge clk)
		begin
		reg_out_data <= data_in[select];
		reg_out_data_address <= data_in_address[select];
		reg_out_data_write_enable <= data_in_write_enable[select];
		end
	// always end
	
	assign data_out = reg_out_data;
	assign data_out_address = reg_out_data_address;
	assign data_out_write_enable = reg_out_data_write_enable;
	
endmodule // MemoryWriterSelectorUnit


module MemoryReaderSelectorUnit
		#(
		parameter BIT_WIDTH = 8,
		parameter ADDRESS_BITS = 11,
		parameter SOURCES = 2,
		
		localparam SOURCES_BITS = $clog2(SOURCES)
		)
		(
		input clk,
		input [SOURCES_BITS-1:0] select,
		
		input [ADDRESS_BITS-1:0] data_in_address [SOURCES],
		input data_in_read_enable [SOURCES],
		
		output [ADDRESS_BITS-1:0] data_out_address,
		output data_out_read_enable
		);
	reg [ADDRESS_BITS-1:0] reg_out_data_address = 0;
	
	wire en = data_in_read_enable[select];
	
	always @(posedge clk)
		begin
		if (en)
			begin
			reg_out_data_address <= data_in_address[select];
			end
		end
	// always end
	
	assign data_out_address = reg_out_data_address;
	assign data_out_read_enable = en;
	
endmodule // MemoryWriterSelectorUnit


module InputLayer
		#(
		parameter BIT_WIDTH = 8,
		parameter WIDTH = 200,
		parameter HEIGHT = 100,
		parameter CHANNELS = 3,
		parameter GROUPS = 4,
		parameter WRITE_MEMORY_LATENCY = 2,
		
		localparam ADDRESS_BITS_32 = 32,
		localparam ADDRESS_BITS = $clog2((WIDTH*HEIGHT*CHANNELS)/GROUPS)
		)
		(
		input clk,
		input enable,
		input reset,
		input [GROUPS*BIT_WIDTH-1:0] data_in,
		input data_in_validity,
		
		output [GROUPS*BIT_WIDTH-1:0] data_out,
		output [ADDRESS_BITS_32-1:0] data_out_address,
		output data_out_validity,
		
		output last_data_received,
		output finished
		);
	wire [BIT_WIDTH*GROUPS*CHANNELS-1:0] intermediate_data;
	wire intermediate_validity;
	
	GrouperUnit	#(
				.BIT_WIDTH(BIT_WIDTH*GROUPS),
				.GROUPS(CHANNELS),
				.ENDIANNESS(0) // little endian - oldest at the lowest bytes
				// oldest data (smaller address) at the right
				)
				gu
				(
				.clk(clk),
				.enable(enable),
				.reset(reset),
				.data_in(data_in),
				.data_in_validity(data_in_validity),
				.data_out(intermediate_data),
				.data_out_validity(intermediate_validity)
				);
	
	wire [BIT_WIDTH*GROUPS-1:0] bgr [CHANNELS];
	genvar gen_byte;
	generate
		for(gen_byte = 0; gen_byte < GROUPS*CHANNELS; gen_byte = gen_byte+1)
			begin
			localparam CH = gen_byte % CHANNELS;
			// localparam IDX = gen_byte % GROUPS;
			localparam IDX = gen_byte / CHANNELS;
			assign bgr[CH][(IDX+1)*BIT_WIDTH-1:IDX*BIT_WIDTH] = intermediate_data[(gen_byte+1)*BIT_WIDTH-1:gen_byte*BIT_WIDTH];
			end
		// for end
	endgenerate
	
	wire packed_intermediate_validity [CHANNELS] = {intermediate_validity,
													intermediate_validity,
													intermediate_validity};
	
	wire [ ADDRESS_BITS-1:0] local_out_address;
	
	MuxWriterUnit
			#(
			.BIT_WIDTH(BIT_WIDTH*GROUPS),
			.WIDTH(WIDTH),
			.HEIGHT(HEIGHT),
			.CHANNELS(CHANNELS),
			.GROUPS(GROUPS),
			.PARALLELISM(CHANNELS),
			.REGISTER_FOR_EACH(1),
			// set to 0 to get last written address
			.WRITE_MEMORY_LATENCY(0)
			)
			mwu
			(
			.clk(clk),
			.enable(enable),
			.reset(reset),
			.in_data(bgr),
			.in_data_validity(packed_intermediate_validity),
			.out_data_memory_in(data_out),
			.out_data_memory_address(local_out_address),
			// .out_data_memory_address(data_out_address),
			.out_data_memory_write_enable(data_out_validity),
			.finished(last_data_received)
			);
	assign data_out_address = {{32-ADDRESS_BITS{1'b0}}, local_out_address};
	ResettableDelayLine	#(
						.WIDTH(1),
						.DELAY(WRITE_MEMORY_LATENCY)
						)
						delay_of_finish
						(
						.clk(clk),
						.enable(enable),
						.reset(reset),
						
						.data_in(last_data_received),
						.data_out(finished)
						);
	
endmodule // InputLayer



// AXIS INTERFACES



module ReceiveFromAxis
		#(
		parameter BIT_WIDTH = 32,
		parameter DATA_SIZE = (100*200*3) / 4,
		parameter AXI_SAME_CLK = 1
		)
		(
		input axis_clk,
		input [BIT_WIDTH-1:0] axis_tdata,
		input [3:0] axis_tkeep,
		input axis_tlast,
		input axis_tvalid,
		output axis_tready,
		
		input clk,
		input reset,
		input write_possible,
		output [BIT_WIDTH-1:0] data_out,
		output data_out_validity
		);
	
	localparam CNTR_BITS = $clog2(DATA_SIZE);
	
	generate
		if (AXI_SAME_CLK)
			begin
			reg write_possible_prev = 0;
			reg available_to_write = 0;
			reg [CNTR_BITS-1:0] data_cntr = 0;

			always @(posedge axis_clk)
				begin
				if (reset)
					begin
					write_possible_prev <= 0;
					available_to_write <= 0;
					data_cntr <= 0;
					end
				else
					begin
					if(available_to_write && axis_tvalid)
						begin
						// no more data can be stored
						if (data_cntr == DATA_SIZE-1)
							available_to_write <= 0;
						// increase counter of received data
						else
							data_cntr <= data_cntr+1;
						end
					
					// pos edge of write possible
					if (write_possible && !write_possible_prev)
						begin
						// allow for receiving data
						available_to_write <= 1;
						// reset state
						data_cntr <= 0;
						end
					
					// remember previous state
					write_possible_prev <= write_possible;
					end
					
				end
			
			// when module ready for next data
			assign axis_tready = available_to_write && !reset;
			assign data_out = axis_tdata;
			assign data_out_validity = axis_tvalid && available_to_write && !reset;
			end
	endgenerate
endmodule // ReceiveFromAxis


module SendToAxis
		#(
		parameter AXIS_BIT_WIDTH = 32,
		parameter DATA_BIT_WIDTH = 8,
		parameter DATA_COUNT = 5
		)
		(
		input axis_clk,
		
		output [AXIS_BIT_WIDTH-1:0] axis_tdata,
		output [3:0] axis_tkeep,
		output axis_tlast,
		output axis_tvalid,
		input axis_tready,
		
		input clk,
		input reset,
		
		input data_ready_to_send,
		input [DATA_BIT_WIDTH-1:0] data [DATA_COUNT],
		output data_were_send
		);
	
	localparam DATA_PER_PACKAGE = AXIS_BIT_WIDTH / DATA_BIT_WIDTH;
	localparam PACKAGES_NUM = (DATA_COUNT-1)/DATA_PER_PACKAGE + 1;
	
	wire [AXIS_BIT_WIDTH-1:0] packages [PACKAGES_NUM];
	wire [PACKAGES_NUM*AXIS_BIT_WIDTH-1:0] flatten_data;
	
	genvar gen_i, gen_j;
	generate
		// flatten input data
		for(gen_j = 0; gen_j < DATA_COUNT; gen_j = gen_j+1)
			assign flatten_data[(gen_j+1)*DATA_BIT_WIDTH-1:gen_j*DATA_BIT_WIDTH] = data[gen_j];
		
		// fill remaining part with zeros
		if (DATA_COUNT < PACKAGES_NUM*DATA_PER_PACKAGE)
			begin
			localparam FILLER_BITS = PACKAGES_NUM*DATA_PER_PACKAGE - DATA_COUNT;
			assign flatten_data[(DATA_COUNT+FILLER_BITS)*DATA_BIT_WIDTH-1
								:DATA_COUNT*DATA_BIT_WIDTH] = {FILLER_BITS{1'b0}};
			end
		// for end
		
		// make packages
		for(gen_i = 0; gen_i < PACKAGES_NUM; gen_i = gen_i+1)
			assign packages[gen_i] = flatten_data[(gen_i+1)*AXIS_BIT_WIDTH-1:gen_i*AXIS_BIT_WIDTH];
		// for end
	endgenerate
	
	
	reg sending_status = 0;
	reg data_ready_to_send_prev = 0;
	
	// SEND TO AXIS
	
	localparam PCKG_CNTR_BITS = $clog2(PACKAGES_NUM);
	reg [PCKG_CNTR_BITS-1:0] send_packages_cntr = 0;
	
	reg [AXIS_BIT_WIDTH-1:0] out_data = 0;
	reg is_valid = 0;
	reg is_last = 0;
	
	always @(posedge axis_clk)
		begin
		if (reset)
			begin
			sending_status <= 0;
			data_ready_to_send_prev <= 0;
			is_valid <= 0;
			is_last <= 0;
			end
		else
			begin
			if(data_ready_to_send // 
				// && axis_tready // when receiver is ready for next data
				&& !sending_status // when all data is not send
				&& !is_last)
				begin
				// if (send_packages_cntr == PACKAGES_NUM-1)
				// 	begin
				// 	// set last data flag
				// 	is_last <= 1;
				// 	end
				// else
				// 	send_packages_cntr <= send_packages_cntr+1;
				
				if (axis_tready)
					begin
					if (send_packages_cntr == PACKAGES_NUM-1)
						begin
						// set last data flag
						is_last <= 1;
						end
					else
						send_packages_cntr <= send_packages_cntr+1;
					
					end
				
				is_valid <= 1;
				out_data <= packages[send_packages_cntr];
				end
			else if (is_last && axis_tready)
				begin
				is_last <= 0;
				is_valid <= 0;
				send_packages_cntr <= 0;
				sending_status <= 1;
				end
			
			// CHECK DATA READY FOR SENDING
			// after data sending and when last layer is disabling 
			// neg edge
			// when data are ready to send
			// pos edge
			// => signal change
			if (data_ready_to_send_prev != data_ready_to_send)
				begin
				sending_status <= 0;
				end
			
			// store previous state
			data_ready_to_send_prev <= data_ready_to_send;
			end
		end
	// always end
	
	assign axis_tdata = out_data;
	assign axis_tvalid = is_valid && !reset;
	assign axis_tlast = is_valid && is_last && !reset;
	assign axis_tkeep = {4{1'b1}};
	
	assign data_were_send = sending_status && !reset;
endmodule // SendToAxis


module SendMemoryToAxis
		#(
		parameter DATA_BIT_WIDTH=8,
		parameter MEMORY_READ_LATENCY=2,
		parameter NUMBER_OF_DATA=8,
		
		localparam AXIS_BIT_WIDTH=32,
		localparam ADDR_BITS=$clog2(NUMBER_OF_DATA)
		)
		(
		input axis_clk,
		
		output [AXIS_BIT_WIDTH-1:0] axis_tdata,
		output [3:0] axis_tkeep,
		output axis_tlast,
		output axis_tvalid,
		input axis_tready,
		
		input clk,
		input reset,
		
		input data_ready_to_send,
		// memory interface
		output [ADDR_BITS-1:0] data_addr,
		output read_enable,
		input [DATA_BIT_WIDTH-1:0] data,
		// if sending is finished
		output data_were_send
		);
	reg sending_status = 0;
	reg data_ready_to_send_prev = 0;
	wire data_ready_to_send_edge = data_ready_to_send_prev != data_ready_to_send;
	
	// SEND TO AXIS
	reg [ADDR_BITS-1:0] addr = 0;
	wire addr_valid = !sending_status;
	wire last_addr = addr == NUMBER_OF_DATA-1;
	wire pckg_complete = addr[0] && addr[1];
	reg [AXIS_BIT_WIDTH-1:0] out_data = 0;
	reg is_valid = 0;
	reg is_last = 0;
	
	localparam DATA_PER_PACKAGE = AXIS_BIT_WIDTH/DATA_BIT_WIDTH;
	wire [DATA_BIT_WIDTH-1:0] registers_out [DATA_PER_PACKAGE];
	
	wire step = axis_tready && !sending_status && data_ready_to_send;
	
	ShiftRegisters #(
				   .WIDTH(DATA_BIT_WIDTH),
				   .LENGTH(DATA_PER_PACKAGE)
				   )
				   sr
				   (
				    .clk(axis_clk),
					.data_in(data),
					.step(step),
					.registers_out(registers_out)
				   );
	wire valid, last, complete;
	ResettableDelayLine	#(
						.WIDTH(3),
						.DELAY(MEMORY_READ_LATENCY+1) // +1 for data storing step
						)
						delay_of_is_finished
						(
						.clk(clk),
						.enable(step),
						.reset(reset || data_ready_to_send_edge),
						
						.data_in({addr_valid, last_addr, pckg_complete}),
						.data_out({valid, last, complete})
						);
	
	always @(posedge axis_clk)
		begin
		if (reset)
			begin
			sending_status <= 0;
			data_ready_to_send_prev <= 0;
			is_valid <= 0;
			is_last <= 0;
			addr <= 0;
			end
		else
			begin
			// sending reset for ready state change
			if (data_ready_to_send_edge)
				begin
				sending_status <= 0;
				addr <= 0;
				end
			else if(data_ready_to_send // 
				// && axis_tready // when receiver is ready for next data
				&& !sending_status // when all data is not send
				&& axis_tready)
				begin
				if (!is_last)
					begin
					addr <= addr+1;
					end
				end
			else if(axis_tready && last_addr)
				begin
				sending_status <= 1;
				addr <= 0;
				end
			
			// store previous state
			data_ready_to_send_prev <= data_ready_to_send;
			end
		end
	// always end
	
	genvar gen_pckg;
	generate
		for(gen_pckg = 0; gen_pckg < DATA_PER_PACKAGE; gen_pckg = gen_pckg+1)
			assign axis_tdata[DATA_BIT_WIDTH*(gen_pckg+1)-1:DATA_BIT_WIDTH*gen_pckg] 
					= registers_out[DATA_PER_PACKAGE-gen_pckg-1];
	endgenerate
	assign axis_tkeep = 4'b1111;
	assign axis_tlast = last && valid && !sending_status && !reset;
	assign axis_tvalid = valid && !sending_status && !reset;
	
	assign data_were_send = sending_status && !reset;
	assign data_addr = addr;
	assign read_enable = step;
endmodule // SendMemoryToAxis


module SaveToFile
		#(
		parameter DATA_WIDTH=1000,
		parameter PATH="",
		parameter PERIOD=1000
		)
		(
		input clk,
		input [DATA_WIDTH-1:0] data,
		input save
		);
	
	string format;
	int idx = 0; 
	int file = 0;
	int i = 0;
	
	initial
		begin
		forever
			begin
			while(1)
				begin	
				$sformat(format, PATH, idx);
				file = $fopen(format, "a");
				
				for(i = 0; i < PERIOD; i = i+1)
					begin
					if ( save )
						break;
					
					@(posedge clk);
					$fdisplayb(file, data);
					end
				// for end
				
				$fclose(file);
				if ( save )
					break;
				end
			
			wait(!save)
			// update cntr
			idx = idx+1;
			end
		end
	
	
endmodule // SaveToFile

