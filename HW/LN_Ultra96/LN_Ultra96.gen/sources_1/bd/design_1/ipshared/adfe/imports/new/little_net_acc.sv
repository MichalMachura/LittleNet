

module LittleNetAcc 
    (
    input clk,
    input reset,
    
    input [31:0] data_in,
    input data_in_validity,
    output write_possible,
    
    output output_data_ready,
    output [7:0] output_data [7],
    input output_was_read
    );


wire enable[20];
wire rst[20];
wire finished[20];
wire sleep[20];
wire [7:0] data_read[20];
wire [31:0] data_read_address[20];
wire [31:0] data_read_en[20];
wire [31:0] data_write[20];
wire [31:0] data_write_address[20];
wire data_write_we[20];
wire il_last_data_received;



    
    InputLayer
		#(
		.BIT_WIDTH(8),
		.WIDTH(208),
		.HEIGHT(112),
		.CHANNELS(3),
		.GROUPS(4),
		.WRITE_MEMORY_LATENCY(2)
		)
		
		(
		.clk(clk),
		.enable(enable[0]),
		.reset(rst[0]),
		.data_in(data_in),
		.data_in_validity(data_in_validity),
		.data_out(data_write[0]),
		.data_out_address(data_write_address[0]),
		.data_out_validity(data_write_we[0]),
		.finished(finished[0]),
		.last_data_received(il_last_data_received)
		);
    

    
    wire [8-1:0] data_weight_1;
    wire [31:0] data_weight_address_1;
    wire data_weight_en_1;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(208),
        .IN_HEIGHT(112),
        .IN_CHANNELS(3),
        .CHANNEL_MUL(2),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(0),
        .USE_BN(1),
        .USE_RELU(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(0),
        .IN_DATA_SIGN(0),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_1_dw
        (
        .clk(clk),
        .reset(rst[1]),
        .enable(enable[1]),
        .finished(finished[1]),
        .in_data_memory_out(data_read[1]),
        .in_data_memory_address(data_read_address[1]),
        .in_data_memory_read_enable(data_read_en[1]),
        .weights_memory_out(data_weight_1),
        .weights_memory_address(data_weight_address_1),
        .weights_memory_read_enable(data_weight_en_1),
        .out_data_memory_in(data_write[1]),
        .out_data_memory_address(data_write_address[1]),
        .out_data_memory_write_enable(data_write_we[1])
        );
    ROM
        #(
        .LEN(66),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_1_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(0),
        .MEMO_TYPE("auto")
        )
        rom_layer_1_dw
        (
        .clka(clk),
        .sleep(sleep[1]),
        .douta(data_weight_1),
        .addra(data_weight_address_1),
        .ena(data_weight_en_1)
        );
    

    
    wire [8*8-1:0] data_weight_2;
    wire [31:0] data_weight_address_2;
    wire data_weight_en_2;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(208),
        .IN_HEIGHT(112),
        .IN_CHANNELS(6),
        .OUT_CHANNELS(8),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(0),
        .USE_MAXPOOL(1),
        .USE_MAXPOOL_CEIL_MODE(1),
        .PARALLELISM(8),
        .GROUPS(4),
        .USE_MAX_FINDER(0),
        .ANCHORS(1),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_2_pw
        (
        .clk(clk),
        .reset(rst[2]),
        .enable(enable[2]),
        .finished(finished[2]),
        .in_data_memory_out(data_read[2]),
        .in_data_memory_address(data_read_address[2]),
        .in_data_memory_read_enable(data_read_en[2]),
        .weights_memory_out(data_weight_2),
        .weights_memory_address(data_weight_address_2),
        .weights_memory_read_enable(data_weight_en_2),
        .out_data_memory_in(data_write[2]),
        .out_data_memory_address(data_write_address[2]),
        .out_data_memory_write_enable(data_write_we[2])
        );
    ROM
        #(
        .LEN(9),
        .DATA_WIDTH(8*8),
        .init_file_name("rom_layer_2_pw.mem"),
        .LATENCY(2),
        .USE_SLEEP(0),
        .MEMO_TYPE("auto")
        )
        rom_layer_2_pw
        (
        .clka(clk),
        .sleep(sleep[2]),
        .douta(data_weight_2),
        .addra(data_weight_address_2),
        .ena(data_weight_en_2)
        );
    

    
    wire [8-1:0] data_weight_3;
    wire [31:0] data_weight_address_3;
    wire data_weight_en_3;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(104),
        .IN_HEIGHT(56),
        .IN_CHANNELS(8),
        .CHANNEL_MUL(1),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(0),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_3_dw
        (
        .clk(clk),
        .reset(rst[3]),
        .enable(enable[3]),
        .finished(finished[3]),
        .in_data_memory_out(data_read[3]),
        .in_data_memory_address(data_read_address[3]),
        .in_data_memory_read_enable(data_read_en[3]),
        .weights_memory_out(data_weight_3),
        .weights_memory_address(data_weight_address_3),
        .weights_memory_read_enable(data_weight_en_3),
        .out_data_memory_in(data_write[3]),
        .out_data_memory_address(data_write_address[3]),
        .out_data_memory_write_enable(data_write_we[3])
        );
    ROM
        #(
        .LEN(96),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_3_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(0),
        .MEMO_TYPE("auto")
        )
        rom_layer_3_dw
        (
        .clka(clk),
        .sleep(sleep[3]),
        .douta(data_weight_3),
        .addra(data_weight_address_3),
        .ena(data_weight_en_3)
        );
    

    
    wire [8-1:0] data_weight_4;
    wire [31:0] data_weight_address_4;
    wire data_weight_en_4;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(104),
        .IN_HEIGHT(56),
        .IN_CHANNELS(8),
        .CHANNEL_MUL(2),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(0),
        .USE_BN(1),
        .USE_RELU(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_4_dw
        (
        .clk(clk),
        .reset(rst[4]),
        .enable(enable[4]),
        .finished(finished[4]),
        .in_data_memory_out(data_read[4]),
        .in_data_memory_address(data_read_address[4]),
        .in_data_memory_read_enable(data_read_en[4]),
        .weights_memory_out(data_weight_4),
        .weights_memory_address(data_weight_address_4),
        .weights_memory_read_enable(data_weight_en_4),
        .out_data_memory_in(data_write[4]),
        .out_data_memory_address(data_write_address[4]),
        .out_data_memory_write_enable(data_write_we[4])
        );
    ROM
        #(
        .LEN(176),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_4_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(0),
        .MEMO_TYPE("auto")
        )
        rom_layer_4_dw
        (
        .clka(clk),
        .sleep(sleep[4]),
        .douta(data_weight_4),
        .addra(data_weight_address_4),
        .ena(data_weight_en_4)
        );
    

    
    wire [16*8-1:0] data_weight_5;
    wire [31:0] data_weight_address_5;
    wire data_weight_en_5;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(104),
        .IN_HEIGHT(56),
        .IN_CHANNELS(16),
        .OUT_CHANNELS(32),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(0),
        .USE_MAXPOOL(1),
        .USE_MAXPOOL_CEIL_MODE(1),
        .PARALLELISM(16),
        .GROUPS(4),
        .USE_MAX_FINDER(0),
        .ANCHORS(6),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_5_pw
        (
        .clk(clk),
        .reset(rst[5]),
        .enable(enable[5]),
        .finished(finished[5]),
        .in_data_memory_out(data_read[5]),
        .in_data_memory_address(data_read_address[5]),
        .in_data_memory_read_enable(data_read_en[5]),
        .weights_memory_out(data_weight_5),
        .weights_memory_address(data_weight_address_5),
        .weights_memory_read_enable(data_weight_en_5),
        .out_data_memory_in(data_write[5]),
        .out_data_memory_address(data_write_address[5]),
        .out_data_memory_write_enable(data_write_we[5])
        );
    ROM
        #(
        .LEN(38),
        .DATA_WIDTH(16*8),
        .init_file_name("rom_layer_5_pw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_5_pw
        (
        .clka(clk),
        .sleep(sleep[5]),
        .douta(data_weight_5),
        .addra(data_weight_address_5),
        .ena(data_weight_en_5)
        );
    

    
    wire [8-1:0] data_weight_6;
    wire [31:0] data_weight_address_6;
    wire data_weight_en_6;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(52),
        .IN_HEIGHT(28),
        .IN_CHANNELS(32),
        .CHANNEL_MUL(1),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(0),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_6_dw
        (
        .clk(clk),
        .reset(rst[6]),
        .enable(enable[6]),
        .finished(finished[6]),
        .in_data_memory_out(data_read[6]),
        .in_data_memory_address(data_read_address[6]),
        .in_data_memory_read_enable(data_read_en[6]),
        .weights_memory_out(data_weight_6),
        .weights_memory_address(data_weight_address_6),
        .weights_memory_read_enable(data_weight_en_6),
        .out_data_memory_in(data_write[6]),
        .out_data_memory_address(data_write_address[6]),
        .out_data_memory_write_enable(data_write_we[6])
        );
    ROM
        #(
        .LEN(384),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_6_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_6_dw
        (
        .clka(clk),
        .sleep(sleep[6]),
        .douta(data_weight_6),
        .addra(data_weight_address_6),
        .ena(data_weight_en_6)
        );
    

    
    wire [8-1:0] data_weight_7;
    wire [31:0] data_weight_address_7;
    wire data_weight_en_7;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(52),
        .IN_HEIGHT(28),
        .IN_CHANNELS(32),
        .CHANNEL_MUL(2),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(0),
        .USE_BN(1),
        .USE_RELU(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_7_dw
        (
        .clk(clk),
        .reset(rst[7]),
        .enable(enable[7]),
        .finished(finished[7]),
        .in_data_memory_out(data_read[7]),
        .in_data_memory_address(data_read_address[7]),
        .in_data_memory_read_enable(data_read_en[7]),
        .weights_memory_out(data_weight_7),
        .weights_memory_address(data_weight_address_7),
        .weights_memory_read_enable(data_weight_en_7),
        .out_data_memory_in(data_write[7]),
        .out_data_memory_address(data_write_address[7]),
        .out_data_memory_write_enable(data_write_we[7])
        );
    ROM
        #(
        .LEN(704),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_7_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_7_dw
        (
        .clka(clk),
        .sleep(sleep[7]),
        .douta(data_weight_7),
        .addra(data_weight_address_7),
        .ena(data_weight_en_7)
        );
    

    
    wire [16*8-1:0] data_weight_8;
    wire [31:0] data_weight_address_8;
    wire data_weight_en_8;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(52),
        .IN_HEIGHT(28),
        .IN_CHANNELS(64),
        .OUT_CHANNELS(64),
        .USE_BIAS(0),
        .USE_BN(1),
        .USE_RELU(0),
        .USE_MAXPOOL(1),
        .USE_MAXPOOL_CEIL_MODE(1),
        .PARALLELISM(16),
        .GROUPS(4),
        .USE_MAX_FINDER(0),
        .ANCHORS(12),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_8_pw
        (
        .clk(clk),
        .reset(rst[8]),
        .enable(enable[8]),
        .finished(finished[8]),
        .in_data_memory_out(data_read[8]),
        .in_data_memory_address(data_read_address[8]),
        .in_data_memory_read_enable(data_read_en[8]),
        .weights_memory_out(data_weight_8),
        .weights_memory_address(data_weight_address_8),
        .weights_memory_read_enable(data_weight_en_8),
        .out_data_memory_in(data_write[8]),
        .out_data_memory_address(data_write_address[8]),
        .out_data_memory_write_enable(data_write_we[8])
        );
    ROM
        #(
        .LEN(264),
        .DATA_WIDTH(16*8),
        .init_file_name("rom_layer_8_pw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_8_pw
        (
        .clka(clk),
        .sleep(sleep[8]),
        .douta(data_weight_8),
        .addra(data_weight_address_8),
        .ena(data_weight_en_8)
        );
    

    
    wire [8-1:0] data_weight_9;
    wire [31:0] data_weight_address_9;
    wire data_weight_en_9;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(26),
        .IN_HEIGHT(14),
        .IN_CHANNELS(64),
        .CHANNEL_MUL(1),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(0),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_9_dw
        (
        .clk(clk),
        .reset(rst[9]),
        .enable(enable[9]),
        .finished(finished[9]),
        .in_data_memory_out(data_read[9]),
        .in_data_memory_address(data_read_address[9]),
        .in_data_memory_read_enable(data_read_en[9]),
        .weights_memory_out(data_weight_9),
        .weights_memory_address(data_weight_address_9),
        .weights_memory_read_enable(data_weight_en_9),
        .out_data_memory_in(data_write[9]),
        .out_data_memory_address(data_write_address[9]),
        .out_data_memory_write_enable(data_write_we[9])
        );
    ROM
        #(
        .LEN(768),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_9_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_9_dw
        (
        .clka(clk),
        .sleep(sleep[9]),
        .douta(data_weight_9),
        .addra(data_weight_address_9),
        .ena(data_weight_en_9)
        );
    

    
    wire [8-1:0] data_weight_10;
    wire [31:0] data_weight_address_10;
    wire data_weight_en_10;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(26),
        .IN_HEIGHT(14),
        .IN_CHANNELS(64),
        .CHANNEL_MUL(2),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_10_dw
        (
        .clk(clk),
        .reset(rst[10]),
        .enable(enable[10]),
        .finished(finished[10]),
        .in_data_memory_out(data_read[10]),
        .in_data_memory_address(data_read_address[10]),
        .in_data_memory_read_enable(data_read_en[10]),
        .weights_memory_out(data_weight_10),
        .weights_memory_address(data_weight_address_10),
        .weights_memory_read_enable(data_weight_en_10),
        .out_data_memory_in(data_write[10]),
        .out_data_memory_address(data_write_address[10]),
        .out_data_memory_write_enable(data_write_we[10])
        );
    ROM
        #(
        .LEN(1536),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_10_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_10_dw
        (
        .clka(clk),
        .sleep(sleep[10]),
        .douta(data_weight_10),
        .addra(data_weight_address_10),
        .ena(data_weight_en_10)
        );
    

    
    wire [16*8-1:0] data_weight_11;
    wire [31:0] data_weight_address_11;
    wire data_weight_en_11;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(26),
        .IN_HEIGHT(14),
        .IN_CHANNELS(128),
        .OUT_CHANNELS(128),
        .USE_BIAS(0),
        .USE_BN(1),
        .USE_RELU(1),
        .USE_MAXPOOL(1),
        .USE_MAXPOOL_CEIL_MODE(1),
        .PARALLELISM(16),
        .GROUPS(4),
        .USE_MAX_FINDER(0),
        .ANCHORS(25),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_11_pw
        (
        .clk(clk),
        .reset(rst[11]),
        .enable(enable[11]),
        .finished(finished[11]),
        .in_data_memory_out(data_read[11]),
        .in_data_memory_address(data_read_address[11]),
        .in_data_memory_read_enable(data_read_en[11]),
        .weights_memory_out(data_weight_11),
        .weights_memory_address(data_weight_address_11),
        .weights_memory_read_enable(data_weight_en_11),
        .out_data_memory_in(data_write[11]),
        .out_data_memory_address(data_write_address[11]),
        .out_data_memory_write_enable(data_write_we[11])
        );
    ROM
        #(
        .LEN(1040),
        .DATA_WIDTH(16*8),
        .init_file_name("rom_layer_11_pw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_11_pw
        (
        .clka(clk),
        .sleep(sleep[11]),
        .douta(data_weight_11),
        .addra(data_weight_address_11),
        .ena(data_weight_en_11)
        );
    

    
    wire [8-1:0] data_weight_12;
    wire [31:0] data_weight_address_12;
    wire data_weight_en_12;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(128),
        .CHANNEL_MUL(1),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(0),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_12_dw
        (
        .clk(clk),
        .reset(rst[12]),
        .enable(enable[12]),
        .finished(finished[12]),
        .in_data_memory_out(data_read[12]),
        .in_data_memory_address(data_read_address[12]),
        .in_data_memory_read_enable(data_read_en[12]),
        .weights_memory_out(data_weight_12),
        .weights_memory_address(data_weight_address_12),
        .weights_memory_read_enable(data_weight_en_12),
        .out_data_memory_in(data_write[12]),
        .out_data_memory_address(data_write_address[12]),
        .out_data_memory_write_enable(data_write_we[12])
        );
    ROM
        #(
        .LEN(1536),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_12_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_12_dw
        (
        .clka(clk),
        .sleep(sleep[12]),
        .douta(data_weight_12),
        .addra(data_weight_address_12),
        .ena(data_weight_en_12)
        );
    

    
    wire [8-1:0] data_weight_13;
    wire [31:0] data_weight_address_13;
    wire data_weight_en_13;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(128),
        .CHANNEL_MUL(2),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_13_dw
        (
        .clk(clk),
        .reset(rst[13]),
        .enable(enable[13]),
        .finished(finished[13]),
        .in_data_memory_out(data_read[13]),
        .in_data_memory_address(data_read_address[13]),
        .in_data_memory_read_enable(data_read_en[13]),
        .weights_memory_out(data_weight_13),
        .weights_memory_address(data_weight_address_13),
        .weights_memory_read_enable(data_weight_en_13),
        .out_data_memory_in(data_write[13]),
        .out_data_memory_address(data_write_address[13]),
        .out_data_memory_write_enable(data_write_we[13])
        );
    ROM
        #(
        .LEN(3072),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_13_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_13_dw
        (
        .clka(clk),
        .sleep(sleep[13]),
        .douta(data_weight_13),
        .addra(data_weight_address_13),
        .ena(data_weight_en_13)
        );
    

    
    wire [18*8-1:0] data_weight_14;
    wire [31:0] data_weight_address_14;
    wire data_weight_en_14;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(256),
        .OUT_CHANNELS(256),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(1),
        .USE_MAXPOOL(0),
        .USE_MAXPOOL_CEIL_MODE(0),
        .PARALLELISM(18),
        .GROUPS(4),
        .USE_MAX_FINDER(0),
        .ANCHORS(51),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_14_pw
        (
        .clk(clk),
        .reset(rst[14]),
        .enable(enable[14]),
        .finished(finished[14]),
        .in_data_memory_out(data_read[14]),
        .in_data_memory_address(data_read_address[14]),
        .in_data_memory_read_enable(data_read_en[14]),
        .weights_memory_out(data_weight_14),
        .weights_memory_address(data_weight_address_14),
        .weights_memory_read_enable(data_weight_en_14),
        .out_data_memory_in(data_write[14]),
        .out_data_memory_address(data_write_address[14]),
        .out_data_memory_write_enable(data_write_we[14])
        );
    ROM
        #(
        .LEN(3885),
        .DATA_WIDTH(18*8),
        .init_file_name("rom_layer_14_pw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_14_pw
        (
        .clka(clk),
        .sleep(sleep[14]),
        .douta(data_weight_14),
        .addra(data_weight_address_14),
        .ena(data_weight_en_14)
        );
    

    
    wire [8-1:0] data_weight_15;
    wire [31:0] data_weight_address_15;
    wire data_weight_en_15;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(256),
        .CHANNEL_MUL(1),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(0),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_15_dw
        (
        .clk(clk),
        .reset(rst[15]),
        .enable(enable[15]),
        .finished(finished[15]),
        .in_data_memory_out(data_read[15]),
        .in_data_memory_address(data_read_address[15]),
        .in_data_memory_read_enable(data_read_en[15]),
        .weights_memory_out(data_weight_15),
        .weights_memory_address(data_weight_address_15),
        .weights_memory_read_enable(data_weight_en_15),
        .out_data_memory_in(data_write[15]),
        .out_data_memory_address(data_write_address[15]),
        .out_data_memory_write_enable(data_write_we[15])
        );
    ROM
        #(
        .LEN(3072),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_15_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_15_dw
        (
        .clka(clk),
        .sleep(sleep[15]),
        .douta(data_weight_15),
        .addra(data_weight_address_15),
        .ena(data_weight_en_15)
        );
    

    
    wire [8-1:0] data_weight_16;
    wire [31:0] data_weight_address_16;
    wire data_weight_en_16;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(256),
        .CHANNEL_MUL(2),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_16_dw
        (
        .clk(clk),
        .reset(rst[16]),
        .enable(enable[16]),
        .finished(finished[16]),
        .in_data_memory_out(data_read[16]),
        .in_data_memory_address(data_read_address[16]),
        .in_data_memory_read_enable(data_read_en[16]),
        .weights_memory_out(data_weight_16),
        .weights_memory_address(data_weight_address_16),
        .weights_memory_read_enable(data_weight_en_16),
        .out_data_memory_in(data_write[16]),
        .out_data_memory_address(data_write_address[16]),
        .out_data_memory_write_enable(data_write_we[16])
        );
    ROM
        #(
        .LEN(6144),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_16_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_16_dw
        (
        .clka(clk),
        .sleep(sleep[16]),
        .douta(data_weight_16),
        .addra(data_weight_address_16),
        .ena(data_weight_en_16)
        );
    

    
    wire [18*8-1:0] data_weight_17;
    wire [31:0] data_weight_address_17;
    wire data_weight_en_17;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(512),
        .OUT_CHANNELS(256),
        .USE_BIAS(1),
        .USE_BN(1),
        .USE_RELU(1),
        .USE_MAXPOOL(0),
        .USE_MAXPOOL_CEIL_MODE(0),
        .PARALLELISM(18),
        .GROUPS(4),
        .USE_MAX_FINDER(0),
        .ANCHORS(51),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_17_pw
        (
        .clk(clk),
        .reset(rst[17]),
        .enable(enable[17]),
        .finished(finished[17]),
        .in_data_memory_out(data_read[17]),
        .in_data_memory_address(data_read_address[17]),
        .in_data_memory_read_enable(data_read_en[17]),
        .weights_memory_out(data_weight_17),
        .weights_memory_address(data_weight_address_17),
        .weights_memory_read_enable(data_weight_en_17),
        .out_data_memory_in(data_write[17]),
        .out_data_memory_address(data_write_address[17]),
        .out_data_memory_write_enable(data_write_we[17])
        );
    ROM
        #(
        .LEN(7725),
        .DATA_WIDTH(18*8),
        .init_file_name("rom_layer_17_pw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_17_pw
        (
        .clka(clk),
        .sleep(sleep[17]),
        .douta(data_weight_17),
        .addra(data_weight_address_17),
        .ena(data_weight_en_17)
        );
    

    
    wire [8-1:0] data_weight_18;
    wire [31:0] data_weight_address_18;
    wire data_weight_en_18;
    
    DepthwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(256),
        .CHANNEL_MUL(1),
        .PADDING_W(1),
        .PADDING_H(1),
        .USE_BIAS(0),
        .USE_BN(1),
        .USE_RELU(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(1),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(1),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(1),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_18_dw
        (
        .clk(clk),
        .reset(rst[18]),
        .enable(enable[18]),
        .finished(finished[18]),
        .in_data_memory_out(data_read[18]),
        .in_data_memory_address(data_read_address[18]),
        .in_data_memory_read_enable(data_read_en[18]),
        .weights_memory_out(data_weight_18),
        .weights_memory_address(data_weight_address_18),
        .weights_memory_read_enable(data_weight_en_18),
        .out_data_memory_in(data_write[18]),
        .out_data_memory_address(data_write_address[18]),
        .out_data_memory_write_enable(data_write_we[18])
        );
    ROM
        #(
        .LEN(2816),
        .DATA_WIDTH(8),
        .init_file_name("rom_layer_18_dw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_18_dw
        (
        .clka(clk),
        .sleep(sleep[18]),
        .douta(data_weight_18),
        .addra(data_weight_address_18),
        .ena(data_weight_en_18)
        );
    

    
    wire [5*8-1:0] data_weight_19;
    wire [31:0] data_weight_address_19;
    wire data_weight_en_19;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(256),
        .OUT_CHANNELS(15),
        .USE_BIAS(1),
        .USE_BN(0),
        .USE_RELU(0),
        .USE_MAXPOOL(0),
        .USE_MAXPOOL_CEIL_MODE(0),
        .PARALLELISM(5),
        .GROUPS(1),
        .USE_MAX_FINDER(1),
        .ANCHORS(3),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(1),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(1),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(1),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(8),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(8),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(8),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(1),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(2),
        .READ_WEIGHT_MEMORY_LATENCY(2),
        .WRITE_MEMORY_LATENCY(2)
        )
        layer_19_pw
        (
        .clk(clk),
        .reset(rst[19]),
        .enable(enable[19]),
        .finished(finished[19]),
        .in_data_memory_out(data_read[19]),
        .in_data_memory_address(data_read_address[19]),
        .in_data_memory_read_enable(data_read_en[19]),
        .weights_memory_out(data_weight_19),
        .weights_memory_address(data_weight_address_19),
        .weights_memory_read_enable(data_weight_en_19),
        .out_data_memory_in(data_write[19]),
        .out_data_memory_address(data_write_address[19]),
        .out_data_memory_write_enable(data_write_we[19])
        );
    ROM
        #(
        .LEN(257),
        .DATA_WIDTH(5*8),
        .init_file_name("rom_layer_19_pw.mem"),
        .LATENCY(2),
        .USE_SLEEP(1),
        .MEMO_TYPE("block")
        )
        rom_layer_19_pw
        (
        .clka(clk),
        .sleep(sleep[19]),
        .douta(data_weight_19),
        .addra(data_weight_address_19),
        .ena(data_weight_en_19)
        );
    


// RAMS
wire ena[11]; 
wire enb[11]; 
wire wea[11]; 
wire [31:0] addra[11]; 
wire [31:0] addrb[11];
wire [31:0] dina[11];
wire [7:0] doutb[11];

// ports read
wire [0:0] port_read_select[11];
wire [7:0] port_read_data[22];
wire [31:0] port_read_address[22];
wire port_read_en[22];

// ports write
wire [0:0] port_write_select[11];
wire [31:0] port_write_data[22];
wire [31:0] port_write_address[22];
wire port_write_en[22];
wire port_write_we[22];


    SDP_RAM
        #(
        .BYTE_LEN(69888),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        in_ram
        (
         .clka(clk),
         .ena(ena[0]),
         .dina(dina[0]),
         .addra(addra[0]),
         .wea(wea[0]),
         
         .clkb(clk),
         .enb(enb[0]),
         .doutb(doutb[0]),
         .addrb(addrb[0]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_in_ram
        (
        .clk(clk),
        .select(port_read_select[0]),
        .data_in_address(port_read_address[0:1]),
        .data_in_read_enable(port_read_en[0:1]),
        
        .data_out_address(addrb[0]),
        .data_out_read_enable(enb[0])
        );
    assign port_read_data[0] = doutb[0];
    assign port_read_data[1] = doutb[0];
    
    // ram's port write activation 
    assign ena[0] = port_write_en[0] | port_write_en[0];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_in_ram
        (
        .clk(clk),
        .select(port_write_select[0]),
        
        .data_in(port_write_data[0:1]),
        .data_in_address(port_write_address[0:1]),
        .data_in_write_enable(port_write_we[0:1]),
        
        .data_out(dina[0]),
        .data_out_address(addra[0]),
        .data_out_write_enable(wea[0])
        );


    SDP_RAM
        #(
        .BYTE_LEN(139776),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_1_0
        (
         .clka(clk),
         .ena(ena[1]),
         .dina(dina[1]),
         .addra(addra[1]),
         .wea(wea[1]),
         
         .clkb(clk),
         .enb(enb[1]),
         .doutb(doutb[1]),
         .addrb(addrb[1]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_1_0
        (
        .clk(clk),
        .select(port_read_select[1]),
        .data_in_address(port_read_address[2:3]),
        .data_in_read_enable(port_read_en[2:3]),
        
        .data_out_address(addrb[1]),
        .data_out_read_enable(enb[1])
        );
    assign port_read_data[2] = doutb[1];
    assign port_read_data[3] = doutb[1];
    
    // ram's port write activation 
    assign ena[1] = port_write_en[2] | port_write_en[2];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_1_0
        (
        .clk(clk),
        .select(port_write_select[1]),
        
        .data_in(port_write_data[2:3]),
        .data_in_address(port_write_address[2:3]),
        .data_in_write_enable(port_write_we[2:3]),
        
        .data_out(dina[1]),
        .data_out_address(addra[1]),
        .data_out_write_enable(wea[1])
        );


    SDP_RAM
        #(
        .BYTE_LEN(93184),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_1_1
        (
         .clka(clk),
         .ena(ena[2]),
         .dina(dina[2]),
         .addra(addra[2]),
         .wea(wea[2]),
         
         .clkb(clk),
         .enb(enb[2]),
         .doutb(doutb[2]),
         .addrb(addrb[2]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_1_1
        (
        .clk(clk),
        .select(port_read_select[2]),
        .data_in_address(port_read_address[4:5]),
        .data_in_read_enable(port_read_en[4:5]),
        
        .data_out_address(addrb[2]),
        .data_out_read_enable(enb[2])
        );
    assign port_read_data[4] = doutb[2];
    assign port_read_data[5] = doutb[2];
    
    // ram's port write activation 
    assign ena[2] = port_write_en[4] | port_write_en[4];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_1_1
        (
        .clk(clk),
        .select(port_write_select[2]),
        
        .data_in(port_write_data[4:5]),
        .data_in_address(port_write_address[4:5]),
        .data_in_write_enable(port_write_we[4:5]),
        
        .data_out(dina[2]),
        .data_out_address(addra[2]),
        .data_out_write_enable(wea[2])
        );


    SDP_RAM
        #(
        .BYTE_LEN(93184),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_2_0
        (
         .clka(clk),
         .ena(ena[3]),
         .dina(dina[3]),
         .addra(addra[3]),
         .wea(wea[3]),
         
         .clkb(clk),
         .enb(enb[3]),
         .doutb(doutb[3]),
         .addrb(addrb[3]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_2_0
        (
        .clk(clk),
        .select(port_read_select[3]),
        .data_in_address(port_read_address[6:7]),
        .data_in_read_enable(port_read_en[6:7]),
        
        .data_out_address(addrb[3]),
        .data_out_read_enable(enb[3])
        );
    assign port_read_data[6] = doutb[3];
    assign port_read_data[7] = doutb[3];
    
    // ram's port write activation 
    assign ena[3] = port_write_en[6] | port_write_en[6];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_2_0
        (
        .clk(clk),
        .select(port_write_select[3]),
        
        .data_in(port_write_data[6:7]),
        .data_in_address(port_write_address[6:7]),
        .data_in_write_enable(port_write_we[6:7]),
        
        .data_out(dina[3]),
        .data_out_address(addra[3]),
        .data_out_write_enable(wea[3])
        );


    SDP_RAM
        #(
        .BYTE_LEN(46592),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_2_1
        (
         .clka(clk),
         .ena(ena[4]),
         .dina(dina[4]),
         .addra(addra[4]),
         .wea(wea[4]),
         
         .clkb(clk),
         .enb(enb[4]),
         .doutb(doutb[4]),
         .addrb(addrb[4]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_2_1
        (
        .clk(clk),
        .select(port_read_select[4]),
        .data_in_address(port_read_address[8:9]),
        .data_in_read_enable(port_read_en[8:9]),
        
        .data_out_address(addrb[4]),
        .data_out_read_enable(enb[4])
        );
    assign port_read_data[8] = doutb[4];
    assign port_read_data[9] = doutb[4];
    
    // ram's port write activation 
    assign ena[4] = port_write_en[8] | port_write_en[8];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_2_1
        (
        .clk(clk),
        .select(port_write_select[4]),
        
        .data_in(port_write_data[8:9]),
        .data_in_address(port_write_address[8:9]),
        .data_in_write_enable(port_write_we[8:9]),
        
        .data_out(dina[4]),
        .data_out_address(addra[4]),
        .data_out_write_enable(wea[4])
        );


    SDP_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_3_0
        (
         .clka(clk),
         .ena(ena[5]),
         .dina(dina[5]),
         .addra(addra[5]),
         .wea(wea[5]),
         
         .clkb(clk),
         .enb(enb[5]),
         .doutb(doutb[5]),
         .addrb(addrb[5]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_3_0
        (
        .clk(clk),
        .select(port_read_select[5]),
        .data_in_address(port_read_address[10:11]),
        .data_in_read_enable(port_read_en[10:11]),
        
        .data_out_address(addrb[5]),
        .data_out_read_enable(enb[5])
        );
    assign port_read_data[10] = doutb[5];
    assign port_read_data[11] = doutb[5];
    
    // ram's port write activation 
    assign ena[5] = port_write_en[10] | port_write_en[10];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_3_0
        (
        .clk(clk),
        .select(port_write_select[5]),
        
        .data_in(port_write_data[10:11]),
        .data_in_address(port_write_address[10:11]),
        .data_in_write_enable(port_write_we[10:11]),
        
        .data_out(dina[5]),
        .data_out_address(addra[5]),
        .data_out_write_enable(wea[5])
        );


    SDP_RAM
        #(
        .BYTE_LEN(46592),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_3_1
        (
         .clka(clk),
         .ena(ena[6]),
         .dina(dina[6]),
         .addra(addra[6]),
         .wea(wea[6]),
         
         .clkb(clk),
         .enb(enb[6]),
         .doutb(doutb[6]),
         .addrb(addrb[6]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_3_1
        (
        .clk(clk),
        .select(port_read_select[6]),
        .data_in_address(port_read_address[12:13]),
        .data_in_read_enable(port_read_en[12:13]),
        
        .data_out_address(addrb[6]),
        .data_out_read_enable(enb[6])
        );
    assign port_read_data[12] = doutb[6];
    assign port_read_data[13] = doutb[6];
    
    // ram's port write activation 
    assign ena[6] = port_write_en[12] | port_write_en[12];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_3_1
        (
        .clk(clk),
        .select(port_write_select[6]),
        
        .data_in(port_write_data[12:13]),
        .data_in_address(port_write_address[12:13]),
        .data_in_write_enable(port_write_we[12:13]),
        
        .data_out(dina[6]),
        .data_out_address(addra[6]),
        .data_out_write_enable(wea[6])
        );


    SDP_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_4_0
        (
         .clka(clk),
         .ena(ena[7]),
         .dina(dina[7]),
         .addra(addra[7]),
         .wea(wea[7]),
         
         .clkb(clk),
         .enb(enb[7]),
         .doutb(doutb[7]),
         .addrb(addrb[7]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_4_0
        (
        .clk(clk),
        .select(port_read_select[7]),
        .data_in_address(port_read_address[14:15]),
        .data_in_read_enable(port_read_en[14:15]),
        
        .data_out_address(addrb[7]),
        .data_out_read_enable(enb[7])
        );
    assign port_read_data[14] = doutb[7];
    assign port_read_data[15] = doutb[7];
    
    // ram's port write activation 
    assign ena[7] = port_write_en[14] | port_write_en[14];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_4_0
        (
        .clk(clk),
        .select(port_write_select[7]),
        
        .data_in(port_write_data[14:15]),
        .data_in_address(port_write_address[14:15]),
        .data_in_write_enable(port_write_we[14:15]),
        
        .data_out(dina[7]),
        .data_out_address(addra[7]),
        .data_out_write_enable(wea[7])
        );


    SDP_RAM
        #(
        .BYTE_LEN(46592),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_4_1
        (
         .clka(clk),
         .ena(ena[8]),
         .dina(dina[8]),
         .addra(addra[8]),
         .wea(wea[8]),
         
         .clkb(clk),
         .enb(enb[8]),
         .doutb(doutb[8]),
         .addrb(addrb[8]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_4_1
        (
        .clk(clk),
        .select(port_read_select[8]),
        .data_in_address(port_read_address[16:17]),
        .data_in_read_enable(port_read_en[16:17]),
        
        .data_out_address(addrb[8]),
        .data_out_read_enable(enb[8])
        );
    assign port_read_data[16] = doutb[8];
    assign port_read_data[17] = doutb[8];
    
    // ram's port write activation 
    assign ena[8] = port_write_en[16] | port_write_en[16];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_4_1
        (
        .clk(clk),
        .select(port_write_select[8]),
        
        .data_in(port_write_data[16:17]),
        .data_in_address(port_write_address[16:17]),
        .data_in_write_enable(port_write_we[16:17]),
        
        .data_out(dina[8]),
        .data_out_address(addra[8]),
        .data_out_write_enable(wea[8])
        );


    SDP_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_5_0
        (
         .clka(clk),
         .ena(ena[9]),
         .dina(dina[9]),
         .addra(addra[9]),
         .wea(wea[9]),
         
         .clkb(clk),
         .enb(enb[9]),
         .doutb(doutb[9]),
         .addrb(addrb[9]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_5_0
        (
        .clk(clk),
        .select(port_read_select[9]),
        .data_in_address(port_read_address[18:19]),
        .data_in_read_enable(port_read_en[18:19]),
        
        .data_out_address(addrb[9]),
        .data_out_read_enable(enb[9])
        );
    assign port_read_data[18] = doutb[9];
    assign port_read_data[19] = doutb[9];
    
    // ram's port write activation 
    assign ena[9] = port_write_en[18] | port_write_en[18];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_5_0
        (
        .clk(clk),
        .select(port_write_select[9]),
        
        .data_in(port_write_data[18:19]),
        .data_in_address(port_write_address[18:19]),
        .data_in_write_enable(port_write_we[18:19]),
        
        .data_out(dina[9]),
        .data_out_address(addra[9]),
        .data_out_write_enable(wea[9])
        );


    SDP_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .READ_LATENCY(2),
        .USE_SLEEP(0)
        )
        ram_5_1
        (
         .clka(clk),
         .ena(ena[10]),
         .dina(dina[10]),
         .addra(addra[10]),
         .wea(wea[10]),
         
         .clkb(clk),
         .enb(enb[10]),
         .doutb(doutb[10]),
         .addrb(addrb[10]),
         
         .sleep(1'b0)
        );
    
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_5_1
        (
        .clk(clk),
        .select(port_read_select[10]),
        .data_in_address(port_read_address[20:21]),
        .data_in_read_enable(port_read_en[20:21]),
        
        .data_out_address(addrb[10]),
        .data_out_read_enable(enb[10])
        );
    assign port_read_data[20] = doutb[10];
    assign port_read_data[21] = doutb[10];
    
    // ram's port write activation 
    assign ena[10] = port_write_en[20] | port_write_en[20];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_5_1
        (
        .clk(clk),
        .select(port_write_select[10]),
        
        .data_in(port_write_data[20:21]),
        .data_in_address(port_write_address[20:21]),
        .data_in_write_enable(port_write_we[20:21]),
        
        .data_out(dina[10]),
        .data_out_address(addra[10]),
        .data_out_write_enable(wea[10])
        );



// OUTPUT MEMORY
wire [7:0] registers_dina = data_write[19];
wire [31:0] registers_addra = data_write_address[19];
wire registers_we = data_write_we[19];
wire [7:0] registers_out[7];
ShiftRegisters	#(
                .WIDTH(8),
                .LENGTH(7)
                )
                output_registers
                (
                .clk(clk),
                .step(registers_we),
                .data_in(registers_dina),
                .registers_out(registers_out)
                );

assign write_possible = !il_last_data_received 
                        && enable[0] 
                        && !rst[0];
assign output_data = registers_out;
assign output_data_ready = finished[19] 
                           && enable[19] 
                           && !rst[19];
(* KEEP = "TRUE" *) reg enable_reg[4] = {1'b0,1'b0,1'b0,1'b0};
(* KEEP = "TRUE" *) reg sleep_reg[4] = {1'b0,1'b0,1'b0,1'b0};
(* KEEP = "TRUE" *) reg rst_reg[4] = {1'b1,1'b1,1'b1,1'b1};
wire [3:0] finished_step;

// registers assignments

// assign layers for state 0

assign enable[0] = enable_reg[0];
assign rst[0] = rst_reg[0];
assign sleep[0] = sleep_reg[0];

assign enable[2] = enable_reg[0];
assign rst[2] = rst_reg[0];
assign sleep[2] = sleep_reg[0];

assign enable[6] = enable_reg[0];
assign rst[6] = rst_reg[0];
assign sleep[6] = sleep_reg[0];

assign enable[10] = enable_reg[0];
assign rst[10] = rst_reg[0];
assign sleep[10] = sleep_reg[0];

assign enable[14] = enable_reg[0];
assign rst[14] = rst_reg[0];
assign sleep[14] = sleep_reg[0];

assign enable[18] = enable_reg[0];
assign rst[18] = rst_reg[0];
assign sleep[18] = sleep_reg[0];

// assign finished step
assign finished_step[0] = finished[0] && finished[2] && finished[6] && finished[10] && finished[14] && finished[18];

// assign layers for state 1

assign enable[3] = enable_reg[1];
assign rst[3] = rst_reg[1];
assign sleep[3] = sleep_reg[1];

assign enable[7] = enable_reg[1];
assign rst[7] = rst_reg[1];
assign sleep[7] = sleep_reg[1];

assign enable[11] = enable_reg[1];
assign rst[11] = rst_reg[1];
assign sleep[11] = sleep_reg[1];

assign enable[15] = enable_reg[1];
assign rst[15] = rst_reg[1];
assign sleep[15] = sleep_reg[1];

assign enable[19] = enable_reg[1];
assign rst[19] = rst_reg[1];
assign sleep[19] = sleep_reg[1];

// assign finished step
assign finished_step[1] = finished[3] && finished[7] && finished[11] && finished[15] && finished[19] && output_was_read;

// assign layers for state 2

assign enable[4] = enable_reg[2];
assign rst[4] = rst_reg[2];
assign sleep[4] = sleep_reg[2];

assign enable[8] = enable_reg[2];
assign rst[8] = rst_reg[2];
assign sleep[8] = sleep_reg[2];

assign enable[12] = enable_reg[2];
assign rst[12] = rst_reg[2];
assign sleep[12] = sleep_reg[2];

assign enable[16] = enable_reg[2];
assign rst[16] = rst_reg[2];
assign sleep[16] = sleep_reg[2];

// assign finished step
assign finished_step[2] = finished[4] && finished[8] && finished[12] && finished[16];

// assign layers for state 3

assign enable[1] = enable_reg[3];
assign rst[1] = rst_reg[3];
assign sleep[1] = sleep_reg[3];

assign enable[5] = enable_reg[3];
assign rst[5] = rst_reg[3];
assign sleep[5] = sleep_reg[3];

assign enable[9] = enable_reg[3];
assign rst[9] = rst_reg[3];
assign sleep[9] = sleep_reg[3];

assign enable[13] = enable_reg[3];
assign rst[13] = rst_reg[3];
assign sleep[13] = sleep_reg[3];

assign enable[17] = enable_reg[3];
assign rst[17] = rst_reg[3];
assign sleep[17] = sleep_reg[3];

// assign finished step
assign finished_step[3] = finished[1] && finished[5] && finished[9] && finished[13] && finished[17];


// ram ports assignments

    // read ports  
    
    assign data_read[1] = port_read_data[0];
    assign port_read_address[0] = data_read_address[1];
    assign port_read_en[0] = data_read_en[1];
    
    // read ports - unused 
    
    assign port_read_address[1] = 32'd0;
    assign port_read_en[1] = 1'b0;
    
    // write ports  
    
    assign data_write[0] = port_write_data[0];
    assign port_write_address[0] = data_write_address[0];
    assign port_write_we[0] = data_write_we[0];
    assign port_write_en[0] = enable[0];
    
    // write ports - unused 
    
    assign port_write_data[1] = 32'd0;
    assign port_write_address[1] = 32'd0;
    assign port_write_we[1] = 1'b0;
    assign port_write_en[1] = 1'b0;
    

    // read ports  
    
    assign data_read[2] = port_read_data[2];
    assign port_read_address[2] = data_read_address[2];
    assign port_read_en[2] = data_read_en[2];
    
    assign data_read[4] = port_read_data[3];
    assign port_read_address[3] = data_read_address[4];
    assign port_read_en[3] = data_read_en[4];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[1] = port_write_data[2];
    assign port_write_address[2] = data_write_address[1];
    assign port_write_we[2] = data_write_we[1];
    assign port_write_en[2] = enable[1];
    
    assign data_write[3] = port_write_data[3];
    assign port_write_address[3] = data_write_address[3];
    assign port_write_we[3] = data_write_we[3];
    assign port_write_en[3] = enable[3];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[3] = port_read_data[4];
    assign port_read_address[4] = data_read_address[3];
    assign port_read_en[4] = data_read_en[3];
    
    assign data_read[5] = port_read_data[5];
    assign port_read_address[5] = data_read_address[5];
    assign port_read_en[5] = data_read_en[5];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[2] = port_write_data[4];
    assign port_write_address[4] = data_write_address[2];
    assign port_write_we[4] = data_write_we[2];
    assign port_write_en[4] = enable[2];
    
    assign data_write[4] = port_write_data[5];
    assign port_write_address[5] = data_write_address[4];
    assign port_write_we[5] = data_write_we[4];
    assign port_write_en[5] = enable[4];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[6] = port_read_data[6];
    assign port_read_address[6] = data_read_address[6];
    assign port_read_en[6] = data_read_en[6];
    
    assign data_read[8] = port_read_data[7];
    assign port_read_address[7] = data_read_address[8];
    assign port_read_en[7] = data_read_en[8];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[5] = port_write_data[6];
    assign port_write_address[6] = data_write_address[5];
    assign port_write_we[6] = data_write_we[5];
    assign port_write_en[6] = enable[5];
    
    assign data_write[7] = port_write_data[7];
    assign port_write_address[7] = data_write_address[7];
    assign port_write_we[7] = data_write_we[7];
    assign port_write_en[7] = enable[7];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[7] = port_read_data[8];
    assign port_read_address[8] = data_read_address[7];
    assign port_read_en[8] = data_read_en[7];
    
    assign data_read[9] = port_read_data[9];
    assign port_read_address[9] = data_read_address[9];
    assign port_read_en[9] = data_read_en[9];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[6] = port_write_data[8];
    assign port_write_address[8] = data_write_address[6];
    assign port_write_we[8] = data_write_we[6];
    assign port_write_en[8] = enable[6];
    
    assign data_write[8] = port_write_data[9];
    assign port_write_address[9] = data_write_address[8];
    assign port_write_we[9] = data_write_we[8];
    assign port_write_en[9] = enable[8];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[10] = port_read_data[10];
    assign port_read_address[10] = data_read_address[10];
    assign port_read_en[10] = data_read_en[10];
    
    assign data_read[12] = port_read_data[11];
    assign port_read_address[11] = data_read_address[12];
    assign port_read_en[11] = data_read_en[12];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[9] = port_write_data[10];
    assign port_write_address[10] = data_write_address[9];
    assign port_write_we[10] = data_write_we[9];
    assign port_write_en[10] = enable[9];
    
    assign data_write[11] = port_write_data[11];
    assign port_write_address[11] = data_write_address[11];
    assign port_write_we[11] = data_write_we[11];
    assign port_write_en[11] = enable[11];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[11] = port_read_data[12];
    assign port_read_address[12] = data_read_address[11];
    assign port_read_en[12] = data_read_en[11];
    
    assign data_read[13] = port_read_data[13];
    assign port_read_address[13] = data_read_address[13];
    assign port_read_en[13] = data_read_en[13];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[10] = port_write_data[12];
    assign port_write_address[12] = data_write_address[10];
    assign port_write_we[12] = data_write_we[10];
    assign port_write_en[12] = enable[10];
    
    assign data_write[12] = port_write_data[13];
    assign port_write_address[13] = data_write_address[12];
    assign port_write_we[13] = data_write_we[12];
    assign port_write_en[13] = enable[12];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[14] = port_read_data[14];
    assign port_read_address[14] = data_read_address[14];
    assign port_read_en[14] = data_read_en[14];
    
    assign data_read[16] = port_read_data[15];
    assign port_read_address[15] = data_read_address[16];
    assign port_read_en[15] = data_read_en[16];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[13] = port_write_data[14];
    assign port_write_address[14] = data_write_address[13];
    assign port_write_we[14] = data_write_we[13];
    assign port_write_en[14] = enable[13];
    
    assign data_write[15] = port_write_data[15];
    assign port_write_address[15] = data_write_address[15];
    assign port_write_we[15] = data_write_we[15];
    assign port_write_en[15] = enable[15];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[15] = port_read_data[16];
    assign port_read_address[16] = data_read_address[15];
    assign port_read_en[16] = data_read_en[15];
    
    assign data_read[17] = port_read_data[17];
    assign port_read_address[17] = data_read_address[17];
    assign port_read_en[17] = data_read_en[17];
    
    // read ports - unused 
    
    // write ports  
    
    assign data_write[14] = port_write_data[16];
    assign port_write_address[16] = data_write_address[14];
    assign port_write_we[16] = data_write_we[14];
    assign port_write_en[16] = enable[14];
    
    assign data_write[16] = port_write_data[17];
    assign port_write_address[17] = data_write_address[16];
    assign port_write_we[17] = data_write_we[16];
    assign port_write_en[17] = enable[16];
    
    // write ports - unused 
    

    // read ports  
    
    assign data_read[18] = port_read_data[18];
    assign port_read_address[18] = data_read_address[18];
    assign port_read_en[18] = data_read_en[18];
    
    // read ports - unused 
    
    assign port_read_address[19] = 32'd0;
    assign port_read_en[19] = 1'b0;
    
    // write ports  
    
    assign data_write[17] = port_write_data[18];
    assign port_write_address[18] = data_write_address[17];
    assign port_write_we[18] = data_write_we[17];
    assign port_write_en[18] = enable[17];
    
    // write ports - unused 
    
    assign port_write_data[19] = 32'd0;
    assign port_write_address[19] = 32'd0;
    assign port_write_we[19] = 1'b0;
    assign port_write_en[19] = 1'b0;
    

    // read ports  
    
    assign data_read[19] = port_read_data[20];
    assign port_read_address[20] = data_read_address[19];
    assign port_read_en[20] = data_read_en[19];
    
    // read ports - unused 
    
    assign port_read_address[21] = 32'd0;
    assign port_read_en[21] = 1'b0;
    
    // write ports  
    
    assign data_write[18] = port_write_data[20];
    assign port_write_address[20] = data_write_address[18];
    assign port_write_we[20] = data_write_we[18];
    assign port_write_en[20] = enable[18];
    
    // write ports - unused 
    
    assign port_write_data[21] = 32'd0;
    assign port_write_address[21] = 32'd0;
    assign port_write_we[21] = 1'b0;
    assign port_write_en[21] = 1'b0;
    


(* KEEP = "TRUE" *)
reg [3:0] state = 4'd13;

localparam AWAKENING_TIME = 17;
localparam AWAKENING_TIME_BITS = $clog2(AWAKENING_TIME);
(* KEEP = "TRUE" *) reg [AWAKENING_TIME_BITS-1:0] awakening_cntr = 0;
	
always @(posedge clk)
    begin
    if (reset)
        begin
        // GO TO RESET ALL STATE
        state <= 4'd13;
        end
    else
        begin
        case (state)
        // initial step
        4'd0:
            begin
            // turn off all resets
            rst_reg <= {1'b0,1'b0,1'b0,1'b0};
            // turn off all modules
            enable_reg <= {1'b0,1'b0,1'b0,1'b0};
            // put sleep all modules
            sleep_reg <= {1'b1,1'b1,1'b1,1'b1};
            // awake all rams
            awakening_cntr <= 0;
            // to first processing step
            state <= 4'd1;
            end
            
        // first processing step
        4'd1:
            begin
            rst_reg[0] <= 1'b1;
            sleep_reg[0] <= 1'b0;
            // awakening of roms time
            if (awakening_cntr == AWAKENING_TIME-1)
                begin
                awakening_cntr <= 0;
                // go to enabling state
                state <= 4'd2;
                end
            else
                awakening_cntr <= awakening_cntr+1;
            end
        // turn off resets
        4'd2:
            begin
            // put to sleep prev state layers
            sleep_reg[3] <= 1'b1;
            // stop resetting
            rst_reg[0] <= 1'b0;
            // turn on layers
            enable_reg[0] <= 1'b1;
            // to working state
            state <= 4'd3;
            end
        4'd3:
            begin
            // turn off finished layers if finish work
            if ( finished[0])
                begin
                enable_reg[0] <= 1'b0;
                // next processing step
                state <= 4'd4;
                end
            end
            
        // second processing step
        4'd4:
            begin
            rst_reg[1] <= 1'b1;
            sleep_reg[1] <= 1'b0;
            // awakening of rams time
            if (awakening_cntr == AWAKENING_TIME-1)
                begin
                awakening_cntr <= 0;
                // go to enabling state
                state <= 4'd5;
                end
            else
                awakening_cntr <= awakening_cntr+1;
            end
        // turn off resets
        4'd5:
            begin
            // put sleep prev layers
            sleep_reg[0] <= 1'b1;
            // stop resetting
            rst_reg[1] <= 1'b0;
            // turn on layers
            enable_reg[1] <= 1'b1;
            // to working state
            state <= 4'd6;
            end
        4'd6:
            begin
            // turn off finished layers if finish work
            if ( finished[1])
                begin
                enable_reg[1] <= 1'b0;
                // next processing step
                state <= 4'd7;
                end
            end
        
        // third processing step
        4'd7:
            begin
            rst_reg[2] <= 1'b1;
            sleep_reg[2] <= 1'b0;
            // awakening of rams time
            if (awakening_cntr == AWAKENING_TIME-1)
                begin
                awakening_cntr <= 0;
                // go to enabling state
                state <= 4'd8;
                end
            else
                awakening_cntr <= awakening_cntr+1;
            end
        // turn off resets
        4'd8:
            begin
            // put to sleep prev layers
            sleep_reg[1] <= 1'b1;
            // stop resetting
            rst_reg[2] <= 1'b0;
            // turn on
            enable_reg[2] <= 1'b1;
            // to working state
            state <= 4'd9;
            end
        4'd9:
            begin
            // turn off finished layers if finish work
            if (finished[2])
                begin
                enable_reg[2] <= 1'b0;
                // next processing step
                state <= 4'd10;
                end
            end
        
        // fourth processing step
        4'd10:
            begin
            rst_reg[3] <= 1'b1;
            sleep_reg[3] <= 1'b0;
            // awakening of roms time
            if (awakening_cntr == AWAKENING_TIME-1)
                begin
                awakening_cntr <= 0;
                // go to enabling state
                state <= 4'd11;
                end
            else
                awakening_cntr <= awakening_cntr+1;
            end
        // turn off resets
        4'd11:
            begin
            // put to sleep prev layers
            sleep_reg[2] <= 1'b1;
            // stop resetting
            rst_reg[3] <= 1'b0;
            // turn on
            enable_reg[3] <= 1'b1;
            // to working state
            state <= 4'd12;
            end
        4'd12:
            begin
            // turn off finished layers if finish work
            if (finished[3])
                begin
                enable_reg[3] <= 1'b0;
                // next processing step
                state <= 4'd1;
                // OR reset all
                // state <= 4'd13;
                end
            end
        // RESET STEP
        4'd13:
            begin
            // RESET ALL
            // turn on all resets
            rst_reg <= {1'b1,1'b1,1'b1,1'b1};
            // disable all modules
            enable_reg <= {1'b0,1'b0,1'b0,1'b0};
            
            awakening_cntr <= 0;
            // to init step
            state <= 4'd0;
            end
        default:
            begin
            // to RESET ALL STEP
            state <= 4'd13;
            end
        endcase
        end
    end
endmodule