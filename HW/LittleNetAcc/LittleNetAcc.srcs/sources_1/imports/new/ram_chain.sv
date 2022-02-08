
module BASE_RAM 
    #(
    parameter LEN = 1024,
    parameter WIDTH = 32,
    localparam ADDR_BITS = $clog2(LEN)
    )
    (
    input clk,
    
    input ena,
    input wea,
    input [ADDR_BITS-1:0] addra,
    input [WIDTH-1:0] dina,
    
    input enb,
    input [ADDR_BITS-1:0] addrb,
    output [WIDTH-1:0] doutb
    );
(*ram_style="block"*)
reg [WIDTH-1:0] memo [LEN-1:0];

reg [ADDR_BITS-1:0] addra_reg = 0;
reg [ADDR_BITS-1:0] addrb_reg = 0;
reg [WIDTH-1:0] dina_reg = 0;
reg [WIDTH-1:0] doutb_reg = 0;

assign doutb = doutb_reg;

always @(posedge clk) 
    begin
    if(ena)
        begin
        if (wea)
            begin
            addra_reg <= addra;
            dina_reg <= dina;
            end
        
        memo[addra_reg] <= dina_reg;
        end
    
    if (enb)
        begin
        addrb_reg <= addrb;
        doutb_reg <= memo[addrb_reg];
        end
    end
endmodule


module CASCADED_RAM
      #(
      parameter BYTE_LEN = 2048,
      parameter WRITE_WIDTH = 32,
      parameter READ_WIDTH = 8,
      parameter BYTE_SIZE = 8,
      parameter READ_LATENCY = 2,
      parameter WRITE_LATENCY = 2,
      parameter INIT_FILE_FORMAT = "ram_%02d.mem"
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
      output [READ_WIDTH-1:0] doutb
      );
// localparam ADDRA_WIDTH = $clog2(BYTE_LEN / (WRITE_WIDTH / BYTE_SIZE));
// localparam ADDRB_WIDTH = $clog2(BYTE_LEN / (READ_WIDTH / BYTE_SIZE));
// number of 4 bytes cells  
localparam DATA_WIDTH = WRITE_WIDTH;
localparam DATA_BYTES = WRITE_WIDTH / BYTE_SIZE;
localparam LEN = (BYTE_LEN-1)/DATA_BYTES + 1;
localparam ADDR_DATA_BYTE = 2;

localparam SINGLE_LEN = 1024;
localparam SINGLE_BRAM_ADDR_BITS = $clog2(SINGLE_LEN);
localparam BLOCKS_NUM = (LEN-1)/SINGLE_LEN + 1;
localparam BLOCKS_ADDR_WIDTH = $clog2(BLOCKS_NUM);
localparam ALIGNED_BLOCKS_NUM = 2**BLOCKS_ADDR_WIDTH;
localparam TREE_DEPTH = BLOCKS_ADDR_WIDTH;

localparam MIN_READ_LATENCY = 2 // bram read latency
                          + TREE_DEPTH
                          + 1 // word select
                          + 1; // byte select
localparam MIN_WRITE_LATENCY = 2 // bram read latency
                               + TREE_DEPTH;
localparam ALIGN_READ_LATENCY = READ_LATENCY - MIN_READ_LATENCY;
localparam ALIGN_WRITE_LATENCY = WRITE_LATENCY - MIN_WRITE_LATENCY;

initial 
    begin
    if (ALIGN_READ_LATENCY < 0)
        $error("ALIGN_READ_LATENCY < 0",$TIME);

    if (ALIGN_WRITE_LATENCY < 0)
        $error("ALIGN_WRITE_LATENCY < 0",$TIME);
    end

// port b - read
wire [SINGLE_BRAM_ADDR_BITS-1:0] single_bram_addrb = addrb[SINGLE_BRAM_ADDR_BITS+ADDR_DATA_BYTE-1:ADDR_DATA_BYTE];
wire [DATA_WIDTH-1:0] chain_doutb [TREE_DEPTH:0][ALIGNED_BLOCKS_NUM-1:0];
// port a - write
wire [DATA_WIDTH-1:0] chain_dina [TREE_DEPTH:0];
wire [31:0] chain_addra [TREE_DEPTH:0];
wire chain_wea [TREE_DEPTH:0][ALIGNED_BLOCKS_NUM-1:0];

// delay write signals
DelayLine 
    #(
    .WIDTH(DATA_WIDTH+32+1),
    .DELAY(ALIGN_WRITE_LATENCY)
    ) 
    write_signals_alignment 
    (
    .clk(clka),
    .enable(ena),
    .data_in({dina,addra,wea}), 
    .data_out({chain_dina[0],chain_addra[0],chain_wea[0][0]})
    );

// write
genvar gen_tree_idx, gen_width_idx; 
generate
for (gen_tree_idx = 0; gen_tree_idx < TREE_DEPTH; gen_tree_idx = gen_tree_idx+1)
    begin
    localparam TREE_WIDTH_IN = 2**gen_tree_idx;
    localparam TREE_WIDTH_OUT = TREE_WIDTH_IN * 2;
    wire selector_bit = chain_addra[gen_tree_idx][ (TREE_DEPTH-1 - gen_tree_idx) // bit in bram tree
                              +SINGLE_BRAM_ADDR_BITS];// after last in bram address bit 
    
    for (gen_width_idx = 0; gen_width_idx < TREE_WIDTH_IN; gen_width_idx = gen_width_idx+1 )
        begin
        wire prev_we = chain_wea[gen_tree_idx][gen_width_idx];
        wire higher_we = prev_we && selector_bit;
        wire lower_we = prev_we && !selector_bit;
        DelayLine 
            #(
            .WIDTH(DATA_WIDTH+32+1+1),// next depth have one more we
            .DELAY(1)
            ) 
            tree_write_demux
            (
            .clk(clka),
            .enable(ena),
            .data_in({chain_dina[gen_tree_idx],
                      chain_addra[gen_tree_idx],
                      lower_we,
                      higher_we
                      }), 
            .data_out({chain_dina[gen_tree_idx+1],
                       chain_addra[gen_tree_idx+1],
                       chain_wea[gen_tree_idx+1][2*gen_width_idx],
                       chain_wea[gen_tree_idx+1][2*gen_width_idx+1]
                       })
            );
        end
    end
endgenerate


// GENERATE RAMs PRIMITIVES
genvar gen_blk_idx; 
generate
for (gen_blk_idx = 0; gen_blk_idx < ALIGNED_BLOCKS_NUM; gen_blk_idx = gen_blk_idx + 1) 
    begin
    if (gen_blk_idx < BLOCKS_NUM)
        begin          
        wire dbiterra, sbiterra;
        wire ena_bram = ena;
        wire wea_bram = chain_wea[TREE_DEPTH][gen_blk_idx];
        wire [SINGLE_BRAM_ADDR_BITS-1:0] addra_bram = chain_addra[TREE_DEPTH];
        wire [DATA_WIDTH-1:0] data_in_bram = chain_dina[TREE_DEPTH];
        wire [DATA_WIDTH-1:0] data_out_bram;
        
        xpm_memory_sdpram 
            #(
            .ADDR_WIDTH_A(SINGLE_BRAM_ADDR_BITS),               // DECIMAL
            .ADDR_WIDTH_B(SINGLE_BRAM_ADDR_BITS),               // DECIMAL
            .AUTO_SLEEP_TIME(0),            // DECIMAL
            .BYTE_WRITE_WIDTH_A(DATA_WIDTH),        // DECIMAL
            .CASCADE_HEIGHT(0),             // DECIMAL
            .CLOCKING_MODE("common_clock"), // String
            .ECC_MODE("no_ecc"),            // String
            .MEMORY_INIT_FILE($sformatf(INIT_FILE_FORMAT, gen_blk_idx)),      // String
            .MEMORY_INIT_PARAM("0"),        // String
            .MEMORY_OPTIMIZATION("true"),   // String
            // .MEMORY_PRIMITIVE("auto"),      // String
            .MEMORY_PRIMITIVE("block"),      // String
            .MEMORY_SIZE(SINGLE_LEN*DATA_WIDTH),             // DECIMAL
            .MESSAGE_CONTROL(0),            // DECIMAL
            .READ_DATA_WIDTH_B(DATA_WIDTH),         // DECIMAL
            .READ_LATENCY_B(2),             // DECIMAL
            .READ_RESET_VALUE_B("0"),       // String
            .RST_MODE_A("SYNC"),            // String
            .RST_MODE_B("SYNC"),            // String
            .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
            // .USE_MEM_INIT(0),               // DECIMAL
            .USE_MEM_INIT(1),               // DECIMAL
            .WAKEUP_TIME("disable_sleep"),  // String
            .WRITE_DATA_WIDTH_A(DATA_WIDTH),        // DECIMAL
            .WRITE_MODE_B("read_first")      // String
            )
            internal_ram 
            (
            .dbiterrb(dbiterrb),
            .sbiterrb(sbiterrb),
            .injectdbiterra(1'b0),
            .injectsbiterra(1'b0),
            .sleep(1'b0),
            .rstb(1'b0),
            // write
            .clka(clka),
            .ena(ena_bram),
            .wea(wea_bram),
            .addra(addra_bram),
            .dina(data_in_bram),
            //read
            .clkb(clkb),
            .enb(enb),
            .addrb(single_bram_addrb),
            .doutb(data_out_bram),
            .regceb(enb)
            );
        
        // BASE_RAM 
        //     internal_own_ram
        //     (
        //     .clk(clka),
        //     .ena(ena_bram),
        //     .wea(wea_bram),
        //     .addra(addra_bram),
        //     .dina(data_in_bram),
        //     .enb(enb),
        //     .addrb(single_bram_addrb),
        //     .doutb(data_out_bram)
        //     );
        
        assign chain_doutb[0][gen_blk_idx] = data_out_bram;
        end
    else
        begin
        // assign to -1
        assign chain_doutb[0][gen_blk_idx] = {(DATA_WIDTH){1'b0}}; 
        end
    end
endgenerate

// read 
generate
for (gen_tree_idx = 0; gen_tree_idx < TREE_DEPTH; gen_tree_idx = gen_tree_idx+1)
    begin
    localparam TREE_WIDTH_IN = ALIGNED_BLOCKS_NUM / (2**gen_tree_idx);
    localparam TREE_WIDTH_OUT = TREE_WIDTH_IN / 2;
    wire addr_bit = addrb[SINGLE_BRAM_ADDR_BITS + gen_tree_idx + ADDR_DATA_BYTE];
    wire selector_bit;
    DelayLine 
        #(
        .WIDTH(1), 
        .DELAY(2+gen_tree_idx)
        ) 
        addr_bit_delay 
        (
        .clk(clkb),
        .enable(enb),
        .data_in(addr_bit), 
        .data_out(selector_bit)
        );
	
    for (gen_width_idx = 0; gen_width_idx < TREE_WIDTH_OUT; gen_width_idx = gen_width_idx+1 )
        begin
        MUX_REG
            #(
            .DATA_WIDTH(DATA_WIDTH)
            )
            internal_mux_read
            (
            .clka(clkb),
            .ena(enb),
            .selector(selector_bit),
            .dina_0(chain_doutb[gen_tree_idx][2*gen_width_idx]),
            .dina_1(chain_doutb[gen_tree_idx][2*gen_width_idx+1]),
            .douta(chain_doutb[gen_tree_idx+1][gen_width_idx])
            );
        end
    end
endgenerate
// double word data - little endian
wire [DATA_WIDTH-1:0] doutb_double_word = chain_doutb[TREE_DEPTH][0];
// select word from 4 byte data
wire [DATA_WIDTH/2-1:0] doutb_word;
wire addrb_word_bit = addrb[1];
wire word_selector;
DelayLine 
        #(
        .WIDTH(1), 
        .DELAY(2+TREE_DEPTH)
        )
        word_addr_bit_delay
        (
        .clk(clkb),
        .enable(enb),
        .data_in(addrb_word_bit), 
        .data_out(word_selector)
        );
// word select
MUX_REG
    #(
    .DATA_WIDTH(DATA_WIDTH/2)
    )
    internal_mux_read_word
    (
    .clka(clkb),
    .ena(enb),
    .selector(word_selector),
    .dina_0(doutb_double_word[DATA_WIDTH/2-1:0]),
    .dina_1(doutb_double_word[DATA_WIDTH-1:DATA_WIDTH/2]),
    .douta(doutb_word)
    );
    
// select byte from 2 byte data
wire [DATA_WIDTH/4-1:0] doutb_byte;
wire addrb_byte_bit = addrb[0];
wire byte_selector;
DelayLine 
        #(
        .WIDTH(1), 
        .DELAY(2+TREE_DEPTH+1) // delayed also by word selection
        )
        byte_addr_bit_delay
        (
        .clk(clkb),
        .enable(enb),
        .data_in(addrb_byte_bit), 
        .data_out(byte_selector)
        );
// byte select
MUX_REG
    #(
    .DATA_WIDTH(DATA_WIDTH/4)
    )
    internal_mux_read_byte
    (
    .clka(clkb),
    .ena(enb),
    .selector(byte_selector),
    .dina_0(doutb_word[DATA_WIDTH/4-1:0]),
    .dina_1(doutb_word[DATA_WIDTH/2-1:DATA_WIDTH/4]),
    .douta(doutb_byte)
    );

// delay output to achieve given read latency
DelayLine 
        #(
        .WIDTH(DATA_WIDTH/4), 
        .DELAY(ALIGN_READ_LATENCY)
        )
        output_latency_alignment
        (
        .clk(clkb),
        .enable(enb),
        .data_in(doutb_byte), 
        .data_out(doutb)
        );

endmodule
