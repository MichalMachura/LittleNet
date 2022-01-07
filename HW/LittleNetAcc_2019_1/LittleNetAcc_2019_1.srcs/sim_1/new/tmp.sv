`timescale 1ns / 1ns


module Tmp_tb
		(
		);
	
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
		
	reg [7:0] cntr = 0;
	always @(posedge clk)
		begin
        cntr <= cntr+1;
		end
	// always end
	
	wire [127:0] rom_0_0_douta;
	wire rom_0_0_ena = 1;
	
	ROM_PW_1_1 ROM_1_1
			(
			.clka(clk),
			.sleep(0),
			.addra(cntr),
			.douta(rom_0_0_douta),
			.ena(rom_0_0_ena)
			);
	
	wire [7:0] douta[16];
	genvar gen_i;
	generate
		for(gen_i = 0; gen_i < 16; gen_i = gen_i+1)
			begin
			assign douta[16-gen_i-1] = rom_0_0_douta[(gen_i+1)*8-1:gen_i*8];
			end
		// for end
	endgenerate
/*
00001011
00000010
00000111
11111011
11111111
11111100
11111110
00000110
11110101
00001010
11111111
11111011
00000000
00011001
00000111
11111100
*/
endmodule // Tmp_tb


