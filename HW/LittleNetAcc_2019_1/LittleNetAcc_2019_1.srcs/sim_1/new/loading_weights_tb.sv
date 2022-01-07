`timescale 1ns / 1ps


module LoadingWeightsUnit_tb();
	localparam WIDTH = 8;
	localparam ADDR_BITS = 11;
	localparam BATCH_SIZE = 9;
	// CLOCK GENERATOR
	reg clk = 1'b0;
	initial 
		begin
		clk <= 1'b0;
		#1;
		forever
			begin
			#1; clk <= 1'b1;
			#1; clk <= 1'b0;
			end
		end
		
	wire is_weights_loading;
	reg [8:0] cntr = 0;
	always @(posedge clk)
		begin
		if (!is_weights_loading)
			cntr <= cntr+1;
		end
	// always end
	
	wire next, reset;
	wire [WIDTH-1:0] data_out;
	wire [ADDR_BITS-1:0] addr_in;
	wire read_enable;
	wire [WIDTH-1:0] weights [BATCH_SIZE]; 
	assign next = cntr == 9'd255;
	assign reset = cntr == 9'd511;
	
	LoadingWeightsUnit #(
						.BIT_WIDTH(WIDTH),
						.BATCH_SIZE(BATCH_SIZE),
						.MEMORY_WEIGHTS_SIZE(2*BATCH_SIZE),
						.ADDRESS_BITS(ADDR_BITS),
						.READ_MEMORY_LATENCY(2)
						)
						LWU
						(
						.clk(clk),
						.weights_memory_out(data_out),
						.weights_memory_address(addr_in),
						.weights_memory_read_enable(read_enable),
						.enable(1'b1),
						.reset(reset),
						.next_batch(next),
						.weights(weights),
						.is_weights_loading(is_weights_loading)
						);
	
	
	 ROM_8b_11addr_2048_elem ROM(
	 						   .clka(clk),
	 						   .ena(read_enable),
	 						   .addra(addr_in),
	 						   .douta(data_out),
	 						   .sleep(1'b0)
	 						   );

endmodule // LoadingWeightsUnit_tb

