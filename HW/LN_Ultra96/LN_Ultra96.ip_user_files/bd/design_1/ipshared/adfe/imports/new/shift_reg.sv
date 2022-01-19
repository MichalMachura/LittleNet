`timescale 1ns / 1ps


module ShiftRegisters
		#(
		 parameter WIDTH = 8,
		 parameter LENGTH = 9
		 )
		 (
		 input clk,
		 input step,
		 input [WIDTH-1:0] data_in,
		 
		 output [WIDTH-1:0] registers_out [LENGTH]
		 );
	
	reg [WIDTH-1:0] registers [LENGTH];
	
	// integer k;
	initial 
		begin
		for (integer k = 0; k < LENGTH; k = k+1 )
			begin
			registers[k] = 0;
			end
		end
	
	always @(posedge clk)
		begin
		if (step)
			begin
			registers[0] <= data_in;
			
			for (integer j = 1; j < LENGTH; j = j+1)
				begin
				registers[j] <= registers[j-1];
				end
			end
		end
	// always end
	
	genvar i;
	generate
		for (i = 0; i < LENGTH; i = i+1)
			assign registers_out[i] = registers[i];
	endgenerate
	
	

endmodule // ShiftRegisters
