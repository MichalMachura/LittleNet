`timescale 1ns / 1ps

module BROM
		#(
		 parameter path="",
		 parameter WIDTH=8,
		 parameter DEPTH=1,
		 parameter ADDR_BITS=1,
		 localparam LATENCY = 2,
		 localparam ADDRESS_BITS = $clog2(DEPTH)
		 )
		 (
		 input clka,
		 input ena,
		 input [ADDR_BITS-1:0] addra,
		 output [WIDTH-1:0] douta,
		 
		 input sleep
		 );
         
	(*rom_style="distributed"*) reg [WIDTH-1:0] memory [DEPTH];
   
	reg [ADDRESS_BITS-1:0] latched_in_address = 0;
	reg [WIDTH-1:0] latched_output = 0;
	
	initial
		begin
		$readmemh(path, memory);
		end
	
	always @(posedge clka)
		begin
		if (ena)
			begin
			latched_in_address <= addra[ADDRESS_BITS-1:0];
			latched_output <= memory[latched_in_address];
			end
		end
	// always end
	
	assign douta = latched_output;
	
endmodule // dROM


module MUX_REG 
    #(
    parameter DATA_WIDTH = 8
    )
    (
    input clka,
    input ena,
    
    input [DATA_WIDTH-1:0] dina_0,
    input [DATA_WIDTH-1:0] dina_1,
    input  selector,
    
    output [DATA_WIDTH-1:0] douta
    );
reg [DATA_WIDTH-1:0] latched_data = 0;

assign douta = latched_data;

always @(posedge clka) 
    begin
    if(ena)
        begin
        latched_data <= selector ? dina_1
                                 : dina_0;
        end
    end

endmodule


module CASCADED_ROM
      #(
      parameter LEN = 2048,
      parameter DATA_WIDTH = 8,
      parameter init_file_name_format = "rom_hex_white_spaced_file_name_%d.mem",
      parameter USE_SLEEP = 1,
      parameter MEMO_TYPE = "distributed",
      parameter LATENCY = 5
      )
      (
      input sleep,

      input clka,
      input ena,
      input [31:0] addra,
      output [DATA_WIDTH-1:0] douta
      );

localparam BROM_PER_WIDTH = (DATA_WIDTH-1) / 36 +1;
localparam SINGLE_LEN = BROM_PER_WIDTH == 1 ? 1024*(36 / DATA_WIDTH)
                                            : 1024;
localparam SINGLE_BROM_ADDR_BITS = $clog2(SINGLE_LEN);
localparam BLOCKS_NUM = (LEN-1)/SINGLE_LEN + 1;
localparam BLOCKS_ADDR_WIDTH = $clog2(BLOCKS_NUM);
localparam ALIGNED_BLOCKS_NUM = 2**BLOCKS_ADDR_WIDTH;
localparam TREE_DEPTH = BLOCKS_ADDR_WIDTH;
localparam TREE_LATENCY = BLOCKS_ADDR_WIDTH + 2;
localparam LATENCY_ALIGNMENT = LATENCY-TREE_LATENCY;
localparam LAST_BLOCK_LEN = LEN - (BLOCKS_NUM-1)*SINGLE_LEN;

initial
    begin
    if (LATENCY_ALIGNMENT < 0)
        $error("LATENCY_ALIGNMENT < 0",$TIME);
    end

wire [SINGLE_BROM_ADDR_BITS-1:0] single_brom_addr = addra[SINGLE_BROM_ADDR_BITS-1:0];
wire [DATA_WIDTH-1:0] chain_dout[TREE_DEPTH:0][ALIGNED_BLOCKS_NUM-1:0];

localparam SLEEP_MODE = USE_SLEEP && MEMO_TYPE != "distributed";

genvar gen_blk_idx, gen_tree_idx, gen_width_idx; 
generate

for (gen_blk_idx = 0; gen_blk_idx < ALIGNED_BLOCKS_NUM; gen_blk_idx = gen_blk_idx + 1) 
    begin
    if (gen_blk_idx < BLOCKS_NUM-1)
        begin          
        wire dbiterra, sbiterra;
        xpm_memory_sprom #(
            .ADDR_WIDTH_A(SINGLE_BROM_ADDR_BITS),              // DECIMAL
            .AUTO_SLEEP_TIME(0),           // DECIMAL
            .CASCADE_HEIGHT(0),            // DECIMAL
            .ECC_MODE("no_ecc"),           // String
            .MEMORY_INIT_FILE($sformatf(init_file_name_format, gen_blk_idx)),     // String
            .MEMORY_INIT_PARAM(""),       // String
            .MEMORY_OPTIMIZATION("true"),  // String
            .MEMORY_PRIMITIVE(MEMO_TYPE),     // String
            .MEMORY_SIZE(DATA_WIDTH*SINGLE_LEN),            // DECIMAL
            .MESSAGE_CONTROL(0),           // DECIMAL
            .READ_DATA_WIDTH_A(DATA_WIDTH),        // DECIMAL
            .READ_LATENCY_A(2),            // DECIMAL
            .READ_RESET_VALUE_A("0"),      // String
            .RST_MODE_A("SYNC"),           // String
            .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
            .USE_MEM_INIT(1),              // DECIMAL
            .WAKEUP_TIME(SLEEP_MODE ? "use_sleep_pin" : "disable_sleep")  // String
        )
        inside_ROM_blk (
            .dbiterra(dbiterra),
            .sbiterra(sbiterra),
            .douta(chain_dout[0][gen_blk_idx]),
            .addra(addra[SINGLE_BROM_ADDR_BITS-1:0]),
            .clka(clka),
            .ena(ena),
            .injectdbiterra(1'b0),
            .injectsbiterra(1'b0),
            // .regcea(1'b1),
            .regcea(ena),
            .rsta(1'b0),
            .sleep(SLEEP_MODE ? sleep : 1'b0)
        );
        end
    else if (gen_blk_idx == BLOCKS_NUM-1) 
        begin
        BROM
            #(
            .path($sformatf(init_file_name_format, gen_blk_idx)),
            .WIDTH(DATA_WIDTH),
            .DEPTH(LAST_BLOCK_LEN),
            .ADDR_BITS(SINGLE_BROM_ADDR_BITS)
            )
            partial_brom
            (
            .clka(clka),
            .ena(ena),
            .addra(single_brom_addr),
            .douta(chain_dout[0][gen_blk_idx]),
            .sleep(sleep)
            );
        
        end
    else
        begin
        assign chain_dout[0][gen_blk_idx] = {(DATA_WIDTH){1'b0}}; 
        end
    end

for (gen_tree_idx = 0; gen_tree_idx < TREE_DEPTH; gen_tree_idx = gen_tree_idx+1)
    begin
    localparam TREE_WIDTH_IN = ALIGNED_BLOCKS_NUM / (2**gen_tree_idx);
    localparam TREE_WIDTH_OUT = TREE_WIDTH_IN / 2;
    wire addr_bit = addra[SINGLE_BROM_ADDR_BITS + gen_tree_idx];
    wire selector_bit;
    DelayLine 
        #(
        .WIDTH(1), 
        .DELAY(2+gen_tree_idx)
        ) 
        addr_bit_delay 
        (
        .clk(clka),
        .enable(ena),
        .data_in(addr_bit), 
        .data_out(selector_bit)
        );
	
    for (gen_width_idx = 0; gen_width_idx < TREE_WIDTH_OUT; gen_width_idx = gen_width_idx+1 )
        begin
        MUX_REG
            #(
            .DATA_WIDTH(DATA_WIDTH)
            )
            internal_mux
            (
            .clka(clka),
            .ena(ena),
            .selector(selector_bit),
            .dina_0(chain_dout[gen_tree_idx][2*gen_width_idx]),
            .dina_1(chain_dout[gen_tree_idx][2*gen_width_idx+1]),
            .douta(chain_dout[gen_tree_idx+1][gen_width_idx])
            );
        end
    end
endgenerate

DelayLine 
        #(
        .WIDTH(DATA_WIDTH), 
        .DELAY(LATENCY_ALIGNMENT)
        ) 
        latency_alignment
        (
        .clk(clka),
        .enable(ena),
        .data_in(chain_dout[TREE_DEPTH][0]), 
        .data_out(douta)
        );

// assign douta = chain_dout[TREE_DEPTH][0];

endmodule

