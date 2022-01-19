`timescale 1ns / 1ps


module shift_reg_tb();

	localparam ADDR_W = 11;
	localparam DATA_WIDTH = 8;
	
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
	
	reg [ADDR_W-1:0] addr_in = 0;
	
	always @(posedge clk)
		begin
		addr_in <= addr_in+1;
		end
	// always end
	
	wire [DATA_WIDTH-1:0] data_out;
	
	// ROM_8b_11addr_2048_elem ROM(
	// 						   .clka(clk),
	// 						   .ena(1'b1),
	// 						   .addra(addr_in),
	// 						   .douta(data_out),
	// 						   .sleep(1'b0)
	// 						   );
	
	wire [DATA_WIDTH-1:0] registers_out [11];
	wire step = data_out[0]; // shift when present odd value
	
	ShiftRegisters #(
				   .WIDTH(DATA_WIDTH),
				   .LENGTH(11)
				   )
				   sr
				   (
				    .clk(clk),
					.data_in(data_out),
					.step(step),
					.registers_out(registers_out)
				   );
	
endmodule
