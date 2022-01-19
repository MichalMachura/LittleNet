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
reg enable = 0;

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

initial
    begin
    for(int i = 0; i < 5; i = i + 1)
        begin
        @(posedge clk);
        wait(clk);
        end
    enable <= 1;
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

ROM
    #(
    .LEN(LEN),
    .DATA_WIDTH(8),
    .init_file_name("rom_xd.mem"),
    .LATENCY(2),
    .USE_SLEEP(1),
    // .PRIMITIVE_TYPE("distributed")
    // .PRIMITIVE_TYPE("auto")
    .PRIMITIVE_TYPE("block")
    ) 
    ROM_inst 
    (
    .sleep(1'b0),
    .clka(clk),
    .ena(enable),
    .addra({{(32-ADDR_WIDTH){1'b0}},cntr}),
    .douta(douta)
    );


wire [31:0] dina = {douta,douta,douta,douta};
wire [7:0] doutb;

SDP_RAM
    #(
    .BYTE_LEN(LEN),
    .READ_WIDTH(8),
    .WRITE_WIDTH(32),
    .READ_LATENCY(2),
    .USE_SLEEP(1)
    ) 
    SDP_RAM_inst 
    (
    .sleep(1'b0),
    
    .clka(clk),
    .ena(enable),
    .wea(enable),
    .addra({{(32-ADDR_WIDTH+2){1'b0}},cntr[ADDR_WIDTH-1:2]}),
    .dina(dina),
    
    .clkb(clk),
    .enb(enable),
    .addrb({{(32-ADDR_WIDTH){1'b0}},cntr}),
    .doutb(doutb)
    );


endmodule
