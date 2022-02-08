
module OutputLayer 
    #(
    parameter SIZE = 2,
    parameter READ_LATENCY = 7,
    // align to multiplicity of 4
    localparam SIZE_ALIGNED = ((SIZE-1)/4+1)*4,
    localparam ADDRESS_BITS = $clog2(SIZE_ALIGNED)
    )
    (
    input clk,
    // CONTROL SIGNALS
    input reset,
    input enable,
    output finished,

    // INPUT DATA MEMORY
    output in_data_memory_read_enable,
    input [7:0] in_data_memory_out,
    output [31:0] in_data_memory_address,

    output [31:0] axis_tdata,
    output [3:0] axis_tkeep,
    output axis_tlast,
    output axis_tvalid,
    input axis_tready
    );
wire processing_state = enable && axis_tready && !reset & !finished;

reg [ADDRESS_BITS-1:0] addr_cntr = 0;
reg is_fully_finished = 1;
reg first_byte = 1;

wire last = addr_cntr == SIZE_ALIGNED-1;
wire last_byte = addr_cntr[1:0] == 2'b11;
wire delayed_last;
wire delayed_full_dword;
wire delayed_valid;
ResettableDelayLine	
    #(
    .WIDTH(3),
    .DELAY(READ_LATENCY+1) // registers afters selection
    )
    delay_of_finish
    (
    .clk(clk),
    .enable(processing_state),
    .reset(reset),
    .data_in({!first_byte && !is_fully_finished, 
             last_byte, 
             last}),
    .data_out({delayed_valid, 
               delayed_full_dword, 
               delayed_last})
    );

wire [7:0] out_data [4];
ShiftRegisters
    #(
    .WIDTH(8),
    .LENGTH(4)
    )
    output_reg
    (
    .clk(clk),
    .step(processing_state),
    .data_in(in_data_memory_out),
    .registers_out(out_data)
    );
assign axis_tdata[31:24] = out_data[0];
assign axis_tdata[23:16] = out_data[1];
assign axis_tdata[15:8] = out_data[2];
assign axis_tdata[7:0] = out_data[3];

assign in_data_memory_address = {{(32-ADDRESS_BITS){1'b0}}, addr_cntr};
assign in_data_memory_read_enable = processing_state;
assign axis_tvalid = delayed_valid && delayed_full_dword;
assign axis_tlast = delayed_last && axis_tvalid;
assign axis_tkeep = 4'b1111;
assign finished = is_fully_finished;


always @(posedge clk) 
    begin
    if(reset)
        begin
        addr_cntr <= 0;
        is_fully_finished <= 0;
        first_byte <= 1;
        end
    else if (processing_state)
        begin
        if (axis_tlast)
            begin
            is_fully_finished <= 1;
            end 
        else
            first_byte <= 0;
            addr_cntr <= addr_cntr+1;
        end
    end

endmodule