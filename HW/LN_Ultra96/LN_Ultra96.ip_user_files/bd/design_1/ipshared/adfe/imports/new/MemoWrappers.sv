`timescale 1ns / 1ps

module ROM
      #(
      parameter LEN = 2048,
      parameter DATA_WIDTH = 8,
      parameter init_file_name = "rom_hex_white_spaced_file_name.mem",
      parameter LATENCY = 2,
      parameter USE_SLEEP = 1,
      parameter MEMO_TYPE = "auto"
      )
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


wire local_sleep;
generate
if(MEMO_TYPE == "block")
   assign local_sleep = sleep;
else
   assign local_sleep = 1'b0;
endgenerate

xpm_memory_sprom #(
      .ADDR_WIDTH_A(ADDR_WIDTH),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .CASCADE_HEIGHT(0),            // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE(init_file_name),     // String
      .MEMORY_INIT_PARAM(""),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE(MEMO_TYPE),     // String
      .MEMORY_SIZE(DATA_WIDTH*LEN),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(DATA_WIDTH),        // DECIMAL
      .READ_LATENCY_A(LATENCY),            // DECIMAL
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(1),              // DECIMAL
      .WAKEUP_TIME(USE_SLEEP ? "use_sleep_pin" : "disable_sleep")  // String
   )
   inside_ROM_blk (
      .dbiterra(dbiterra),
      .douta(douta),
      .sbiterra(sbiterra),
      .addra(local_addra),
      .clka(clka),
      .ena(ena),
      .injectdbiterra(1'b0),
      .injectsbiterra(1'b0),
      .regcea(1'b1),
      .rsta(1'b0),
      .sleep(local_sleep)
   );
   
endmodule


module SDP_RAM
      #(
      parameter BYTE_LEN = 2048,
      parameter WRITE_WIDTH = 32,
      parameter READ_WIDTH = 8,
      parameter BYTE_SIZE = 8,
      parameter READ_LATENCY = 2,
      parameter USE_SLEEP = 1
      )
      (
      input clka,
      input ena,
      input wea,
      input [31:0] addra,
      input [WRITE_WIDTH-1:0] dina,

      input clkb,
      input enb,
      input [31:0] addrb,
      output [READ_WIDTH-1:0] doutb,

      input sleep
      );
   localparam ADDRA_WIDTH = $clog2(BYTE_LEN / (WRITE_WIDTH / BYTE_SIZE));
   localparam ADDRB_WIDTH = $clog2(BYTE_LEN / (READ_WIDTH / BYTE_SIZE));

   wire sbiterrb,dbiterrb;
   wire [ADDRA_WIDTH-1:0] local_addra = addra[ADDRA_WIDTH-1:0];
   wire [ADDRB_WIDTH-1:0] local_addrb = addrb[ADDRB_WIDTH-1:0];

   xpm_memory_sdpram #(
      .ADDR_WIDTH_A(ADDRA_WIDTH),               // DECIMAL
      .ADDR_WIDTH_B(ADDRB_WIDTH),               // DECIMAL
      .AUTO_SLEEP_TIME(0),            // DECIMAL
      .BYTE_WRITE_WIDTH_A(WRITE_WIDTH),        // DECIMAL
      .CASCADE_HEIGHT(0),             // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      .ECC_MODE("no_ecc"),            // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      // .MEMORY_PRIMITIVE("auto"),      // String
      .MEMORY_PRIMITIVE("block"),      // String
      .MEMORY_SIZE(BYTE_LEN*BYTE_SIZE),             // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_B(READ_WIDTH),         // DECIMAL
      .READ_LATENCY_B(READ_LATENCY),             // DECIMAL
      .READ_RESET_VALUE_B("0"),       // String
      .RST_MODE_A("SYNC"),            // String
      .RST_MODE_B("SYNC"),            // String
      .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(0),               // DECIMAL
      .WAKEUP_TIME(USE_SLEEP? "use_sleep_pin" : "disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(WRITE_WIDTH),        // DECIMAL
      .WRITE_MODE_B("read_first")      // String
   )
   xpm_memory_sdpram_inst (
      .dbiterrb(dbiterrb),
      .sbiterrb(sbiterrb),
      
      .clka(clka),
      .ena(ena),
      .wea(wea),
      .addra(local_addra),
      .dina(dina),
      
      .clkb(clkb),
      .enb(enb),
      .addrb(local_addrb),
      .doutb(doutb),
      
      .injectdbiterra(1'b0),
      .injectsbiterra(1'b0),
      
      .sleep(sleep),                   
      
      .regceb(1'b1),                
      .rstb(1'b0)          
   );

endmodule


