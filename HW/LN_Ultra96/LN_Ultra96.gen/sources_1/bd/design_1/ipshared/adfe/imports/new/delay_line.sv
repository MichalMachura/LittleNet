`timescale 1ns / 1ps


module DelayRegister
        #(
         parameter WIDTH=8
         )
         (
         input clk,
         input enable,
         input [WIDTH-1:0] data_in,
         output [WIDTH-1:0] data_out
         );
    reg [WIDTH-1:0] local_memory = 0;
    
    always @(posedge clk )
        begin
        if (enable)
            // update local memory
            local_memory <= data_in;
        end
    // output as local memory storage value
    assign data_out = local_memory;
 
endmodule


module DelayLine 
       #(
        parameter WIDTH=8, 
        parameter DELAY=0
        )
        (
        input clk,
        input enable,
        input [WIDTH-1:0] data_in,
        output [WIDTH-1:0] data_out
        );

    wire [WIDTH-1:0] chains [DELAY:0];
    
	// assign input data to first chain
	assign chains[0] = data_in;
	
    genvar i;
    generate
		// connect intermediate registers by chains
		for (i=0; i < DELAY; i = i+1)
			begin
			DelayRegister #(.WIDTH(WIDTH)) 
                         r(
                          .clk(clk), 
                          .enable(enable), 
                          .data_in(chains[i]), 
                          .data_out(chains[i+1])
                          );
			end
	endgenerate
	
	// assign last chain to output of delay block
	assign data_out = chains[DELAY];
	
endmodule


module ResettableDelayRegister
        #(
         parameter WIDTH=8
         )
         (
         input clk,
         input enable,
		 input reset,
         input [WIDTH-1:0] data_in,
         output [WIDTH-1:0] data_out
         );
    reg [WIDTH-1:0] local_memory = 0;
    
    always @(posedge clk )
        begin
		if (reset)
			begin
			local_memory <= 0;
			end
        else if (enable)
            // update local memory
            local_memory <= data_in;
        end
    // output as local memory storage value
    assign data_out = local_memory;
 
endmodule


module ResettableDelayLine
       #(
        parameter WIDTH=8, 
        parameter DELAY=0
        )
        (
        input clk,
        input enable,
		input reset,
        input [WIDTH-1:0] data_in,
        output [WIDTH-1:0] data_out
        );

    wire [WIDTH-1:0] chains [DELAY:0];
    
	// assign input data to first chain
	assign chains[0] = data_in;
	
    genvar i;
    generate
		// connect intermediate registers by chains
		for (i=0; i < DELAY; i = i+1)
			begin
			ResettableDelayRegister #(.WIDTH(WIDTH)) 
                         r(
                          .clk(clk),
						  .reset(reset),
                          .enable(enable), 
                          .data_in(chains[i]), 
                          .data_out(chains[i+1])
                          );
			end
	endgenerate
	
	// assign last chain to output of delay block
	assign data_out = chains[DELAY];
	
endmodule
