`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2022 09:57:36 PM
// Design Name: 
// Module Name: custom_ROM
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


module CustomROM
    #(
    parameter LEN = 2048,
    parameter DATA_WIDTH = 8,
    parameter init_file_name = "rom_xd.mem",
    parameter LATENCY = 2)
    (
    input sleep,
    
    input clka,
    input ena,
    input [31:0] addra,
    output [DATA_WIDTH-1:0] douta
    );
localparam ADDR_WIDTH = $clog2(LEN);


wire sbiterra,dbiterra;
wire [ADDR_WIDTH-1:0] local_addra = addra[ADDR_WIDTH-1:0];

xpm_memory_sprom #(
      .ADDR_WIDTH_A(ADDR_WIDTH),              // DECIMAL
      .AUTO_SLEEP_TIME(2),           // DECIMAL
      .CASCADE_HEIGHT(0),            // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE(init_file_name),     // String
      .MEMORY_INIT_PARAM(""),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("auto"),     // String
      .MEMORY_SIZE(DATA_WIDTH*LEN),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(DATA_WIDTH),        // DECIMAL
      .READ_LATENCY_A(LATENCY),            // DECIMAL
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(1),              // DECIMAL
      .WAKEUP_TIME("use_sleep_pin")  // String
   )
   inside_ROM_blk (
      .dbiterra(dbiterra),             // 1-bit output: Leave open.
      .douta(douta),                   // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
      .sbiterra(sbiterra),             // 1-bit output: Leave open.
      .addra(local_addra),                   // ADDR_WIDTH_A-bit input: Address for port A read operations.
      .clka(clka),                     // 1-bit input: Clock signal for port A.
      .ena(ena),                       // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when read operations are initiated. Pipelined internally.

      .injectdbiterra(1'b0), // 1-bit input: Do not change from the provided value.
      .injectsbiterra(1'b0), // 1-bit input: Do not change from the provided value.
      .regcea(1'b1),                 // 1-bit input: Do not change from the provided value.
      .rsta(1'b0),                     // 1-bit input: Reset signal for the final port A output register stage.
                                       // Synchronously resets output port douta to the value specified by
                                       // parameter READ_RESET_VALUE_A.

      .sleep(sleep)                    // 1-bit input: sleep signal to enable the dynamic power saving feature.
   );
   
endmodule