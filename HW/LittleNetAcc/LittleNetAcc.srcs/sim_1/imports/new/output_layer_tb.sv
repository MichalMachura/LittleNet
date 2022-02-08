
module OutputLayer_tb ();

wire finished;
wire [7:0] memo_data;
wire [31:0] memo_addr;
wire memo_en;
wire [31:0] tdata;
wire tlast;
wire tkeep;
wire tvalid;
reg tready = 0;
reg reset = 0;
reg enable = 0;

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

initial 
    begin
    forever 
        begin
        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;
        for (int i=0; i < 10; i = i+1)
            begin
            @(posedge clk);
            tready = i%3;
            end
        @(posedge clk);
        enable = 1;
        for (int i=0; i < 60; i = i+1)
            begin
            @(posedge clk);
            tready = i%3;
            end
        @(posedge clk);
        tready = 0;
        enable = 0;
        for (int i=0; i < 3; i = i+1)
            @(posedge clk);
        end
    end

OutputLayer 
    #(
    .SIZE(7),
    .READ_LATENCY(2)
    )
    ol
    (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .finished(finished),
    .in_data_memory_out(memo_data),
    .in_data_memory_address(memo_addr),
    .in_data_memory_read_enable(memo_en),
    .axis_tdata(tdata),
    .axis_tkeep(tkeep),
    .axis_tlast(tlast),
    .axis_tvalid(tvalid),
    .axis_tready(tready)
    );

xpm_memory_sprom 
    #(
    .ADDR_WIDTH_A(32),              // DECIMAL
    .AUTO_SLEEP_TIME(0),           // DECIMAL
    .CASCADE_HEIGHT(0),            // DECIMAL
    .ECC_MODE("no_ecc"),           // String
    .MEMORY_INIT_FILE("none"),     // String
    .MEMORY_INIT_PARAM("1,2,3,4,5,6,7,8,9,a,b,c"),       // String
    .MEMORY_OPTIMIZATION("true"),  // String
    .MEMORY_PRIMITIVE("distrbuted"),     // String
    .MEMORY_SIZE(3*4*8),            // DECIMAL
    .MESSAGE_CONTROL(0),           // DECIMAL
    .READ_DATA_WIDTH_A(8),        // DECIMAL
    .READ_LATENCY_A(2),            // DECIMAL
    .READ_RESET_VALUE_A("0"),      // String
    .RST_MODE_A("SYNC"),           // String
    .SIM_ASSERT_CHK(1),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .USE_MEM_INIT(1),              // DECIMAL
    .WAKEUP_TIME("disable_sleep")  // String
    )
inside_ROM_blk 
    (
    .douta(memo_data),
    .addra(memo_addr),
    .clka(clk),
    .ena(memo_en),
    .injectdbiterra(1'b0),
    .injectsbiterra(1'b0),
    // .regcea(1'b1),
    .regcea(memo_en),
    .rsta(1'b0),
    .sleep(1'b0)
    );    
    
endmodule
