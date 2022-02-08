

module LittleNetAcc 
    (
    input clk,
    input reset,
    
    input [31:0] s_axis_tdata,
    input [3:0] s_axis_tkeep,
    input s_axis_tlast,
    input s_axis_tvalid,
    output s_axis_tready,
    
    output [31:0] m_axis_tdata,
    output [3:0] m_axis_tkeep,
    output m_axis_tlast,
    output m_axis_tvalid,
    input m_axis_tready
    );

(* KEEP = "TRUE" *)
reg [3:0] state = 4'd13;

wire enable[22];
wire rst[22];
wire finished[22];
wire sleep[22];
wire [7:0] data_read[22];
wire [31:0] data_read_address[22];
wire data_read_en[22];
wire [31:0] data_write[22];
wire [31:0] data_write_address[22];
wire data_write_we[22];


    InputLayer
		#(
		.BIT_WIDTH(8),
		.WIDTH(208),
		.HEIGHT(112),
		.CHANNELS(3),
		.GROUPS(4),
		.WRITE_MEMORY_LATENCY(9)
		)
		layer_0_il
		(
		.clk(clk),
		.enable(enable[0]),
		.reset(rst[0]),
        .axis_tdata(s_axis_tdata),
        .axis_tkeep(s_axis_tkeep),
        .axis_tlast(s_axis_tlast),
        .axis_tvalid(s_axis_tvalid),
        .axis_tready(s_axis_tready),        
        .data_out(data_write[0]),
		.data_out_address(data_write_address[0]),
		.data_out_validity(data_write_we[0]),
		.finished(finished[0])
		);
    assign data_read_en[0] = 1'b0;
    assign data_read_address[0] = 32'd0;
    assign data_read[0] = 8'd0;
    
    wire [7:0] layer_0_il_r  = data_read[0];
    wire [31:0] layer_0_il_r_addr  = data_read_address[0];
    wire layer_0_il_r_en = data_read_en[0];
    wire [7:0] layer_0_il_w_byte_3  = data_write[0][(3+1)*8-1:3*8];
    wire [7:0] layer_0_il_w_byte_2  = data_write[0][(2+1)*8-1:2*8];
    wire [7:0] layer_0_il_w_byte_1  = data_write[0][(1+1)*8-1:1*8];
    wire [7:0] layer_0_il_w_byte_0  = data_write[0][(0+1)*8-1:0*8];
    wire [31:0] layer_0_il_w_addr  = data_write_address[0];
    wire layer_0_il_w_en  = data_write_we[0];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_0_il")
        ) 
        layer_0_il_file_writer
        (
        .clk(clk),
        .ena(enable[0]),
        .dina(data_write[0]),
        .addra(data_write_address[0]),
        .wea(data_write_we[0]),
        .state(state)
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
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(66),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_1_dw_%01d.mem"),
      .LATENCY(8),
      .USE_SLEEP(1),
      .MEMO_TYPE("block")
      )
      rom_layer_1_dw
        (
        .clka(clk),
        .sleep(sleep[1]),
        .douta(data_weight_1),
        .addra(data_weight_address_1),
        .ena(data_weight_en_1)
        );
    wire [7:0] layer_1_dw_r  = data_read[1];
    wire [31:0] layer_1_dw_r_addr  = data_read_address[1];
    wire layer_1_dw_r_en = data_read_en[1];
    wire [7:0] layer_1_dw_w_byte_3  = data_write[1][(3+1)*8-1:3*8];
    wire [7:0] layer_1_dw_w_byte_2  = data_write[1][(2+1)*8-1:2*8];
    wire [7:0] layer_1_dw_w_byte_1  = data_write[1][(1+1)*8-1:1*8];
    wire [7:0] layer_1_dw_w_byte_0  = data_write[1][(0+1)*8-1:0*8];
    wire [31:0] layer_1_dw_w_addr  = data_write_address[1];
    wire layer_1_dw_w_en  = data_write_we[1];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_1_dw")
        ) 
        layer_1_dw_file_writer
        (
        .clk(clk),
        .ena(enable[1]),
        .dina(data_write[1]),
        .addra(data_write_address[1]),
        .wea(data_write_we[1]),
        .state(state)
        );

    wire [4*8-1:0] data_weight_2;
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
        .PARALLELISM(4),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(18),
      .DATA_WIDTH(4*8),
      .init_file_name_format("rom_layer_2_pw_%01d.mem"),
      .LATENCY(8),
      .USE_SLEEP(1),
      .MEMO_TYPE("block")
      )
      rom_layer_2_pw
        (
        .clka(clk),
        .sleep(sleep[2]),
        .douta(data_weight_2),
        .addra(data_weight_address_2),
        .ena(data_weight_en_2)
        );
    wire [7:0] layer_2_pw_r  = data_read[2];
    wire [31:0] layer_2_pw_r_addr  = data_read_address[2];
    wire layer_2_pw_r_en = data_read_en[2];
    wire [7:0] layer_2_pw_w_byte_3  = data_write[2][(3+1)*8-1:3*8];
    wire [7:0] layer_2_pw_w_byte_2  = data_write[2][(2+1)*8-1:2*8];
    wire [7:0] layer_2_pw_w_byte_1  = data_write[2][(1+1)*8-1:1*8];
    wire [7:0] layer_2_pw_w_byte_0  = data_write[2][(0+1)*8-1:0*8];
    wire [31:0] layer_2_pw_w_addr  = data_write_address[2];
    wire layer_2_pw_w_en  = data_write_we[2];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_2_pw")
        ) 
        layer_2_pw_file_writer
        (
        .clk(clk),
        .ena(enable[2]),
        .dina(data_write[2]),
        .addra(data_write_address[2]),
        .wea(data_write_we[2]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(96),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_3_dw_%01d.mem"),
      .LATENCY(8),
      .USE_SLEEP(1),
      .MEMO_TYPE("block")
      )
      rom_layer_3_dw
        (
        .clka(clk),
        .sleep(sleep[3]),
        .douta(data_weight_3),
        .addra(data_weight_address_3),
        .ena(data_weight_en_3)
        );
    wire [7:0] layer_3_dw_r  = data_read[3];
    wire [31:0] layer_3_dw_r_addr  = data_read_address[3];
    wire layer_3_dw_r_en = data_read_en[3];
    wire [7:0] layer_3_dw_w_byte_3  = data_write[3][(3+1)*8-1:3*8];
    wire [7:0] layer_3_dw_w_byte_2  = data_write[3][(2+1)*8-1:2*8];
    wire [7:0] layer_3_dw_w_byte_1  = data_write[3][(1+1)*8-1:1*8];
    wire [7:0] layer_3_dw_w_byte_0  = data_write[3][(0+1)*8-1:0*8];
    wire [31:0] layer_3_dw_w_addr  = data_write_address[3];
    wire layer_3_dw_w_en  = data_write_we[3];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_3_dw")
        ) 
        layer_3_dw_file_writer
        (
        .clk(clk),
        .ena(enable[3]),
        .dina(data_write[3]),
        .addra(data_write_address[3]),
        .wea(data_write_we[3]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(176),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_4_dw_%01d.mem"),
      .LATENCY(8),
      .USE_SLEEP(1),
      .MEMO_TYPE("block")
      )
      rom_layer_4_dw
        (
        .clka(clk),
        .sleep(sleep[4]),
        .douta(data_weight_4),
        .addra(data_weight_address_4),
        .ena(data_weight_en_4)
        );
    wire [7:0] layer_4_dw_r  = data_read[4];
    wire [31:0] layer_4_dw_r_addr  = data_read_address[4];
    wire layer_4_dw_r_en = data_read_en[4];
    wire [7:0] layer_4_dw_w_byte_3  = data_write[4][(3+1)*8-1:3*8];
    wire [7:0] layer_4_dw_w_byte_2  = data_write[4][(2+1)*8-1:2*8];
    wire [7:0] layer_4_dw_w_byte_1  = data_write[4][(1+1)*8-1:1*8];
    wire [7:0] layer_4_dw_w_byte_0  = data_write[4][(0+1)*8-1:0*8];
    wire [31:0] layer_4_dw_w_addr  = data_write_address[4];
    wire layer_4_dw_w_en  = data_write_we[4];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_4_dw")
        ) 
        layer_4_dw_file_writer
        (
        .clk(clk),
        .ena(enable[4]),
        .dina(data_write[4]),
        .addra(data_write_address[4]),
        .wea(data_write_we[4]),
        .state(state)
        );

    wire [8*8-1:0] data_weight_5;
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
        .PARALLELISM(8),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(76),
      .DATA_WIDTH(8*8),
      .init_file_name_format("rom_layer_5_pw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_5_pw_r  = data_read[5];
    wire [31:0] layer_5_pw_r_addr  = data_read_address[5];
    wire layer_5_pw_r_en = data_read_en[5];
    wire [7:0] layer_5_pw_w_byte_3  = data_write[5][(3+1)*8-1:3*8];
    wire [7:0] layer_5_pw_w_byte_2  = data_write[5][(2+1)*8-1:2*8];
    wire [7:0] layer_5_pw_w_byte_1  = data_write[5][(1+1)*8-1:1*8];
    wire [7:0] layer_5_pw_w_byte_0  = data_write[5][(0+1)*8-1:0*8];
    wire [31:0] layer_5_pw_w_addr  = data_write_address[5];
    wire layer_5_pw_w_en  = data_write_we[5];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_5_pw")
        ) 
        layer_5_pw_file_writer
        (
        .clk(clk),
        .ena(enable[5]),
        .dina(data_write[5]),
        .addra(data_write_address[5]),
        .wea(data_write_we[5]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(384),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_6_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_6_dw_r  = data_read[6];
    wire [31:0] layer_6_dw_r_addr  = data_read_address[6];
    wire layer_6_dw_r_en = data_read_en[6];
    wire [7:0] layer_6_dw_w_byte_3  = data_write[6][(3+1)*8-1:3*8];
    wire [7:0] layer_6_dw_w_byte_2  = data_write[6][(2+1)*8-1:2*8];
    wire [7:0] layer_6_dw_w_byte_1  = data_write[6][(1+1)*8-1:1*8];
    wire [7:0] layer_6_dw_w_byte_0  = data_write[6][(0+1)*8-1:0*8];
    wire [31:0] layer_6_dw_w_addr  = data_write_address[6];
    wire layer_6_dw_w_en  = data_write_we[6];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_6_dw")
        ) 
        layer_6_dw_file_writer
        (
        .clk(clk),
        .ena(enable[6]),
        .dina(data_write[6]),
        .addra(data_write_address[6]),
        .wea(data_write_we[6]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(704),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_7_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_7_dw_r  = data_read[7];
    wire [31:0] layer_7_dw_r_addr  = data_read_address[7];
    wire layer_7_dw_r_en = data_read_en[7];
    wire [7:0] layer_7_dw_w_byte_3  = data_write[7][(3+1)*8-1:3*8];
    wire [7:0] layer_7_dw_w_byte_2  = data_write[7][(2+1)*8-1:2*8];
    wire [7:0] layer_7_dw_w_byte_1  = data_write[7][(1+1)*8-1:1*8];
    wire [7:0] layer_7_dw_w_byte_0  = data_write[7][(0+1)*8-1:0*8];
    wire [31:0] layer_7_dw_w_addr  = data_write_address[7];
    wire layer_7_dw_w_en  = data_write_we[7];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_7_dw")
        ) 
        layer_7_dw_file_writer
        (
        .clk(clk),
        .ena(enable[7]),
        .dina(data_write[7]),
        .addra(data_write_address[7]),
        .wea(data_write_we[7]),
        .state(state)
        );

    wire [9*8-1:0] data_weight_8;
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
        .PARALLELISM(9),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(528),
      .DATA_WIDTH(9*8),
      .init_file_name_format("rom_layer_8_pw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_8_pw_r  = data_read[8];
    wire [31:0] layer_8_pw_r_addr  = data_read_address[8];
    wire layer_8_pw_r_en = data_read_en[8];
    wire [7:0] layer_8_pw_w_byte_3  = data_write[8][(3+1)*8-1:3*8];
    wire [7:0] layer_8_pw_w_byte_2  = data_write[8][(2+1)*8-1:2*8];
    wire [7:0] layer_8_pw_w_byte_1  = data_write[8][(1+1)*8-1:1*8];
    wire [7:0] layer_8_pw_w_byte_0  = data_write[8][(0+1)*8-1:0*8];
    wire [31:0] layer_8_pw_w_addr  = data_write_address[8];
    wire layer_8_pw_w_en  = data_write_we[8];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_8_pw")
        ) 
        layer_8_pw_file_writer
        (
        .clk(clk),
        .ena(enable[8]),
        .dina(data_write[8]),
        .addra(data_write_address[8]),
        .wea(data_write_we[8]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(768),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_9_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_9_dw_r  = data_read[9];
    wire [31:0] layer_9_dw_r_addr  = data_read_address[9];
    wire layer_9_dw_r_en = data_read_en[9];
    wire [7:0] layer_9_dw_w_byte_3  = data_write[9][(3+1)*8-1:3*8];
    wire [7:0] layer_9_dw_w_byte_2  = data_write[9][(2+1)*8-1:2*8];
    wire [7:0] layer_9_dw_w_byte_1  = data_write[9][(1+1)*8-1:1*8];
    wire [7:0] layer_9_dw_w_byte_0  = data_write[9][(0+1)*8-1:0*8];
    wire [31:0] layer_9_dw_w_addr  = data_write_address[9];
    wire layer_9_dw_w_en  = data_write_we[9];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_9_dw")
        ) 
        layer_9_dw_file_writer
        (
        .clk(clk),
        .ena(enable[9]),
        .dina(data_write[9]),
        .addra(data_write_address[9]),
        .wea(data_write_we[9]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(1536),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_10_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_10_dw_r  = data_read[10];
    wire [31:0] layer_10_dw_r_addr  = data_read_address[10];
    wire layer_10_dw_r_en = data_read_en[10];
    wire [7:0] layer_10_dw_w_byte_3  = data_write[10][(3+1)*8-1:3*8];
    wire [7:0] layer_10_dw_w_byte_2  = data_write[10][(2+1)*8-1:2*8];
    wire [7:0] layer_10_dw_w_byte_1  = data_write[10][(1+1)*8-1:1*8];
    wire [7:0] layer_10_dw_w_byte_0  = data_write[10][(0+1)*8-1:0*8];
    wire [31:0] layer_10_dw_w_addr  = data_write_address[10];
    wire layer_10_dw_w_en  = data_write_we[10];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_10_dw")
        ) 
        layer_10_dw_file_writer
        (
        .clk(clk),
        .ena(enable[10]),
        .dina(data_write[10]),
        .addra(data_write_address[10]),
        .wea(data_write_we[10]),
        .state(state)
        );

    wire [9*8-1:0] data_weight_11;
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
        .PARALLELISM(9),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(2080),
      .DATA_WIDTH(9*8),
      .init_file_name_format("rom_layer_11_pw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_11_pw_r  = data_read[11];
    wire [31:0] layer_11_pw_r_addr  = data_read_address[11];
    wire layer_11_pw_r_en = data_read_en[11];
    wire [7:0] layer_11_pw_w_byte_3  = data_write[11][(3+1)*8-1:3*8];
    wire [7:0] layer_11_pw_w_byte_2  = data_write[11][(2+1)*8-1:2*8];
    wire [7:0] layer_11_pw_w_byte_1  = data_write[11][(1+1)*8-1:1*8];
    wire [7:0] layer_11_pw_w_byte_0  = data_write[11][(0+1)*8-1:0*8];
    wire [31:0] layer_11_pw_w_addr  = data_write_address[11];
    wire layer_11_pw_w_en  = data_write_we[11];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_11_pw")
        ) 
        layer_11_pw_file_writer
        (
        .clk(clk),
        .ena(enable[11]),
        .dina(data_write[11]),
        .addra(data_write_address[11]),
        .wea(data_write_we[11]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(1536),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_12_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_12_dw_r  = data_read[12];
    wire [31:0] layer_12_dw_r_addr  = data_read_address[12];
    wire layer_12_dw_r_en = data_read_en[12];
    wire [7:0] layer_12_dw_w_byte_3  = data_write[12][(3+1)*8-1:3*8];
    wire [7:0] layer_12_dw_w_byte_2  = data_write[12][(2+1)*8-1:2*8];
    wire [7:0] layer_12_dw_w_byte_1  = data_write[12][(1+1)*8-1:1*8];
    wire [7:0] layer_12_dw_w_byte_0  = data_write[12][(0+1)*8-1:0*8];
    wire [31:0] layer_12_dw_w_addr  = data_write_address[12];
    wire layer_12_dw_w_en  = data_write_we[12];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_12_dw")
        ) 
        layer_12_dw_file_writer
        (
        .clk(clk),
        .ena(enable[12]),
        .dina(data_write[12]),
        .addra(data_write_address[12]),
        .wea(data_write_we[12]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(3072),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_13_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_13_dw_r  = data_read[13];
    wire [31:0] layer_13_dw_r_addr  = data_read_address[13];
    wire layer_13_dw_r_en = data_read_en[13];
    wire [7:0] layer_13_dw_w_byte_3  = data_write[13][(3+1)*8-1:3*8];
    wire [7:0] layer_13_dw_w_byte_2  = data_write[13][(2+1)*8-1:2*8];
    wire [7:0] layer_13_dw_w_byte_1  = data_write[13][(1+1)*8-1:1*8];
    wire [7:0] layer_13_dw_w_byte_0  = data_write[13][(0+1)*8-1:0*8];
    wire [31:0] layer_13_dw_w_addr  = data_write_address[13];
    wire layer_13_dw_w_en  = data_write_we[13];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_13_dw")
        ) 
        layer_13_dw_file_writer
        (
        .clk(clk),
        .ena(enable[13]),
        .dina(data_write[13]),
        .addra(data_write_address[13]),
        .wea(data_write_we[13]),
        .state(state)
        );

    wire [11*8-1:0] data_weight_14;
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
        .PARALLELISM(11),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(6216),
      .DATA_WIDTH(11*8),
      .init_file_name_format("rom_layer_14_pw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_14_pw_r  = data_read[14];
    wire [31:0] layer_14_pw_r_addr  = data_read_address[14];
    wire layer_14_pw_r_en = data_read_en[14];
    wire [7:0] layer_14_pw_w_byte_3  = data_write[14][(3+1)*8-1:3*8];
    wire [7:0] layer_14_pw_w_byte_2  = data_write[14][(2+1)*8-1:2*8];
    wire [7:0] layer_14_pw_w_byte_1  = data_write[14][(1+1)*8-1:1*8];
    wire [7:0] layer_14_pw_w_byte_0  = data_write[14][(0+1)*8-1:0*8];
    wire [31:0] layer_14_pw_w_addr  = data_write_address[14];
    wire layer_14_pw_w_en  = data_write_we[14];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_14_pw")
        ) 
        layer_14_pw_file_writer
        (
        .clk(clk),
        .ena(enable[14]),
        .dina(data_write[14]),
        .addra(data_write_address[14]),
        .wea(data_write_we[14]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(3072),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_15_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_15_dw_r  = data_read[15];
    wire [31:0] layer_15_dw_r_addr  = data_read_address[15];
    wire layer_15_dw_r_en = data_read_en[15];
    wire [7:0] layer_15_dw_w_byte_3  = data_write[15][(3+1)*8-1:3*8];
    wire [7:0] layer_15_dw_w_byte_2  = data_write[15][(2+1)*8-1:2*8];
    wire [7:0] layer_15_dw_w_byte_1  = data_write[15][(1+1)*8-1:1*8];
    wire [7:0] layer_15_dw_w_byte_0  = data_write[15][(0+1)*8-1:0*8];
    wire [31:0] layer_15_dw_w_addr  = data_write_address[15];
    wire layer_15_dw_w_en  = data_write_we[15];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_15_dw")
        ) 
        layer_15_dw_file_writer
        (
        .clk(clk),
        .ena(enable[15]),
        .dina(data_write[15]),
        .addra(data_write_address[15]),
        .wea(data_write_we[15]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(6144),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_16_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_16_dw_r  = data_read[16];
    wire [31:0] layer_16_dw_r_addr  = data_read_address[16];
    wire layer_16_dw_r_en = data_read_en[16];
    wire [7:0] layer_16_dw_w_byte_3  = data_write[16][(3+1)*8-1:3*8];
    wire [7:0] layer_16_dw_w_byte_2  = data_write[16][(2+1)*8-1:2*8];
    wire [7:0] layer_16_dw_w_byte_1  = data_write[16][(1+1)*8-1:1*8];
    wire [7:0] layer_16_dw_w_byte_0  = data_write[16][(0+1)*8-1:0*8];
    wire [31:0] layer_16_dw_w_addr  = data_write_address[16];
    wire layer_16_dw_w_en  = data_write_we[16];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_16_dw")
        ) 
        layer_16_dw_file_writer
        (
        .clk(clk),
        .ena(enable[16]),
        .dina(data_write[16]),
        .addra(data_write_address[16]),
        .wea(data_write_we[16]),
        .state(state)
        );

    wire [16*8-1:0] data_weight_17;
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
        .PARALLELISM(16),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(8240),
      .DATA_WIDTH(16*8),
      .init_file_name_format("rom_layer_17_pw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_17_pw_r  = data_read[17];
    wire [31:0] layer_17_pw_r_addr  = data_read_address[17];
    wire layer_17_pw_r_en = data_read_en[17];
    wire [7:0] layer_17_pw_w_byte_3  = data_write[17][(3+1)*8-1:3*8];
    wire [7:0] layer_17_pw_w_byte_2  = data_write[17][(2+1)*8-1:2*8];
    wire [7:0] layer_17_pw_w_byte_1  = data_write[17][(1+1)*8-1:1*8];
    wire [7:0] layer_17_pw_w_byte_0  = data_write[17][(0+1)*8-1:0*8];
    wire [31:0] layer_17_pw_w_addr  = data_write_address[17];
    wire layer_17_pw_w_en  = data_write_we[17];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_17_pw")
        ) 
        layer_17_pw_file_writer
        (
        .clk(clk),
        .ena(enable[17]),
        .dina(data_write[17]),
        .addra(data_write_address[17]),
        .wea(data_write_we[17]),
        .state(state)
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
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(2816),
      .DATA_WIDTH(8),
      .init_file_name_format("rom_layer_18_dw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_18_dw_r  = data_read[18];
    wire [31:0] layer_18_dw_r_addr  = data_read_address[18];
    wire layer_18_dw_r_en = data_read_en[18];
    wire [7:0] layer_18_dw_w_byte_3  = data_write[18][(3+1)*8-1:3*8];
    wire [7:0] layer_18_dw_w_byte_2  = data_write[18][(2+1)*8-1:2*8];
    wire [7:0] layer_18_dw_w_byte_1  = data_write[18][(1+1)*8-1:1*8];
    wire [7:0] layer_18_dw_w_byte_0  = data_write[18][(0+1)*8-1:0*8];
    wire [31:0] layer_18_dw_w_addr  = data_write_address[18];
    wire layer_18_dw_w_en  = data_write_we[18];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_18_dw")
        ) 
        layer_18_dw_file_writer
        (
        .clk(clk),
        .ena(enable[18]),
        .dina(data_write[18]),
        .addra(data_write_address[18]),
        .wea(data_write_we[18]),
        .state(state)
        );

    wire [1*8-1:0] data_weight_19;
    wire [31:0] data_weight_address_19;
    wire data_weight_en_19;
    
    PointwiseConv2dUnit#(
        .IN_WIDTH(13),
        .IN_HEIGHT(7),
        .IN_CHANNELS(256),
        .OUT_CHANNELS(16),
        .USE_BIAS(1),
        .USE_BN(0),
        .USE_RELU(0),
        .USE_MAXPOOL(0),
        .USE_MAXPOOL_CEIL_MODE(0),
        .PARALLELISM(1),
        .GROUPS(4),
        .IN_DATA_BIT_WIDTH(8),
        .IN_DATA_INT_WIDTH(4),
        .IN_DATA_SIGN(1),
        .WEIGHT_DATA_BIT_WIDTH(8),
        .WEIGHT_DATA_INT_WIDTH(3),
        .WEIGHT_DATA_SIGN(1),
        .BIAS_DATA_BIT_WIDTH(8),
        .BIAS_DATA_INT_WIDTH(3),
        .BIAS_DATA_SIGN(1),
        .INTER_DATA_BIT_WIDTH(8),
        .INTER_DATA_INT_WIDTH(4),
        .INTER_DATA_SIGN(1),
        .BN_W_DATA_BIT_WIDTH(8),
        .BN_W_DATA_INT_WIDTH(3),
        .BN_W_DATA_SIGN(1),
        .BN_B_DATA_BIT_WIDTH(8),
        .BN_B_DATA_INT_WIDTH(3),
        .BN_B_DATA_SIGN(1),
        .OUT_DATA_BIT_WIDTH(8),
        .OUT_DATA_INT_WIDTH(4),
        .OUT_DATA_SIGN(1),
        .READ_MEMORY_LATENCY(11),
        .READ_WEIGHT_MEMORY_LATENCY(8),
        .WRITE_MEMORY_LATENCY(9)
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
    CASCADED_ROM
      #(
      .LEN(4112),
      .DATA_WIDTH(1*8),
      .init_file_name_format("rom_layer_19_pw_%01d.mem"),
      .LATENCY(8),
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
    wire [7:0] layer_19_pw_r  = data_read[19];
    wire [31:0] layer_19_pw_r_addr  = data_read_address[19];
    wire layer_19_pw_r_en = data_read_en[19];
    wire [7:0] layer_19_pw_w_byte_3  = data_write[19][(3+1)*8-1:3*8];
    wire [7:0] layer_19_pw_w_byte_2  = data_write[19][(2+1)*8-1:2*8];
    wire [7:0] layer_19_pw_w_byte_1  = data_write[19][(1+1)*8-1:1*8];
    wire [7:0] layer_19_pw_w_byte_0  = data_write[19][(0+1)*8-1:0*8];
    wire [31:0] layer_19_pw_w_addr  = data_write_address[19];
    wire layer_19_pw_w_en  = data_write_we[19];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_19_pw")
        ) 
        layer_19_pw_file_writer
        (
        .clk(clk),
        .ena(enable[19]),
        .dina(data_write[19]),
        .addra(data_write_address[19]),
        .wea(data_write_we[19]),
        .state(state)
        );

    MaxFinderUnit
		#(
		.WIDTH(13),
		.HEIGHT(7),
		.CHANNELS(15),
		.BIT_WIDTH(8),
		.SIGNED(1),
        .READ_LATENCY(11),
        .WRITE_LATENCY(9)
		)
		layer_20_mf
	    (
        .clk(clk),
        .enable(enable[20]),
        .reset(rst[20]),
        .finished(finished[20]),
        .in_data_memory_out(data_read[20]),
        .in_data_memory_address(data_read_address[20]),
        .in_data_memory_read_enable(data_read_en[20]),
        .out_data_memory_in(data_write[20]),
		.out_data_memory_address(data_write_address[20]),
		.out_data_memory_write_enable(data_write_we[20])
		);    
    wire [7:0] layer_20_mf_r  = data_read[20];
    wire [31:0] layer_20_mf_r_addr  = data_read_address[20];
    wire layer_20_mf_r_en = data_read_en[20];
    wire [7:0] layer_20_mf_w_byte_3  = data_write[20][(3+1)*8-1:3*8];
    wire [7:0] layer_20_mf_w_byte_2  = data_write[20][(2+1)*8-1:2*8];
    wire [7:0] layer_20_mf_w_byte_1  = data_write[20][(1+1)*8-1:1*8];
    wire [7:0] layer_20_mf_w_byte_0  = data_write[20][(0+1)*8-1:0*8];
    wire [31:0] layer_20_mf_w_addr  = data_write_address[20];
    wire layer_20_mf_w_en  = data_write_we[20];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_20_mf")
        ) 
        layer_20_mf_file_writer
        (
        .clk(clk),
        .ena(enable[20]),
        .dina(data_write[20]),
        .addra(data_write_address[20]),
        .wea(data_write_we[20]),
        .state(state)
        );

    OutputLayer
		#(
		.SIZE(8),
        .READ_LATENCY(11)
		)
		layer_21_ol
	    (
        .clk(clk),
        .enable(enable[21]),
        .reset(rst[21]),
        .finished(finished[21]),
        .in_data_memory_out(data_read[21]),
        .in_data_memory_address(data_read_address[21]),
        .in_data_memory_read_enable(data_read_en[21]),
        .axis_tdata(m_axis_tdata),
        .axis_tkeep(m_axis_tkeep),
        .axis_tlast(m_axis_tlast),
        .axis_tvalid(m_axis_tvalid),
        .axis_tready(m_axis_tready)
        );
    assign data_write[21] = 32'd0;
    assign data_write_address[21] = 32'd0;
    assign data_write_we[21] = 1'b0;
    
    wire [7:0] layer_21_ol_r  = data_read[21];
    wire [31:0] layer_21_ol_r_addr  = data_read_address[21];
    wire layer_21_ol_r_en = data_read_en[21];
    wire [7:0] layer_21_ol_w_byte_3  = data_write[21][(3+1)*8-1:3*8];
    wire [7:0] layer_21_ol_w_byte_2  = data_write[21][(2+1)*8-1:2*8];
    wire [7:0] layer_21_ol_w_byte_1  = data_write[21][(1+1)*8-1:1*8];
    wire [7:0] layer_21_ol_w_byte_0  = data_write[21][(0+1)*8-1:0*8];
    wire [31:0] layer_21_ol_w_addr  = data_write_address[21];
    wire layer_21_ol_w_en  = data_write_we[21];

WriteFile 
        #(
        .NAME("/media/michal/HDD_Linux_2/LittleNet/tmp/layer_21_ol")
        ) 
        layer_21_ol_file_writer
        (
        .clk(clk),
        .ena(enable[21]),
        .dina(data_write[21]),
        .addra(data_write_address[21]),
        .wea(data_write_we[21]),
        .state(state)
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



    CASCADED_RAM
        #(
        .BYTE_LEN(69888),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_0_0_%0d.mem")
        )
        ram_0_0
        (
         .clka(clk),
         .ena(ena[0]),
         .dina(dina[0]),
         .addra(addra[0]),
         .wea(wea[0]),
         
         .clkb(clk),
         .enb(enb[0]),
         .doutb(doutb[0]),
         .addrb(addrb[0])
        );
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_0_0
        (
        .clk(clk),
        .select(port_read_select[0]),
        .data_in_address({port_read_address[0],port_read_address[1]}),
        .data_in_read_enable({port_read_en[0],port_read_en[1]}),
        
        .data_out_address(addrb[0]),
        .data_out_read_enable(enb[0])
        );
    assign port_read_data[0] = doutb[0];
    assign port_read_data[1] = doutb[0];
    
    // ram's port write activation
    assign ena[0] = port_write_en[0] | port_write_en[1];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_0_0
        (
        .clk(clk),
        .select(port_write_select[0]),
        
        .data_in({port_write_data[0],port_write_data[1]}),
        .data_in_address({port_write_address[0],port_write_address[1]}),
        .data_in_write_enable({port_write_we[0],port_write_we[1]}),
        
        .data_out(dina[0]),
        .data_out_address(addra[0]),
        .data_out_write_enable(wea[0])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(139776),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_0_1_%0d.mem")
        )
        ram_0_1
        (
         .clka(clk),
         .ena(ena[1]),
         .dina(dina[1]),
         .addra(addra[1]),
         .wea(wea[1]),
         
         .clkb(clk),
         .enb(enb[1]),
         .doutb(doutb[1]),
         .addrb(addrb[1])
        );
    MemoryReaderSelectorUnit
        #(
        .BIT_WIDTH(8),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        reader_selector_ram_0_1
        (
        .clk(clk),
        .select(port_read_select[1]),
        .data_in_address({port_read_address[2],port_read_address[3]}),
        .data_in_read_enable({port_read_en[2],port_read_en[3]}),
        
        .data_out_address(addrb[1]),
        .data_out_read_enable(enb[1])
        );
    assign port_read_data[2] = doutb[1];
    assign port_read_data[3] = doutb[1];
    
    // ram's port write activation
    assign ena[1] = port_write_en[2] | port_write_en[3];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_0_1
        (
        .clk(clk),
        .select(port_write_select[1]),
        
        .data_in({port_write_data[2],port_write_data[3]}),
        .data_in_address({port_write_address[2],port_write_address[3]}),
        .data_in_write_enable({port_write_we[2],port_write_we[3]}),
        
        .data_out(dina[1]),
        .data_out_address(addra[1]),
        .data_out_write_enable(wea[1])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(93184),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_1_0_%0d.mem")
        )
        ram_1_0
        (
         .clka(clk),
         .ena(ena[2]),
         .dina(dina[2]),
         .addra(addra[2]),
         .wea(wea[2]),
         
         .clkb(clk),
         .enb(enb[2]),
         .doutb(doutb[2]),
         .addrb(addrb[2])
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
        .select(port_read_select[2]),
        .data_in_address({port_read_address[4],port_read_address[5]}),
        .data_in_read_enable({port_read_en[4],port_read_en[5]}),
        
        .data_out_address(addrb[2]),
        .data_out_read_enable(enb[2])
        );
    assign port_read_data[4] = doutb[2];
    assign port_read_data[5] = doutb[2];
    
    // ram's port write activation
    assign ena[2] = port_write_en[4] | port_write_en[5];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_1_0
        (
        .clk(clk),
        .select(port_write_select[2]),
        
        .data_in({port_write_data[4],port_write_data[5]}),
        .data_in_address({port_write_address[4],port_write_address[5]}),
        .data_in_write_enable({port_write_we[4],port_write_we[5]}),
        
        .data_out(dina[2]),
        .data_out_address(addra[2]),
        .data_out_write_enable(wea[2])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(93184),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_1_1_%0d.mem")
        )
        ram_1_1
        (
         .clka(clk),
         .ena(ena[3]),
         .dina(dina[3]),
         .addra(addra[3]),
         .wea(wea[3]),
         
         .clkb(clk),
         .enb(enb[3]),
         .doutb(doutb[3]),
         .addrb(addrb[3])
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
        .select(port_read_select[3]),
        .data_in_address({port_read_address[6],port_read_address[7]}),
        .data_in_read_enable({port_read_en[6],port_read_en[7]}),
        
        .data_out_address(addrb[3]),
        .data_out_read_enable(enb[3])
        );
    assign port_read_data[6] = doutb[3];
    assign port_read_data[7] = doutb[3];
    
    // ram's port write activation
    assign ena[3] = port_write_en[6] | port_write_en[7];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_1_1
        (
        .clk(clk),
        .select(port_write_select[3]),
        
        .data_in({port_write_data[6],port_write_data[7]}),
        .data_in_address({port_write_address[6],port_write_address[7]}),
        .data_in_write_enable({port_write_we[6],port_write_we[7]}),
        
        .data_out(dina[3]),
        .data_out_address(addra[3]),
        .data_out_write_enable(wea[3])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(46592),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_2_0_%0d.mem")
        )
        ram_2_0
        (
         .clka(clk),
         .ena(ena[4]),
         .dina(dina[4]),
         .addra(addra[4]),
         .wea(wea[4]),
         
         .clkb(clk),
         .enb(enb[4]),
         .doutb(doutb[4]),
         .addrb(addrb[4])
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
        .select(port_read_select[4]),
        .data_in_address({port_read_address[8],port_read_address[9]}),
        .data_in_read_enable({port_read_en[8],port_read_en[9]}),
        
        .data_out_address(addrb[4]),
        .data_out_read_enable(enb[4])
        );
    assign port_read_data[8] = doutb[4];
    assign port_read_data[9] = doutb[4];
    
    // ram's port write activation
    assign ena[4] = port_write_en[8] | port_write_en[9];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_2_0
        (
        .clk(clk),
        .select(port_write_select[4]),
        
        .data_in({port_write_data[8],port_write_data[9]}),
        .data_in_address({port_write_address[8],port_write_address[9]}),
        .data_in_write_enable({port_write_we[8],port_write_we[9]}),
        
        .data_out(dina[4]),
        .data_out_address(addra[4]),
        .data_out_write_enable(wea[4])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_2_1_%0d.mem")
        )
        ram_2_1
        (
         .clka(clk),
         .ena(ena[5]),
         .dina(dina[5]),
         .addra(addra[5]),
         .wea(wea[5]),
         
         .clkb(clk),
         .enb(enb[5]),
         .doutb(doutb[5]),
         .addrb(addrb[5])
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
        .select(port_read_select[5]),
        .data_in_address({port_read_address[10],port_read_address[11]}),
        .data_in_read_enable({port_read_en[10],port_read_en[11]}),
        
        .data_out_address(addrb[5]),
        .data_out_read_enable(enb[5])
        );
    assign port_read_data[10] = doutb[5];
    assign port_read_data[11] = doutb[5];
    
    // ram's port write activation
    assign ena[5] = port_write_en[10] | port_write_en[11];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_2_1
        (
        .clk(clk),
        .select(port_write_select[5]),
        
        .data_in({port_write_data[10],port_write_data[11]}),
        .data_in_address({port_write_address[10],port_write_address[11]}),
        .data_in_write_enable({port_write_we[10],port_write_we[11]}),
        
        .data_out(dina[5]),
        .data_out_address(addra[5]),
        .data_out_write_enable(wea[5])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_3_0_%0d.mem")
        )
        ram_3_0
        (
         .clka(clk),
         .ena(ena[6]),
         .dina(dina[6]),
         .addra(addra[6]),
         .wea(wea[6]),
         
         .clkb(clk),
         .enb(enb[6]),
         .doutb(doutb[6]),
         .addrb(addrb[6])
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
        .select(port_read_select[6]),
        .data_in_address({port_read_address[12],port_read_address[13]}),
        .data_in_read_enable({port_read_en[12],port_read_en[13]}),
        
        .data_out_address(addrb[6]),
        .data_out_read_enable(enb[6])
        );
    assign port_read_data[12] = doutb[6];
    assign port_read_data[13] = doutb[6];
    
    // ram's port write activation
    assign ena[6] = port_write_en[12] | port_write_en[13];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_3_0
        (
        .clk(clk),
        .select(port_write_select[6]),
        
        .data_in({port_write_data[12],port_write_data[13]}),
        .data_in_address({port_write_address[12],port_write_address[13]}),
        .data_in_write_enable({port_write_we[12],port_write_we[13]}),
        
        .data_out(dina[6]),
        .data_out_address(addra[6]),
        .data_out_write_enable(wea[6])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_3_1_%0d.mem")
        )
        ram_3_1
        (
         .clka(clk),
         .ena(ena[7]),
         .dina(dina[7]),
         .addra(addra[7]),
         .wea(wea[7]),
         
         .clkb(clk),
         .enb(enb[7]),
         .doutb(doutb[7]),
         .addrb(addrb[7])
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
        .select(port_read_select[7]),
        .data_in_address({port_read_address[14],port_read_address[15]}),
        .data_in_read_enable({port_read_en[14],port_read_en[15]}),
        
        .data_out_address(addrb[7]),
        .data_out_read_enable(enb[7])
        );
    assign port_read_data[14] = doutb[7];
    assign port_read_data[15] = doutb[7];
    
    // ram's port write activation
    assign ena[7] = port_write_en[14] | port_write_en[15];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_3_1
        (
        .clk(clk),
        .select(port_write_select[7]),
        
        .data_in({port_write_data[14],port_write_data[15]}),
        .data_in_address({port_write_address[14],port_write_address[15]}),
        .data_in_write_enable({port_write_we[14],port_write_we[15]}),
        
        .data_out(dina[7]),
        .data_out_address(addra[7]),
        .data_out_write_enable(wea[7])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(46592),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_4_0_%0d.mem")
        )
        ram_4_0
        (
         .clka(clk),
         .ena(ena[8]),
         .dina(dina[8]),
         .addra(addra[8]),
         .wea(wea[8]),
         
         .clkb(clk),
         .enb(enb[8]),
         .doutb(doutb[8]),
         .addrb(addrb[8])
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
        .select(port_read_select[8]),
        .data_in_address({port_read_address[16],port_read_address[17]}),
        .data_in_read_enable({port_read_en[16],port_read_en[17]}),
        
        .data_out_address(addrb[8]),
        .data_out_read_enable(enb[8])
        );
    assign port_read_data[16] = doutb[8];
    assign port_read_data[17] = doutb[8];
    
    // ram's port write activation
    assign ena[8] = port_write_en[16] | port_write_en[17];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_4_0
        (
        .clk(clk),
        .select(port_write_select[8]),
        
        .data_in({port_write_data[16],port_write_data[17]}),
        .data_in_address({port_write_address[16],port_write_address[17]}),
        .data_in_write_enable({port_write_we[16],port_write_we[17]}),
        
        .data_out(dina[8]),
        .data_out_address(addra[8]),
        .data_out_write_enable(wea[8])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(23296),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_4_1_%0d.mem")
        )
        ram_4_1
        (
         .clka(clk),
         .ena(ena[9]),
         .dina(dina[9]),
         .addra(addra[9]),
         .wea(wea[9]),
         
         .clkb(clk),
         .enb(enb[9]),
         .doutb(doutb[9]),
         .addrb(addrb[9])
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
        .select(port_read_select[9]),
        .data_in_address({port_read_address[18],port_read_address[19]}),
        .data_in_read_enable({port_read_en[18],port_read_en[19]}),
        
        .data_out_address(addrb[9]),
        .data_out_read_enable(enb[9])
        );
    assign port_read_data[18] = doutb[9];
    assign port_read_data[19] = doutb[9];
    
    // ram's port write activation
    assign ena[9] = port_write_en[18] | port_write_en[19];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_4_1
        (
        .clk(clk),
        .select(port_write_select[9]),
        
        .data_in({port_write_data[18],port_write_data[19]}),
        .data_in_address({port_write_address[18],port_write_address[19]}),
        .data_in_write_enable({port_write_we[18],port_write_we[19]}),
        
        .data_out(dina[9]),
        .data_out_address(addra[9]),
        .data_out_write_enable(wea[9])
        );

    CASCADED_RAM
        #(
        .BYTE_LEN(8),
        .WRITE_WIDTH(32),
        .READ_WIDTH(8),
        .BYTE_SIZE(8),
        .WRITE_LATENCY(8),
        .READ_LATENCY(10),
        .INIT_FILE_FORMAT("RAM_5_0_%0d.mem")
        )
        ram_5_0
        (
         .clka(clk),
         .ena(ena[10]),
         .dina(dina[10]),
         .addra(addra[10]),
         .wea(wea[10]),
         
         .clkb(clk),
         .enb(enb[10]),
         .doutb(doutb[10]),
         .addrb(addrb[10])
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
        .select(port_read_select[10]),
        .data_in_address({port_read_address[20],port_read_address[21]}),
        .data_in_read_enable({port_read_en[20],port_read_en[21]}),
        
        .data_out_address(addrb[10]),
        .data_out_read_enable(enb[10])
        );
    assign port_read_data[20] = doutb[10];
    assign port_read_data[21] = doutb[10];
    
    // ram's port write activation
    assign ena[10] = port_write_en[20] | port_write_en[21];
    
    MemoryWriterSelectorUnit
        #(
        .BIT_WIDTH(32),
        .ADDRESS_BITS(32),
        .SOURCES(2)
        )
        writer_selector_ram_5_0
        (
        .clk(clk),
        .select(port_write_select[10]),
        
        .data_in({port_write_data[20],port_write_data[21]}),
        .data_in_address({port_write_address[20],port_write_address[21]}),
        .data_in_write_enable({port_write_we[20],port_write_we[21]}),
        
        .data_out(dina[10]),
        .data_out_address(addra[10]),
        .data_out_write_enable(wea[10])
        );
(* KEEP = "TRUE" *) reg enable_reg[4] = {1'b0,1'b0,1'b0,1'b0};
(* KEEP = "TRUE" *) reg sleep_reg[4] = {1'b0,1'b0,1'b0,1'b0};
(* KEEP = "TRUE" *) reg rst_reg[4] = {1'b1,1'b1,1'b1,1'b1};
wire [3:0] finished_step;

// registers assignments
// assign layer 0 to state 0 
assign enable[0] = enable_reg[0];
assign rst[0] = rst_reg[0];
assign sleep[0] = sleep_reg[0];
// assign layer 1 to state 1 
assign enable[1] = enable_reg[1];
assign rst[1] = rst_reg[1];
assign sleep[1] = sleep_reg[1];
// assign layer 2 to state 2 
assign enable[2] = enable_reg[2];
assign rst[2] = rst_reg[2];
assign sleep[2] = sleep_reg[2];
// assign layer 3 to state 3 
assign enable[3] = enable_reg[3];
assign rst[3] = rst_reg[3];
assign sleep[3] = sleep_reg[3];
// assign layer 4 to state 0 
assign enable[4] = enable_reg[0];
assign rst[4] = rst_reg[0];
assign sleep[4] = sleep_reg[0];
// assign layer 5 to state 1 
assign enable[5] = enable_reg[1];
assign rst[5] = rst_reg[1];
assign sleep[5] = sleep_reg[1];
// assign layer 6 to state 2 
assign enable[6] = enable_reg[2];
assign rst[6] = rst_reg[2];
assign sleep[6] = sleep_reg[2];
// assign layer 7 to state 3 
assign enable[7] = enable_reg[3];
assign rst[7] = rst_reg[3];
assign sleep[7] = sleep_reg[3];
// assign layer 8 to state 0 
assign enable[8] = enable_reg[0];
assign rst[8] = rst_reg[0];
assign sleep[8] = sleep_reg[0];
// assign layer 9 to state 1 
assign enable[9] = enable_reg[1];
assign rst[9] = rst_reg[1];
assign sleep[9] = sleep_reg[1];
// assign layer 10 to state 2 
assign enable[10] = enable_reg[2];
assign rst[10] = rst_reg[2];
assign sleep[10] = sleep_reg[2];
// assign layer 11 to state 3 
assign enable[11] = enable_reg[3];
assign rst[11] = rst_reg[3];
assign sleep[11] = sleep_reg[3];
// assign layer 12 to state 0 
assign enable[12] = enable_reg[0];
assign rst[12] = rst_reg[0];
assign sleep[12] = sleep_reg[0];
// assign layer 13 to state 1 
assign enable[13] = enable_reg[1];
assign rst[13] = rst_reg[1];
assign sleep[13] = sleep_reg[1];
// assign layer 14 to state 2 
assign enable[14] = enable_reg[2];
assign rst[14] = rst_reg[2];
assign sleep[14] = sleep_reg[2];
// assign layer 15 to state 3 
assign enable[15] = enable_reg[3];
assign rst[15] = rst_reg[3];
assign sleep[15] = sleep_reg[3];
// assign layer 16 to state 0 
assign enable[16] = enable_reg[0];
assign rst[16] = rst_reg[0];
assign sleep[16] = sleep_reg[0];
// assign layer 17 to state 1 
assign enable[17] = enable_reg[1];
assign rst[17] = rst_reg[1];
assign sleep[17] = sleep_reg[1];
// assign layer 18 to state 2 
assign enable[18] = enable_reg[2];
assign rst[18] = rst_reg[2];
assign sleep[18] = sleep_reg[2];
// assign layer 19 to state 3 
assign enable[19] = enable_reg[3];
assign rst[19] = rst_reg[3];
assign sleep[19] = sleep_reg[3];
// assign layer 20 to state 0 
assign enable[20] = enable_reg[0];
assign rst[20] = rst_reg[0];
assign sleep[20] = sleep_reg[0];
// assign layer 21 to state 1 
assign enable[21] = enable_reg[1];
assign rst[21] = rst_reg[1];
assign sleep[21] = sleep_reg[1];
// assign finished step
assign finished_step[0] = finished[0] && finished[4] && finished[8] && finished[12] && finished[16] && finished[20];
// assign finished step
assign finished_step[1] = finished[1] && finished[5] && finished[9] && finished[13] && finished[17] && finished[21];
// assign finished step
assign finished_step[2] = finished[2] && finished[6] && finished[10] && finished[14] && finished[18];
// assign finished step
assign finished_step[3] = finished[3] && finished[7] && finished[11] && finished[15] && finished[19];
// ram ports assignments

    // RAM 0
    
    // write select
    assign port_write_select[0] = enable[2];
    // 0
    assign port_write_data[0]= data_write[0];
    assign port_write_address[0] = data_write_address[0];
    assign port_write_we[0] = data_write_we[0];
    assign port_write_en[0] = enable[0];
    // 1
    assign port_write_data[1]= data_write[2];
    assign port_write_address[1] = data_write_address[2];
    assign port_write_we[1] = data_write_we[2];
    assign port_write_en[1] = enable[2];
    // read select
    assign port_read_select[0] = enable[3];
    // 0
    assign data_read[1] = port_read_data[0];
    assign port_read_address[0] = data_read_address[1];
    assign port_read_en[0] = data_read_en[1];
    // 1
    assign data_read[3] = port_read_data[1];
    assign port_read_address[1] = data_read_address[3];
    assign port_read_en[1] = data_read_en[3];
    
    // RAM 1
    
    // write select
    assign port_write_select[1] = enable[3];
    // 0
    assign port_write_data[2]= data_write[1];
    assign port_write_address[2] = data_write_address[1];
    assign port_write_we[2] = data_write_we[1];
    assign port_write_en[2] = enable[1];
    // 1
    assign port_write_data[3]= data_write[3];
    assign port_write_address[3] = data_write_address[3];
    assign port_write_we[3] = data_write_we[3];
    assign port_write_en[3] = enable[3];
    // read select
    assign port_read_select[1] = enable[4];
    // 0
    assign data_read[2] = port_read_data[2];
    assign port_read_address[2] = data_read_address[2];
    assign port_read_en[2] = data_read_en[2];
    // 1
    assign data_read[4] = port_read_data[3];
    assign port_read_address[3] = data_read_address[4];
    assign port_read_en[3] = data_read_en[4];
    
    // RAM 2
    
    // write select
    assign port_write_select[2] = enable[6];
    // 0
    assign port_write_data[4]= data_write[4];
    assign port_write_address[4] = data_write_address[4];
    assign port_write_we[4] = data_write_we[4];
    assign port_write_en[4] = enable[4];
    // 1
    assign port_write_data[5]= data_write[6];
    assign port_write_address[5] = data_write_address[6];
    assign port_write_we[5] = data_write_we[6];
    assign port_write_en[5] = enable[6];
    // read select
    assign port_read_select[2] = enable[7];
    // 0
    assign data_read[5] = port_read_data[4];
    assign port_read_address[4] = data_read_address[5];
    assign port_read_en[4] = data_read_en[5];
    // 1
    assign data_read[7] = port_read_data[5];
    assign port_read_address[5] = data_read_address[7];
    assign port_read_en[5] = data_read_en[7];
    
    // RAM 3
    
    // write select
    assign port_write_select[3] = enable[7];
    // 0
    assign port_write_data[6]= data_write[5];
    assign port_write_address[6] = data_write_address[5];
    assign port_write_we[6] = data_write_we[5];
    assign port_write_en[6] = enable[5];
    // 1
    assign port_write_data[7]= data_write[7];
    assign port_write_address[7] = data_write_address[7];
    assign port_write_we[7] = data_write_we[7];
    assign port_write_en[7] = enable[7];
    // read select
    assign port_read_select[3] = enable[8];
    // 0
    assign data_read[6] = port_read_data[6];
    assign port_read_address[6] = data_read_address[6];
    assign port_read_en[6] = data_read_en[6];
    // 1
    assign data_read[8] = port_read_data[7];
    assign port_read_address[7] = data_read_address[8];
    assign port_read_en[7] = data_read_en[8];
    
    // RAM 4
    
    // write select
    assign port_write_select[4] = enable[10];
    // 0
    assign port_write_data[8]= data_write[8];
    assign port_write_address[8] = data_write_address[8];
    assign port_write_we[8] = data_write_we[8];
    assign port_write_en[8] = enable[8];
    // 1
    assign port_write_data[9]= data_write[10];
    assign port_write_address[9] = data_write_address[10];
    assign port_write_we[9] = data_write_we[10];
    assign port_write_en[9] = enable[10];
    // read select
    assign port_read_select[4] = enable[11];
    // 0
    assign data_read[9] = port_read_data[8];
    assign port_read_address[8] = data_read_address[9];
    assign port_read_en[8] = data_read_en[9];
    // 1
    assign data_read[11] = port_read_data[9];
    assign port_read_address[9] = data_read_address[11];
    assign port_read_en[9] = data_read_en[11];
    
    // RAM 5
    
    // write select
    assign port_write_select[5] = enable[11];
    // 0
    assign port_write_data[10]= data_write[9];
    assign port_write_address[10] = data_write_address[9];
    assign port_write_we[10] = data_write_we[9];
    assign port_write_en[10] = enable[9];
    // 1
    assign port_write_data[11]= data_write[11];
    assign port_write_address[11] = data_write_address[11];
    assign port_write_we[11] = data_write_we[11];
    assign port_write_en[11] = enable[11];
    // read select
    assign port_read_select[5] = enable[12];
    // 0
    assign data_read[10] = port_read_data[10];
    assign port_read_address[10] = data_read_address[10];
    assign port_read_en[10] = data_read_en[10];
    // 1
    assign data_read[12] = port_read_data[11];
    assign port_read_address[11] = data_read_address[12];
    assign port_read_en[11] = data_read_en[12];
    
    // RAM 6
    
    // write select
    assign port_write_select[6] = enable[14];
    // 0
    assign port_write_data[12]= data_write[12];
    assign port_write_address[12] = data_write_address[12];
    assign port_write_we[12] = data_write_we[12];
    assign port_write_en[12] = enable[12];
    // 1
    assign port_write_data[13]= data_write[14];
    assign port_write_address[13] = data_write_address[14];
    assign port_write_we[13] = data_write_we[14];
    assign port_write_en[13] = enable[14];
    // read select
    assign port_read_select[6] = enable[15];
    // 0
    assign data_read[13] = port_read_data[12];
    assign port_read_address[12] = data_read_address[13];
    assign port_read_en[12] = data_read_en[13];
    // 1
    assign data_read[15] = port_read_data[13];
    assign port_read_address[13] = data_read_address[15];
    assign port_read_en[13] = data_read_en[15];
    
    // RAM 7
    
    // write select
    assign port_write_select[7] = enable[15];
    // 0
    assign port_write_data[14]= data_write[13];
    assign port_write_address[14] = data_write_address[13];
    assign port_write_we[14] = data_write_we[13];
    assign port_write_en[14] = enable[13];
    // 1
    assign port_write_data[15]= data_write[15];
    assign port_write_address[15] = data_write_address[15];
    assign port_write_we[15] = data_write_we[15];
    assign port_write_en[15] = enable[15];
    // read select
    assign port_read_select[7] = enable[16];
    // 0
    assign data_read[14] = port_read_data[14];
    assign port_read_address[14] = data_read_address[14];
    assign port_read_en[14] = data_read_en[14];
    // 1
    assign data_read[16] = port_read_data[15];
    assign port_read_address[15] = data_read_address[16];
    assign port_read_en[15] = data_read_en[16];
    
    // RAM 8
    
    // write select
    assign port_write_select[8] = enable[18];
    // 0
    assign port_write_data[16]= data_write[16];
    assign port_write_address[16] = data_write_address[16];
    assign port_write_we[16] = data_write_we[16];
    assign port_write_en[16] = enable[16];
    // 1
    assign port_write_data[17]= data_write[18];
    assign port_write_address[17] = data_write_address[18];
    assign port_write_we[17] = data_write_we[18];
    assign port_write_en[17] = enable[18];
    // read select
    assign port_read_select[8] = enable[19];
    // 0
    assign data_read[17] = port_read_data[16];
    assign port_read_address[16] = data_read_address[17];
    assign port_read_en[16] = data_read_en[17];
    // 1
    assign data_read[19] = port_read_data[17];
    assign port_read_address[17] = data_read_address[19];
    assign port_read_en[17] = data_read_en[19];
    
    // RAM 9
    
    // write select
    assign port_write_select[9] = enable[19];
    // 0
    assign port_write_data[18]= data_write[17];
    assign port_write_address[18] = data_write_address[17];
    assign port_write_we[18] = data_write_we[17];
    assign port_write_en[18] = enable[17];
    // 1
    assign port_write_data[19]= data_write[19];
    assign port_write_address[19] = data_write_address[19];
    assign port_write_we[19] = data_write_we[19];
    assign port_write_en[19] = enable[19];
    // read select
    assign port_read_select[9] = enable[20];
    // 0
    assign data_read[18] = port_read_data[18];
    assign port_read_address[18] = data_read_address[18];
    assign port_read_en[18] = data_read_en[18];
    // 1
    assign data_read[20] = port_read_data[19];
    assign port_read_address[19] = data_read_address[20];
    assign port_read_en[19] = data_read_en[20];
    
    // RAM 10
    
    // write select
    assign port_write_select[10] = 1'b0;
    // 0
    assign port_write_data[20]= data_write[20];
    assign port_write_address[20] = data_write_address[20];
    assign port_write_we[20] = data_write_we[20];
    assign port_write_en[20] = enable[20];
    // 1
    assign port_write_data[21]= 32'd0;
    assign port_write_address[21] = 32'd0;
    assign port_write_we[21] = 1'b0;
    assign port_write_en[21] = 1'b0;
    // read select
    assign port_read_select[10] = 1'b0;
    // 0
    assign data_read[21] = port_read_data[20];
    assign port_read_address[20] = data_read_address[21];
    assign port_read_en[20] = data_read_en[21];
    // 1
    assign port_read_address[21] = 32'd0;
    assign port_read_en[21] = 1'b0;
    


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
            state <= 4'd10;
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
            if ( finished_step[0])
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
            if ( finished_step[1])
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
            if (finished_step[2])
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
            if (finished_step[3])
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