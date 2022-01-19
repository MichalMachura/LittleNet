`timescale 1ns / 1ps


module tb_DelayLine ();

	localparam WIDTH = 8;
	localparam DELAY1 = 0;
	localparam DELAY2 = 1;
	localparam DELAY3 = 5;
	
	wire [WIDTH-1:0] IN, OUT1, OUT2, OUT3;
	reg clk = 1'b0;
	reg [WIDTH-1:0] counter = 0;
	
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
	
	always @(posedge clk) 
		begin
		counter <= counter + 1;
		end
	
	assign IN = counter;
	
	DelayLine #(.WIDTH(WIDTH), .DELAY(DELAY1)) d1 (.clk(clk), .enable(1), .data_in(IN), .data_out(OUT1));
	DelayLine #(.WIDTH(WIDTH), .DELAY(DELAY2)) d2 (.clk(clk), .enable(0), .data_in(IN), .data_out(OUT2));
	DelayLine #(.WIDTH(WIDTH), .DELAY(DELAY3)) d3 (.clk(clk), .enable(1), .data_in(IN), .data_out(OUT3));
	
endmodule