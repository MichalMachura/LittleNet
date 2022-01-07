`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2022 10:34:34 PM
// Design Name: 
// Module Name: CustomROM_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CustomROM_tb(
    );
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
		
localparam LEN = 2048;
localparam ADDR_WIDTH = $clog2(LEN);

reg [ADDR_WIDTH-1:0] cntr = 0;
always @(posedge clk)
    begin
    cntr <= cntr+1;
    end
// always end
wire [7:0] douta;

CustomROM
    #(
    .LEN(LEN),
    .DATA_WIDTH(8),
    .init_file_name("rom_xd.mem"),
    .LATENCY(2)
    ) 
    ROM_inst 
    (
    .sleep(1'b0),
    .clka(clk),
    .ena(1'b1),
    .addra({{(32-ADDR_WIDTH){1'b0}},cntr}),
    .douta(douta)
    );

endmodule
