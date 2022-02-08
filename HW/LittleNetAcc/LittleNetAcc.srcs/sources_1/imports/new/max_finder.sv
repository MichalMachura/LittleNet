
module MaxFinderUnit
    #(
    parameter WIDTH = 13,
    parameter HEIGHT = 7,
    parameter CHANNELS = 15,
    parameter BIT_WIDTH = 8,
    parameter SIGNED = 1,
    
    parameter READ_LATENCY = 11,
    parameter WRITE_LATENCY = 9,
    
    localparam GROUPS = 4,
    localparam IN_SIZE = WIDTH*HEIGHT*CHANNELS,
    localparam IN_ADDR_BITS = $clog2(IN_SIZE),
    localparam OUT_SIZE = 2,
    localparam OUT_ADDR_BITS = $clog2(OUT_SIZE)
    ) 
    (
    input clk,
    input enable,
    input reset,
    
    input [BIT_WIDTH-1:0] in_data_memory_out,
    output [31:0] in_data_memory_address,
    output in_data_memory_read_enable,
    
    output [GROUPS*BIT_WIDTH-1:0] out_data_memory_in,
    output [31:0] out_data_memory_address,
    output out_data_memory_write_enable,
    
    output finished
    );

initial 
    begin
    if (CHANNELS % 5 != 0)
        $error("For Max Finder number of channels must be divisible by 5", $TIME);
    end

localparam [BIT_WIDTH-1:0] INIT_OF_MAX_VALIDITY = SIGNED ? {1'b1,{(BIT_WIDTH-1){1'b0}}}
                                         : 0;

localparam ROW_BITS = $clog2(HEIGHT);
localparam COL_BITS = $clog2(WIDTH);
localparam ANCHORS = CHANNELS / 5;
localparam ANCHOR_BITS = $clog2(ANCHORS);

reg [IN_ADDR_BITS-1:0] addr = 0; // address counter
reg [ROW_BITS-1:0] pos_row = 0, max_pos_row = 0;
reg [COL_BITS-1:0] pos_col = 0, max_pos_col = 0;
reg [ANCHOR_BITS-1:0] pos_anchor = 0, max_pos_anchor = 0;
// value of current max validity
reg [BIT_WIDTH-1:0] max_validity = INIT_OF_MAX_VALIDITY;

reg addr_finished = 1;
reg [3:0] state = 0;
reg fully_finished = 1;

reg [BIT_WIDTH-1:0] data_to_grouper = 0;
reg data_to_grouper_validity = 0;

localparam XYWH_SIZE = 4;
localparam XYWH_BITS = $clog2(XYWH_SIZE);
reg [XYWH_BITS-1:0] xywh_cntr = 0;

// state of processing
wire processing_state = enable && !finished;

// input interface
assign in_data_memory_read_enable = processing_state;
assign in_data_memory_address = {{(32-IN_ADDR_BITS){1'b0}}, addr};

// finished signals
assign finished = fully_finished;
wire is_mwu_finished;

// comparison type depends on signed or not 
wire is_greater;
generate
if (SIGNED)
    begin
    wire signed [BIT_WIDTH-1:0] in_data_memory_out_signed = in_data_memory_out;
    wire signed [BIT_WIDTH-1:0] max_validity_signed = max_validity;
    
    assign is_greater = max_validity_signed < in_data_memory_out_signed;
    end
else
    begin
    assign is_greater = max_validity < in_data_memory_out;
    end
endgenerate

wire valid_data;
// delay of READ LATENCY
ResettableDelayLine 
    #(
    .WIDTH(1),
    .DELAY(READ_LATENCY)
    )
    delay_of_read
    (
    .clk(clk),
    .reset(reset),
    .enable(processing_state),
    .data_in(!addr_finished),
    .data_out(valid_data)
    );

wire end_of_rows = pos_row == HEIGHT-1;
wire end_of_cols = pos_col == WIDTH-1;
wire end_of_anchors = pos_anchor == ANCHORS-1;

localparam SEARCH_VAL_POS = 0;
localparam GET_XYWH = 1;
localparam GET_VAL = 2;
localparam GET_ANCHOR = 3;
localparam GET_ROW = 4;
localparam GET_COL = 5;
localparam WAIT_SEND = 6;
localparam FINISHED = 7;
localparam IDLE = 8;

wire end_of_param = end_of_anchors && end_of_rows && end_of_cols;
wire is_pos_of_max = pos_anchor == max_pos_anchor
                    && pos_row == max_pos_row
                    && pos_col == max_pos_col;

always @(posedge clk) 
    begin
    if (reset)
        begin
        addr <= 0;
        pos_row <= 0;
        pos_col <= 0;
        pos_anchor <= 0;
        max_pos_row <= 0;
        max_pos_col <= 0;
        max_pos_anchor <= 0;
        max_validity <= INIT_OF_MAX_VALIDITY;
        addr_finished <= 0;
        state <= 0;
        fully_finished <= 0;
        data_to_grouper <= 0;
        data_to_grouper_validity <= 0;
        xywh_cntr <= 0;
        end
    
    else if(enable)
        begin
        // iterate over input addresses
        if (addr == IN_SIZE-1)
            addr_finished <= 1;
        else
            begin
            addr <= addr+1;
            end
        
        // position counters
        if(valid_data)
            begin    
            // next col
            if(end_of_cols)
                begin
                pos_col <= 0;
                // next row 
                if (end_of_rows)
                    begin
                    pos_row <= 0;
                    // next anchor
                    if (end_of_anchors)
                        begin
                        pos_anchor <= 0;
                        end
                    else
                        pos_anchor <= pos_anchor+1;
                    end
                else
                    pos_row <= pos_row+1;
                end
            else
                pos_col <= pos_col+1;
            end
        
        // state machine
        case (state)
        
        SEARCH_VAL_POS : // search
            begin
            if(valid_data)
                begin
                if (is_greater)
                    begin
                    max_validity <= in_data_memory_out;
                    max_pos_anchor <= pos_anchor;
                    max_pos_row <= pos_row;
                    max_pos_col <= pos_col;
                    end
                
                if (end_of_param)
                    state <= GET_XYWH;
                end
            end
        
        GET_XYWH :
            begin
            if (valid_data)
                begin    
                if (is_pos_of_max)
                    begin
                    data_to_grouper <= in_data_memory_out;
                    data_to_grouper_validity <= 1;
                    end
                else
                    begin
                    data_to_grouper_validity <= 0;
                    end
                
                if(end_of_param)
                    begin
                    xywh_cntr <= xywh_cntr+1;
                    // last of feature map element was read
                    // XYWH were send. Now go to sending VALIDITY 
                    if (xywh_cntr == XYWH_SIZE-1)
                        state <= GET_VAL;
                    end
                end
            end
            
        GET_VAL:
            begin
            data_to_grouper <= max_validity;
            data_to_grouper_validity <= 1;
            
            state <= GET_ANCHOR;
            end
            
        GET_ANCHOR:
            begin
            // fill with 0 <= anchors bits num could be smaller
            data_to_grouper <= { {(BIT_WIDTH-ANCHOR_BITS){1'b0}}, max_pos_anchor};
            data_to_grouper_validity <= 1;
            state <= GET_ROW;
            end
            
        GET_ROW:
            begin
            // fill with 0 <= rows bits num could be smaller
            data_to_grouper <= { {(BIT_WIDTH-ROW_BITS){1'b0}}, max_pos_row};
            data_to_grouper_validity <= 1;
            state <= GET_COL;
            end
            
        GET_COL:
            begin
            // fill with 0 <= cols bits num could be smaller
            data_to_grouper <= { {(BIT_WIDTH-COL_BITS){1'b0}}, max_pos_col};
            data_to_grouper_validity <= 1;
            state <= WAIT_SEND;
            end
        
        // waiting for all data are written to ram
        WAIT_SEND:
            begin
            // zero data, addr and we
            data_to_grouper <= {(BIT_WIDTH){1'b0}};
            data_to_grouper_validity <= 0;
            
            // stay in this state by time of write latency
            if (is_mwu_finished) 
                state <= FINISHED;
            end
        
        // set finished flag
        FINISHED:
            begin
            fully_finished <= 1;
            state <= IDLE;
            end
        
        // do nothing
        // IDLE:
        default:
            begin
            
            end
        endcase
        end
    end


wire [GROUPS*BIT_WIDTH-1:0] grouped_data[1];
wire grouped_data_validity[1];
GrouperUnit	
    #(
    .BIT_WIDTH(BIT_WIDTH),
    .GROUPS(GROUPS),
    .ENDIANNESS(0)
    )
    grouping
    (
    .clk(clk),
    .reset(reset),
    .enable(processing_state),
    .data_in(data_to_grouper),
    .data_in_validity(data_to_grouper_validity),
    .data_out(grouped_data[0]),
    .data_out_validity(grouped_data_validity[0])
    );

wire [OUT_ADDR_BITS-1:0] local_out_data_memory_address;
assign out_data_memory_address = {{(32-OUT_ADDR_BITS){1'b0}}, 
                            local_out_data_memory_address};

MuxWriterUnit
    #(
    .BIT_WIDTH(BIT_WIDTH*GROUPS),
    .WIDTH(4),
    .HEIGHT(1),
    .CHANNELS(2),
    .GROUPS(GROUPS),
    .PARALLELISM(1),
    .REGISTER_FOR_EACH(1),
    .WRITE_MEMORY_LATENCY(WRITE_LATENCY)
    )
    mwu
    (
    .clk(clk),
    .enable(processing_state),
    .reset(reset),

    .in_data(grouped_data),
    .in_data_validity(grouped_data_validity),
    
    .out_data_memory_in(out_data_memory_in),
    .out_data_memory_address(local_out_data_memory_address),
    .out_data_memory_write_enable(out_data_memory_write_enable),
    
    .finished(is_mwu_finished)
    );

endmodule