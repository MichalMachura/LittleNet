`timescale 1ns / 1ns


module Utils_tb();
	
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
		
	reg [11:0] cntr = 0;
	always @(posedge clk)
		begin
		cntr <= cntr+8;
		end
	// always end
		
	
	wire [11:0] in_signal=cntr;
	wire [7:0] significant_part_us = in_signal[11:4];
	wire signed [7:0] significant_part_s = in_signal[11:4];
	
	genvar i,j;
	generate
		for (i=8; i > 4 ; i-= 2)
			for (j=0; j < 2; j += 1)
				begin
				localparam OUT_WIDTH = i;
				localparam USE_RELU = j;
				
				wire [OUT_WIDTH-1:0] s_to_us;
				wire signed [OUT_WIDTH-1:0] s_to_s;
				wire signed [OUT_WIDTH-1:0] us_to_s;
				wire [OUT_WIDTH-1:0] us_to_us;
				
				WidthReduction #(
								.IN_WIDTH(12),
								.IN_FRAC(6),
								.IN_SIGNED(1),
								
								.DST_WIDTH(OUT_WIDTH),
								.DST_INT(OUT_WIDTH-2),
								.DST_SIGNED(0),
								
								.RELU(USE_RELU),
								.CUT_TOP(3)
								)
								red1
								(
								.in_signal(in_signal),
								.out_signal(s_to_us)
								);
				WidthReduction #(
								.IN_WIDTH(12),
								.IN_FRAC(6),
								.IN_SIGNED(1),
								
								.DST_WIDTH(OUT_WIDTH),
								.DST_INT(OUT_WIDTH-2),
								.DST_SIGNED(1),
								
								.RELU(USE_RELU),
								.CUT_TOP(3)
								)
								red2
								(
								.in_signal(in_signal),
								.out_signal(s_to_s)
								);
				WidthReduction #(
								.IN_WIDTH(12),
								.IN_FRAC(6),
								.IN_SIGNED(0),
								
								.DST_WIDTH(OUT_WIDTH),
								.DST_INT(OUT_WIDTH-2),
								.DST_SIGNED(1),
								
								.RELU(USE_RELU),
								.CUT_TOP(3)
								)
								red3
								(
								.in_signal(in_signal),
								.out_signal(us_to_s)
								);
				WidthReduction #(
								.IN_WIDTH(12),
								.IN_FRAC(6),
								.IN_SIGNED(0),
								
								.DST_WIDTH(OUT_WIDTH),
								.DST_INT(OUT_WIDTH-2),
								.DST_SIGNED(0),
								
								.RELU(USE_RELU),
								.CUT_TOP(3)
								)
								red4
								(
								.in_signal(in_signal),
								.out_signal(us_to_us)
								);
				end
	endgenerate
	
	reg [7:0] cntr_groups = 0;
	always @(posedge clk)
		begin
		cntr_groups <= cntr_groups+1;
		end
	// always end
	
	wire data_in_validity = cntr[5];
	wire group_enable = 1'b1;
	wire group_reset = 1'b0;
	
	genvar gen_i, gen_j;
	generate
		for(gen_i = 1; gen_i < (8+1); gen_i = gen_i+1)
			begin
			wire [8*gen_i-1:0] data_out;
			wire data_out_validity;
			wire [7:0] data_out_vec[gen_i];
			
			for(gen_j = 0; gen_j < gen_i; gen_j = gen_j+1)
				assign data_out_vec[gen_j] = data_out[(gen_i-gen_j)*8-1:(gen_i-gen_j-1)*8];
			// for end
			
			GrouperUnit	#(
						.BIT_WIDTH(8),
						.GROUPS(gen_i)
						)
						grouper_
						(
						.clk(clk),
						// .enable(cntr[6]),
						.enable(group_enable),
						.reset(group_reset),
						
						.data_in(cntr_groups),
						.data_in_validity(data_in_validity),
						
						.data_out(data_out),
						.data_out_validity(data_out_validity)
						);
			end
		// for end
	endgenerate
	
	reg [20:0] cntr_sender = 0;
	reg axis_clk = 0;
	always @(posedge clk)
		begin
		axis_clk <= !axis_clk;
		cntr_sender <= cntr_sender+1;
		end
	// always end
	
	
	// READ SELECT
	wire [7:0] in_data_memory_out;
	wire [7:0] in_data_memory_address;
	wire in_data_memory_read_enable;
	wire [7:0] in_data_memory_address_arr[2];
	wire in_data_memory_read_enable_arr[2];
	 
	FileROM #(
			  .path("F:/LittleNet_ACC_verilog/LittleNet_ACC/custom_memories/rom_init_data_pw.txt"),
			  .IMG_WIDTH(7),
			  .IMG_HIGHT(5),
			  .IMG_CHANNELS(5),
		 	  .WIDTH(8)
			//  .DEPTH(2048)
		 	 )
			 file_rom_point_streamer
			 (
			 .clka(clk),
			 .douta(in_data_memory_out),
			 .addra(in_data_memory_address),
			 .ena(in_data_memory_read_enable),
			 .sleep(1'b0)
			 );
	MemoryReaderSelectorUnit	#(
								.BIT_WIDTH(8),
								.ADDRESS_BITS(8),
								.SOURCES(2)
								)
								read_mux
								(
								.clk(clk),
								.select(1'b0),
								.data_in_address(in_data_memory_address_arr),
								.data_in_read_enable(in_data_memory_read_enable_arr),
								.data_out_address(in_data_memory_address),
								.data_out_read_enable(in_data_memory_read_enable)
								);
	assign in_data_memory_read_enable_arr[0] = cntr_sender[2];
	assign in_data_memory_address_arr[0] = cntr_sender[7:0];
	assign in_data_memory_read_enable_arr[1] = 0;
	assign in_data_memory_address_arr[1] = 0;
	
	wire [7:0] out_data_write;
	wire [7:0] out_addr_write;
	wire out_we_write;
	
	wire [7:0] in_data_memory_out_arr[2];
	assign in_data_memory_out_arr[0] = in_data_memory_out;
	assign in_data_memory_out_arr[1] = 0;
	
	MemoryWriterSelectorUnit	#(
		.BIT_WIDTH(8),
		.ADDRESS_BITS(8),
		.SOURCES(2)
		)
		write_mux
		(
		.clk(clk),
		.select(1'b0),
		.data_in(in_data_memory_out_arr),
		.data_in_address(in_data_memory_address_arr),
		.data_in_write_enable(in_data_memory_read_enable_arr),
		.data_out(out_data_write),
		.data_out_address(out_addr_write),
		.data_out_write_enable(out_we_write)
		);
	
	// max finder test
	reg [4:0] clk_cntr = 0;
	wire slow_clk = clk_cntr[4];
	
	always @(posedge clk)
		begin
		clk_cntr <= clk_cntr+1;
		end
	// always end
	
	reg [7:0] data = 0;
	reg validity = 0;
	reg rst = 1;
	reg en_mfu = 0;
	wire [7:0] data_out_mfu;
	wire [2:0] data_out_addr;
	wire out_wen;
	wire out_fin;
	
	initial
		begin
			
		forever
			begin
			@(posedge slow_clk);
			rst = 1;
			@(posedge slow_clk);
			rst = 0;
			@(posedge slow_clk);
			@(posedge clk);
			rst = 0;
			en_mfu = 1;
			for (int row = 0; row < 7; row = row+1)
				begin
				for (int col = 0; col < 13; col = col+1)
					begin
					for(int ch = 0; ch < 15; ch = ch+1)
						begin
						@(posedge slow_clk);
						@(posedge clk);
						data = $random;
						// data = row*col*ch;
						validity = 1;
						end
					end
				end
			// for end
			@(posedge slow_clk);
			@(posedge clk);
			data = 0;
			validity = 0;
			wait(out_fin == 1);
			
			@(posedge slow_clk);
			@(posedge slow_clk);
			@(posedge clk);
			en_mfu = 0;
			
			for(int j = 0; j < 100; j = j+1)
				begin
				@(posedge slow_clk);
				end
			// for end
			end
		// for end
		
		end
	
	
	MaxFinderUnit #(
					.BIT_WIDTH(8),
					.SIGNED(1),
					.WIDTH(13),
					.HEIGHT(7),
					.ANCHORS_NUM(3),
					.WRITE_MEMORY_LATENCY(2),
					.PARALLELISM(1)
					)
					mfu
					(
					.clk(slow_clk),
					.enable(en_mfu),
					.reset(rst),
					.data_in({data}),
					.data_in_validity({validity}),
					.out_data_memory_in(data_out_mfu),
					.out_data_memory_address(data_out_addr),
					.out_data_memory_write_enable(out_wen),
					.finished(out_fin)
					);
	
	wire [7:0] registers_out [7];
	
	ShiftRegisters #(
				   .WIDTH(8),
				   .LENGTH(7)
				   )
				   sr
				   (
				    .clk(slow_clk),
					.data_in(data_out_mfu),
					.step(out_wen),
					.registers_out(registers_out)
				   );
	
	
	// AXI SENDER TEST 
	
	
	reg out_data_ready = 0;
	reg [7:0] out_data [7];
	reg reset = 0;
	wire [31:0] m_axis_tdata;
	wire m_axis_tkeep;
	wire m_axis_tlast;
	wire m_axis_tvalid;
	reg s_axis_tready = 0;
	wire output_was_read;
	
	int cntr_valid = 0;
	initial
		begin
		out_data[0] = 8'd1;
		out_data[1] = 8'd2;
		out_data[2] = 8'd3;
		out_data[3] = 8'd4;
		out_data[4] = 8'd5;
		out_data[5] = 8'd6;
		out_data[6] = 8'd7;
		
		@(posedge slow_clk);
		reset = 1;
		@(posedge slow_clk);
		reset = 0;
		forever
			begin
			for(int i = 0; i < 20; i = i+1)
				begin
				@(posedge slow_clk);
				end
			// for end
			
			s_axis_tready = 1;
			@(posedge clk);
			out_data_ready = 1;
			
			cntr_valid = 0;
			while (cntr_valid < 2)
				begin
				@(posedge slow_clk);
				if(m_axis_tvalid)
					cntr_valid = cntr_valid+1;
				end 
			// @(posedge slow_clk);
			s_axis_tready = 0;
			
			@(posedge output_was_read);
			
			for(int i = 0; i < 20; i = i+1)
				begin
				@(posedge slow_clk);
				end
			// for end
			
			@(posedge clk);
			out_data_ready = 0;
			end
		
		end
	
	SendToAxis	#(
		.AXIS_BIT_WIDTH(32),
		.DATA_BIT_WIDTH(8),
		.DATA_COUNT(7)
		)
		sender
		(
		.axis_clk(slow_clk),
		.axis_tdata(m_axis_tdata),
		.axis_tkeep(m_axis_tkeep),
		.axis_tlast(m_axis_tlast),
		.axis_tvalid(m_axis_tvalid),
		.axis_tready(s_axis_tready),
		
		.clk(clk),
		.reset(reset),
		.data_ready_to_send(out_data_ready),
		.data(out_data),
		.data_were_send(output_was_read)
		);
	////////////////////////////////////////////
	
	reg s2_out_data_ready = 0;
	reg [7:0] s2_out_data [32];
	reg s2_reset = 0;
	wire [31:0] s2_m_axis_tdata;
	wire [3:0] s2_m_axis_tkeep;
	wire s2_m_axis_tlast;
	wire s2_m_axis_tvalid;
	reg s2_s_axis_tready = 0;
	wire s2_output_was_read;
	
	int s2_cntr_valid = 0;
	initial
		begin
		for(int v = 0; v < 32; v = v+1)
			begin
			s2_out_data[v] = v+1;
			end
		// for end
		
		@(posedge slow_clk);
		s2_reset = 1;
		@(posedge slow_clk);
		s2_reset = 0;
		forever
			begin
			for(int i = 0; i < 20; i = i+1)
				begin
				@(posedge slow_clk);
				end
			// for end
			
			s2_s_axis_tready = 1;
			@(posedge clk);
			s2_out_data_ready = 1;
			
			s2_cntr_valid = 0;
			while (s2_cntr_valid < 32)
				begin
				@(posedge slow_clk);
				if(s2_m_axis_tvalid)
					s2_cntr_valid = s2_cntr_valid+1;
				end 
			// @(posedge slow_clk);
			s2_s_axis_tready = 0;
			
			@(posedge s2_output_was_read);
			
			for(int i = 0; i < 20; i = i+1)
				begin
				@(posedge slow_clk);
				end
			// for end
			
			@(posedge clk);
			s2_out_data_ready = 0;
			end
		end
		
	wire s2_rena;
	wire [7:0] s2_data_memory_out;
	wire [4:0] s2_data_memory_addr;
	
	DelayLine	#(
				.WIDTH(8),
				.DELAY(2) // +1 for data storing step
				)
				delay_
				(
				.clk(slow_clk),
				.enable(s2_rena),
				
				.data_in(s2_out_data[s2_data_memory_addr]),
				.data_out(s2_data_memory_out)
				);
	SendMemoryToAxis#(
					.DATA_BIT_WIDTH(8),
					.MEMORY_READ_LATENCY(2),
					.NUMBER_OF_DATA(32)
					)
					sender2
					(
					.axis_clk(slow_clk),
					.axis_tdata(s2_m_axis_tdata),
					.axis_tkeep(s2_m_axis_tkeep),
					.axis_tlast(s2_m_axis_tlast),
					.axis_tvalid(s2_m_axis_tvalid),
					.axis_tready(s2_s_axis_tready),
					.clk(slow_clk),
					.reset(s2_reset),
					.data_ready_to_send(s2_out_data_ready),
					
					.data_addr(s2_data_memory_addr),
					.read_enable(s2_rena),
					.data(s2_data_memory_out),
					
					.data_were_send(s2_output_was_read)
					);
	
	
	reg saving = 0;
	SaveToFile
		#(
		.DATA_WIDTH(39),
		.PATH("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/WBD/file_%0d.txt"),
		.PERIOD(100)
		)
		saver
		(
		.clk(slow_clk),
		.data({	s2_m_axis_tdata,
				s2_m_axis_tkeep,
				s2_m_axis_tlast,
				s2_m_axis_tvalid,
				s2_s_axis_tready}),
		.save(saving)
		);
	
// iw_0_0_enable
// iw_0_0_reset
// data_in
// data_in_validity
// ram_0_0_dina
// ram_0_0_addra
// ram_0_0_wea
// iw_0_0_finished
// iw_0_0_last_data_received
// dw_1_0_reset
// dw_1_0_enable
// dw_1_0_finished
// ram_0_0_doutb
// ram_0_0_addrb
// ram_0_0_enb
// rom_dw_1_0_data_out
// rom_dw_1_0_data_address
// rom_dw_1_0_data_read_enable
// ram_1_0_data_in[0]
// ram_1_0_addr_in[0]
// ram_1_0_write_enable[0]
// pw_1_1_reset
// pw_1_1_enable
// pw_1_1_finished
// ram_1_0_data_out[0]
// ram_1_0_addr_out[0]
// ram_1_0_read_enable[0]
// rom_pw_1_1_data_out
// rom_pw_1_1_data_address
// rom_pw_1_1_data_read_enable
// ram_1_1_dina
// ram_1_1_addra
// ram_1_1_wea
// dw_1_2_reset
// dw_1_2_enable
// dw_1_2_finished
// ram_1_1_doutb
// ram_1_1_addrb
// ram_1_1_enb
// rom_dw_1_2_data_out
// rom_dw_1_2_data_address
// rom_dw_1_2_data_read_enable
// ram_1_0_data_in[1]
// ram_1_0_addr_in[1][15:0]
// ram_1_0_write_enable[1]
// pw_2_0_reset
// pw_2_0_enable
// pw_2_0_finished
// ram_1_0_data_out[1]
// ram_1_0_addr_out[1]
// ram_1_0_read_enable[1][17:0]
// rom_pw_2_0_data_out
// rom_pw_2_0_data_address
// rom_pw_2_0_data_read_enable
// ram_2_0_data_in[0]
// ram_2_0_addr_in[0]
// ram_2_0_write_enable[0]
// dw_2_1_reset
// dw_2_1_enable
// dw_2_1_finished
// ram_2_0_data_out[0]
// ram_2_0_addr_out[0]
// ram_2_0_read_enable[0]
// rom_dw_2_1_data_out
// rom_dw_2_1_data_address
// rom_dw_2_1_data_read_enable
// ram_2_1_dina
// ram_2_1_addra
// ram_2_1_wea
// pw_2_2_reset
// pw_2_2_enable
// pw_2_2_finished
// ram_2_1_doutb
// ram_2_1_addrb
// ram_2_1_enb
// rom_pw_2_2_data_out
// rom_pw_2_2_data_address
// rom_pw_2_2_data_read_enable
// ram_2_0_data_in[1]
// ram_2_0_addr_in[1][12:0]
// ram_2_0_write_enable[1]
// dw_3_0_reset
// dw_3_0_enable
// dw_3_0_finished
// ram_2_0_data_out[1]
// ram_2_0_addr_out[1][14:0]
// ram_2_0_read_enable[1]
// rom_dw_3_0_data_out
// rom_dw_3_0_data_address
// rom_dw_3_0_data_read_enable
// ram_3_0_data_in[0]
// ram_3_0_addr_in[0]
// ram_3_0_write_enable[0]
// pw_3_1_reset
// pw_3_1_enable
// pw_3_1_finished
// ram_3_0_data_out[0]
// ram_3_0_addr_out[0]
// ram_3_0_read_enable[0]
// rom_pw_3_1_data_out
// rom_pw_3_1_data_address
// rom_pw_3_1_data_read_enable
// ram_3_1_dina
// ram_3_1_addra
// ram_3_1_wea
// dw_3_2_reset
// dw_3_2_enable
// dw_3_2_finished
// ram_3_1_doutb
// ram_3_1_addrb
// ram_3_1_enb
// rom_dw_3_2_data_out
// rom_dw_3_2_data_address
// rom_dw_3_2_data_read_enable
// ram_3_0_data_in[1]
// ram_3_0_addr_in[1][12:0]
// ram_3_0_write_enable[1]
// pw_4_0_reset
// pw_4_0_enable
// pw_4_0_finished
// ram_3_0_data_out[1]
// ram_3_0_addr_out[1][14:0]
// ram_3_0_read_enable[1]
// rom_pw_4_0_data_out
// rom_pw_4_0_data_address
// rom_pw_4_0_data_read_enable
// ram_4_0_data_in[0]
// ram_4_0_addr_in[0][11:0]
// ram_4_0_write_enable[0]
// dw_4_1_reset
// dw_4_1_enable
// dw_4_1_finished
// ram_4_0_data_out[0]
// ram_4_0_addr_out[0][13:0]
// ram_4_0_read_enable[0]
// rom_dw_4_1_data_out
// rom_dw_4_1_data_address
// rom_dw_4_1_data_read_enable
// ram_4_1_dina
// ram_4_1_addra
// ram_4_1_wea
// pw_4_2_reset
// pw_4_2_enable
// pw_4_2_finished
// ram_4_1_doutb
// ram_4_1_addrb
// ram_4_1_enb
// rom_pw_4_2_data_out
// rom_pw_4_2_data_address
// rom_pw_4_2_data_read_enable
// ram_4_0_data_in[1]
// ram_4_0_addr_in[1]
// ram_4_0_write_enable[1]
// pw_5_0_reset
// pw_5_0_enable
// pw_5_0_finished
// ram_4_0_data_out[1]
// ram_4_0_addr_out[1]
// ram_4_0_read_enable[1]
// rom_pw_5_0_data_out
// rom_pw_5_0_data_address
// rom_pw_5_0_data_read_enable
// ram_5_0_dina
// ram_5_0_addra
// ram_5_0_wea
// iw_0_0_enable_reg
// dw_1_0_enable_reg
// pw_1_1_enable_reg
// dw_1_2_enable_reg
// pw_2_0_enable_reg
// dw_2_1_enable_reg
// pw_2_2_enable_reg
// dw_3_0_enable_reg
// pw_3_1_enable_reg
// dw_3_2_enable_reg
// pw_4_0_enable_reg
// dw_4_1_enable_reg
// pw_4_2_enable_reg
// pw_5_0_enable_reg
// iw_0_0_reset_reg
// dw_1_0_reset_reg
// pw_1_1_reset_reg
// dw_1_2_reset_reg
// pw_2_0_reset_reg
// dw_2_1_reset_reg
// pw_2_2_reset_reg
// dw_3_0_reset_reg
// pw_3_1_reset_reg
// dw_3_2_reset_reg
// pw_4_0_reset_reg
// dw_4_1_reset_reg
// pw_4_2_reset_reg
// pw_5_0_reset_reg
// ram_0_0_sleep_reg
// ram_1_1_sleep_reg
// ram_2_1_sleep_reg
// ram_3_1_sleep_reg
// ram_4_1_sleep_reg
// rom_dw_1_0_sleep_reg
// rom_pw_1_1_sleep_reg
// rom_dw_1_2_sleep_reg
// rom_pw_2_0_sleep_reg
// rom_dw_2_1_sleep_reg
// rom_pw_2_2_sleep_reg
// rom_dw_3_0_sleep_reg
// rom_pw_3_1_sleep_reg
// rom_dw_3_2_sleep_reg
// rom_pw_4_0_sleep_reg
// rom_dw_4_1_sleep_reg
// rom_pw_4_2_sleep_reg
// rom_pw_5_0_sleep_reg
// ram_1_0_ena
// ram_2_0_ena
// ram_3_0_ena
// ram_4_0_ena
// state
// awakening_cntr


	initial
		begin
		forever
			begin
			for(int i = 0; i < 5000; i = i+1)
				begin
				@(posedge slow_clk);
				end
			saving = 1;
			@(posedge slow_clk);
			@(posedge slow_clk);
			@(posedge slow_clk);
			saving = 0;
			
			// for end
			end
		end
	
endmodule // Tmp_tb


