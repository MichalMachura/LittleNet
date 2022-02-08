
module InputLayer
		#(
		parameter BIT_WIDTH = 8,
		parameter WIDTH = 200,
		parameter HEIGHT = 100,
		parameter CHANNELS = 3,
		parameter GROUPS = 4,
		parameter WRITE_MEMORY_LATENCY = 2,
		
        localparam INPUT_SIZE = WIDTH*HEIGHT*CHANNELS/GROUPS,
		localparam ADDRESS_BITS_32 = 32,
		localparam ADDRESS_BITS = $clog2(INPUT_SIZE)
		)
		(
		input clk,
		input enable,
		input reset,
		
        input [31:0] axis_tdata,
        input [3:0] axis_tkeep,
        input axis_tlast,
        input axis_tvalid,
        output axis_tready,
        
		output [GROUPS*BIT_WIDTH-1:0] data_out,
		output [ADDRESS_BITS_32-1:0] data_out_address,
		output data_out_validity,
		
		output finished
		);
    
    wire last_data_received;
    wire write_possible = enable && !reset && !last_data_received;
	wire data_in_validity;
	wire [31:0] data_in;
	ReceiveFromAxis #(
					.BIT_WIDTH(BIT_WIDTH*GROUPS),
					// .DATA_SIZE((112*208*3) / 4),
					.DATA_SIZE(INPUT_SIZE),
					.AXI_SAME_CLK(1)
					)
					receiver
					(
					.axis_clk(clk),
					.axis_tdata(axis_tdata),
					.axis_tkeep(axis_tkeep),
					.axis_tlast(axis_tlast),
					.axis_tvalid(axis_tvalid),
					.axis_tready(axis_tready),
					
					.clk(clk),
					.reset(reset),
					
					.write_possible(write_possible),
					.data_out(data_in),
					.data_out_validity(data_in_validity)
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


