`timescale 1ns / 1ps


`timescale 1ns / 1ps



module LN_DEBUG
		#(
		localparam ADDR_BITS = $clog2(100*200*15)
		)
		(
		input clk,
		input reset,
		
		input [31:0] data_in,
		input data_in_validity,
		output write_possible,
		
		output data_ready_to_send,
		// memory interface
		input [ADDR_BITS-1:0] data_addr,
		input read_enable,
		output [7:0] data,
		// if sending is finished
		input output_was_read
		);
	
	// INPUT RAM
	wire [13:0] ram_0_0_addra;
	wire [31:0] ram_0_0_dina;
	wire ram_0_0_wea;
	wire ram_0_0_ena;
	wire [15:0] ram_0_0_addrb;
	wire [7:0] ram_0_0_doutb;
	wire ram_0_0_enb;
	wire ram_0_0_sleep;
	RAM_A32_15000e_14a_B8_16a RAM_0_0
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_0_0_sleep),
			// port to write
			.addra(ram_0_0_addra),
			.dina(ram_0_0_dina),
			.ena(ram_0_0_ena),
			.wea(ram_0_0_wea),
			// port to read
			.addrb(ram_0_0_addrb),
			.doutb(ram_0_0_doutb),
			.enb(ram_0_0_enb)
			);
	//
	// FIRST BLOCK RAM
	// RAM 1_0 with access control
	wire [16:0] ram_1_0_addra;
	wire [31:0] ram_1_0_dina;
	wire ram_1_0_wea;
	wire ram_1_0_ena;
	wire [18:0] ram_1_0_addrb;
	wire [7:0] ram_1_0_doutb;
	wire ram_1_0_enb;
	wire ram_1_0_sleep;
	RAM_A32_75000e_17a_B8_19a RAM_1_0
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_1_0_sleep),
			// port to write
			.addra(ram_1_0_addra),
			.dina(ram_1_0_dina),
			.ena(ram_1_0_ena),
			.wea(ram_1_0_wea),
			// port to read
			.addrb(ram_1_0_addrb),
			.doutb(ram_1_0_doutb),
			.enb(ram_1_0_enb)
			);
	// multi port in
	wire [16:0] ram_1_0_addr_in [2];
	wire [31:0] ram_1_0_data_in [2];
	wire ram_1_0_write_enable [2];
	wire ram_1_0_write_sel;
	MemoryWriterSelectorUnit	#(
								.BIT_WIDTH(32),
								.ADDRESS_BITS(17),
								.SOURCES(2)
								)
								ram_1_0_write_selector
								(
								.clk(clk),
								.select(ram_1_0_write_sel),
								.data_in(ram_1_0_data_in),
								.data_in_address(ram_1_0_addr_in),
								.data_in_write_enable(ram_1_0_write_enable),
								.data_out(ram_1_0_dina),
								.data_out_address(ram_1_0_addra),
								.data_out_write_enable(ram_1_0_wea)
								);
	// multi port out
	wire [18:0] ram_1_0_addr_out [2];
	wire ram_1_0_read_enable [2];
	wire [7:0] ram_1_0_data_out [2];
	wire ram_1_0_read_sel;
	MemoryReaderSelectorUnit	#(
								.BIT_WIDTH(8),
								.ADDRESS_BITS(19),
								.SOURCES(2)
								)
								ram_1_0_read_selector
								(
								.clk(clk),
								.select(ram_1_0_read_sel),
								.data_in_address(ram_1_0_addr_out),
								.data_in_read_enable(ram_1_0_read_enable),
								.data_out_address(ram_1_0_addrb),
								.data_out_read_enable(ram_1_0_enb)
								);
	assign ram_1_0_data_out[0] = ram_1_0_doutb;
	assign ram_1_0_data_out[1] = ram_1_0_doutb;
	// RAM simple dual port internal memory of block
	wire [14:0] ram_1_1_addra;
	wire [31:0] ram_1_1_dina;
	wire ram_1_1_wea;
	wire ram_1_1_ena;
	wire [16:0] ram_1_1_addrb;
	wire [7:0] ram_1_1_doutb;
	wire ram_1_1_enb;
	wire ram_1_1_sleep;
	RAM_A32_20000e_15a_B8_17a RAM_1_1
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_1_1_sleep),
			// port to write
			.addra(ram_1_1_addra),
			.dina(ram_1_1_dina),
			.ena(ram_1_1_ena),
			.wea(ram_1_1_wea),
			// port to read
			.addrb(ram_1_1_addrb),
			.doutb(ram_1_1_doutb),
			.enb(ram_1_1_enb)
			);
	
	//
	// SECOND BLOCK RAM
	// RAM 2_0 with access control
	wire [13:0] ram_2_0_addra;
	wire [31:0] ram_2_0_dina;
	wire ram_2_0_wea;
	wire ram_2_0_ena;
	wire [15:0] ram_2_0_addrb;
	wire [7:0] ram_2_0_doutb;
	wire ram_2_0_enb;
	wire ram_2_0_sleep;
	RAM_A32_10000e_14a_B8_16a RAM_2_0
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_2_0_sleep),
			// port to write
			.addra(ram_2_0_addra),
			.dina(ram_2_0_dina),
			.ena(ram_2_0_ena),
			.wea(ram_2_0_wea),
			// port to read
			.addrb(ram_2_0_addrb),
			.doutb(ram_2_0_doutb),
			.enb(ram_2_0_enb)
			);
	// multi port in
	wire [13:0] ram_2_0_addr_in [2];
	wire [31:0] ram_2_0_data_in [2];
	wire ram_2_0_write_enable [2];
	wire ram_2_0_write_sel;
	MemoryWriterSelectorUnit	#(
								.BIT_WIDTH(32),
								.ADDRESS_BITS(14),
								.SOURCES(2)
								)
								ram_2_0_write_selector
								(
								.clk(clk),
								.select(ram_2_0_write_sel),
								.data_in(ram_2_0_data_in),
								.data_in_address(ram_2_0_addr_in),
								.data_in_write_enable(ram_2_0_write_enable),
								.data_out(ram_2_0_dina),
								.data_out_address(ram_2_0_addra),
								.data_out_write_enable(ram_2_0_wea)
								);
	// multi port out
	wire [15:0] ram_2_0_addr_out [2];
	wire ram_2_0_read_enable [2];
	wire [7:0] ram_2_0_data_out [2];
	wire ram_2_0_read_sel;
	MemoryReaderSelectorUnit	#(
								.BIT_WIDTH(8),
								.ADDRESS_BITS(16),
								.SOURCES(2)
								)
								ram_2_0_read_selector
								(
								.clk(clk),
								.select(ram_2_0_read_sel),
								.data_in_address(ram_2_0_addr_out),
								.data_in_read_enable(ram_2_0_read_enable),
								.data_out_address(ram_2_0_addrb),
								.data_out_read_enable(ram_2_0_enb)
								);
	assign ram_2_0_data_out[0] = ram_2_0_doutb;
	assign ram_2_0_data_out[1] = ram_2_0_doutb;
	// RAM simple dual port internal memory of block
	wire [14:0] ram_2_1_addra;
	wire [31:0] ram_2_1_dina;
	wire ram_2_1_wea;
	wire ram_2_1_ena;
	wire [16:0] ram_2_1_addrb;
	wire [7:0] ram_2_1_doutb;
	wire ram_2_1_enb;
	wire ram_2_1_sleep;
	RAM_A32_20000e_15a_B8_17a RAM_2_1
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_2_1_sleep),
			// port to write
			.addra(ram_2_1_addra),
			.dina(ram_2_1_dina),
			.ena(ram_2_1_ena),
			.wea(ram_2_1_wea),
			// port to read
			.addrb(ram_2_1_addrb),
			.doutb(ram_2_1_doutb),
			.enb(ram_2_1_enb)
			);
			
	//
	// THIRD BLOCK RAM
	// RAM 3_0 with access control
	wire [13:0] ram_3_0_addra;
	wire [31:0] ram_3_0_dina;
	wire ram_3_0_wea;
	wire ram_3_0_ena;
	wire [15:0] ram_3_0_addrb;
	wire [7:0] ram_3_0_doutb;
	wire ram_3_0_enb;
	wire ram_3_0_sleep;
	RAM_A32_10400e_14a_B8_16a RAM_3_0
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_3_0_sleep),
			// port to write
			.addra(ram_3_0_addra),
			.dina(ram_3_0_dina),
			.ena(ram_3_0_ena),
			.wea(ram_3_0_wea),
			// port to read
			.addrb(ram_3_0_addrb),
			.doutb(ram_3_0_doutb),
			.enb(ram_3_0_enb)
			);
	// multi port in
	wire [13:0] ram_3_0_addr_in [2];
	wire [31:0] ram_3_0_data_in [2];
	wire ram_3_0_write_enable [2];
	wire ram_3_0_write_sel;
	MemoryWriterSelectorUnit	#(
								.BIT_WIDTH(32),
								.ADDRESS_BITS(14),
								.SOURCES(2)
								)
								ram_3_0_write_selector
								(
								.clk(clk),
								.select(ram_3_0_write_sel),
								.data_in(ram_3_0_data_in),
								.data_in_address(ram_3_0_addr_in),
								.data_in_write_enable(ram_3_0_write_enable),
								.data_out(ram_3_0_dina),
								.data_out_address(ram_3_0_addra),
								.data_out_write_enable(ram_3_0_wea)
								);
	// multi port out
	wire [15:0] ram_3_0_addr_out [2];
	wire ram_3_0_read_enable [2];
	wire [7:0] ram_3_0_data_out [2];
	wire ram_3_0_read_sel;
	MemoryReaderSelectorUnit	#(
								.BIT_WIDTH(8),
								.ADDRESS_BITS(16),
								.SOURCES(2)
								)
								ram_3_0_read_selector
								(
								.clk(clk),
								.select(ram_3_0_read_sel),
								.data_in_address(ram_3_0_addr_out),
								.data_in_read_enable(ram_3_0_read_enable),
								.data_out_address(ram_3_0_addrb),
								.data_out_read_enable(ram_3_0_enb)
								);
	assign ram_3_0_data_out[0] = ram_3_0_doutb;
	assign ram_3_0_data_out[1] = ram_3_0_doutb;
	// RAM simple dual port internal memory of block
	wire [11:0] ram_3_1_addra;
	wire [31:0] ram_3_1_dina;
	wire ram_3_1_wea;
	wire ram_3_1_ena;
	wire [13:0] ram_3_1_addrb;
	wire [7:0] ram_3_1_doutb;
	wire ram_3_1_enb;
	wire ram_3_1_sleep;
	RAM_A32_2912e_12a_B8_14a RAM_3_1
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_3_1_sleep),
			// port to write
			.addra(ram_3_1_addra),
			.dina(ram_3_1_dina),
			.ena(ram_3_1_ena),
			.wea(ram_3_1_wea),
			// port to read
			.addrb(ram_3_1_addrb),
			.doutb(ram_3_1_doutb),
			.enb(ram_3_1_enb)
			);
	
	//
	// FOURTH BLOCK RAM
	// RAM 4_0 with access control
	wire [12:0] ram_4_0_addra;
	wire [31:0] ram_4_0_dina;
	wire ram_4_0_wea;
	wire ram_4_0_ena;
	wire [14:0] ram_4_0_addrb;
	wire [7:0] ram_4_0_doutb;
	wire ram_4_0_enb;
	wire ram_4_0_sleep;
	RAM_A32_5824e_13a_B8_15a RAM_4_0
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_4_0_sleep),
			// port to write
			.addra(ram_4_0_addra),
			.dina(ram_4_0_dina),
			.ena(ram_4_0_ena),
			.wea(ram_4_0_wea),
			// port to read
			.addrb(ram_4_0_addrb),
			.doutb(ram_4_0_doutb),
			.enb(ram_4_0_enb)
			);
	// multi port in
	wire [12:0] ram_4_0_addr_in [2];
	wire [31:0] ram_4_0_data_in [2];
	wire ram_4_0_write_enable [2];
	wire ram_4_0_write_sel;
	MemoryWriterSelectorUnit	#(
								.BIT_WIDTH(32),
								.ADDRESS_BITS(13),
								.SOURCES(2)
								)
								ram_4_0_write_selector
								(
								.clk(clk),
								.select(ram_4_0_write_sel),
								.data_in(ram_4_0_data_in),
								.data_in_address(ram_4_0_addr_in),
								.data_in_write_enable(ram_4_0_write_enable),
								.data_out(ram_4_0_dina),
								.data_out_address(ram_4_0_addra),
								.data_out_write_enable(ram_4_0_wea)
								);
	// multi port out
	wire [14:0] ram_4_0_addr_out [2];
	wire ram_4_0_read_enable [2];
	wire [7:0] ram_4_0_data_out [2];
	wire ram_4_0_read_sel;
	MemoryReaderSelectorUnit	#(
								.BIT_WIDTH(8),
								.ADDRESS_BITS(15),
								.SOURCES(2)
								)
								ram_4_0_read_selector
								(
								.clk(clk),
								.select(ram_4_0_read_sel),
								.data_in_address(ram_4_0_addr_out),
								.data_in_read_enable(ram_4_0_read_enable),
								.data_out_address(ram_4_0_addrb),
								.data_out_read_enable(ram_4_0_enb)
								);
	assign ram_4_0_data_out[0] = ram_4_0_doutb;
	assign ram_4_0_data_out[1] = ram_4_0_doutb;
	// RAM simple dual port internal memory of block
	wire [12:0] ram_4_1_addra;
	wire [31:0] ram_4_1_dina;
	wire ram_4_1_wea;
	wire ram_4_1_ena;
	wire [14:0] ram_4_1_addrb;
	wire [7:0] ram_4_1_doutb;
	wire ram_4_1_enb;
	wire ram_4_1_sleep;
	RAM_A32_5824e_13a_B8_15a RAM_4_1
			(
			.clka(clk),
			.clkb(clk),
			.sleep(ram_4_1_sleep),
			// port to write
			.addra(ram_4_1_addra),
			.dina(ram_4_1_dina),
			.ena(ram_4_1_ena),
			.wea(ram_4_1_wea),
			// port to read
			.addrb(ram_4_1_addrb),
			.doutb(ram_4_1_doutb),
			.enb(ram_4_1_enb)
			);
	
	//
	// OUTPUT MEMORY
	wire [7:0] ram_5_0_dina;
	wire [2:0] ram_5_0_addra;
	wire ram_5_0_wea;
	wire [7:0] ram_5_0_registers [7];
	ShiftRegisters	#(
					.WIDTH(8),
					.LENGTH(7)
					)
					output_registers
					(
					.clk(clk),
					.step(ram_5_0_wea),
					.data_in(ram_5_0_dina),
					.registers_out(ram_5_0_registers)
					);
	//
	// RAM MEMORIES END
	
	//
	// ROM MEMORIES START
	// DW 1 0
	wire [7:0] rom_dw_1_0_data_out;
	wire [7:0] rom_dw_1_0_data_address;
	wire 	   rom_dw_1_0_data_read_enable;
	wire 	   rom_dw_1_0_sleep;
	ROM_DW_1_0 dw_1_0_weights
				(
				.clka(clk),
				.addra(rom_dw_1_0_data_address),
				.douta(rom_dw_1_0_data_out),
				.ena(  rom_dw_1_0_data_read_enable),
				.sleep(rom_dw_1_0_sleep)
				);
	
	// PW 1 1
	wire [127:0] rom_pw_1_1_data_out;
	wire [4:0] rom_pw_1_1_data_address;
	wire 	   rom_pw_1_1_data_read_enable;
	wire 	   rom_pw_1_1_sleep;
	ROM_PW_1_1 pw_1_1_weights
				(
				.clka(clk),
				.addra(rom_pw_1_1_data_address),
				.douta(rom_pw_1_1_data_out),
				.ena(  rom_pw_1_1_data_read_enable),
				.sleep(rom_pw_1_1_sleep)
				);
	
	// DW 1 2
	wire [7:0] rom_dw_1_2_data_out;
	wire [8:0] rom_dw_1_2_data_address;
	wire 	   rom_dw_1_2_data_read_enable;
	wire 	   rom_dw_1_2_sleep;
	ROM_DW_1_2 dw_1_2_weights
				(
				.clka(clk),
				.addra(rom_dw_1_2_data_address),
				.douta(rom_dw_1_2_data_out),
				.ena(  rom_dw_1_2_data_read_enable),
				.sleep(rom_dw_1_2_sleep)
				);
	
	
	// PW 2 0
	wire [127:0] rom_pw_2_0_data_out;
	wire [6:0]  rom_pw_2_0_data_address;
	wire 	    rom_pw_2_0_data_read_enable;
	wire 	    rom_pw_2_0_sleep;
	ROM_PW_2_0 pw_2_0_weights
				(
				.clka(clk),
				.addra(rom_pw_2_0_data_address),
				.douta(rom_pw_2_0_data_out),
				.ena(  rom_pw_2_0_data_read_enable),
				.sleep(rom_pw_2_0_sleep)
				);
	
	// DW 2 1
	wire [7:0]  rom_dw_2_1_data_out;
	wire [9:0]  rom_dw_2_1_data_address;
	wire 	    rom_dw_2_1_data_read_enable;
	wire 	    rom_dw_2_1_sleep;
	ROM_DW_2_1 dw_2_1_weights
				(
				.clka(clk),
				.addra(rom_dw_2_1_data_address),
				.douta(rom_dw_2_1_data_out),
				.ena(  rom_dw_2_1_data_read_enable),
				.sleep(rom_dw_2_1_sleep)
				);
	
	// PW 2 2
	wire [127:0] rom_pw_2_2_data_out;
	wire [8:0] rom_pw_2_2_data_address;
	wire 	    rom_pw_2_2_data_read_enable;
	wire 	    rom_pw_2_2_sleep;
	ROM_PW_2_2 pw_2_2_weights
				(
				.clka(clk),
				.addra(rom_pw_2_2_data_address),
				.douta(rom_pw_2_2_data_out),
				.ena(  rom_pw_2_2_data_read_enable),
				.sleep(rom_pw_2_2_sleep)
				);
	
	// DW 3 0
	wire [7:0]  rom_dw_3_0_data_out;
	wire [10:0] rom_dw_3_0_data_address;
	wire 	    rom_dw_3_0_data_read_enable;
	wire 	    rom_dw_3_0_sleep;
	ROM_DW_3_0 dw_3_0_weights
				(
				.clka(clk),
				.addra(rom_dw_3_0_data_address),
				.douta(rom_dw_3_0_data_out),
				.ena(  rom_dw_3_0_data_read_enable),
				.sleep(rom_dw_3_0_sleep)
				);
	
	// PW 3 1
	wire [127:0]  rom_pw_3_1_data_out;
	wire [10:0] rom_pw_3_1_data_address;
	wire 	    rom_pw_3_1_data_read_enable;
	wire 	    rom_pw_3_1_sleep;
	ROM_PW_3_1 pw_3_1_weights
				(
				.clka(clk),
				.addra(rom_pw_3_1_data_address),
				.douta(rom_pw_3_1_data_out),
				.ena(  rom_pw_3_1_data_read_enable),
				.sleep(rom_pw_3_1_sleep)
				);
	
	// DW 3 2
	wire [7:0]  rom_dw_3_2_data_out;
	wire [11:0] rom_dw_3_2_data_address;
	wire 	    rom_dw_3_2_data_read_enable;
	wire 	    rom_dw_3_2_sleep;
	ROM_DW_3_2 dw_3_2_weights
				(
				.clka(clk),
				.addra(rom_dw_3_2_data_address),
				.douta(rom_dw_3_2_data_out),
				.ena(  rom_dw_3_2_data_read_enable),
				.sleep(rom_dw_3_2_sleep)
				);
	
	// PW 4 0
	wire [127:0]  rom_pw_4_0_data_out;
	wire [11:0] rom_pw_4_0_data_address;
	wire 	    rom_pw_4_0_data_read_enable;
	wire 	    rom_pw_4_0_sleep;
	ROM_PW_4_0 pw_4_0_weights
				(
				.clka(clk),
				.addra(rom_pw_4_0_data_address),
				.douta(rom_pw_4_0_data_out),
				.ena(  rom_pw_4_0_data_read_enable),
				.sleep(rom_pw_4_0_sleep)
				);
	
	// DW 4 1
	wire [7:0]  rom_dw_4_1_data_out;
	wire [11:0] rom_dw_4_1_data_address;
	wire 	    rom_dw_4_1_data_read_enable;
	wire 	    rom_dw_4_1_sleep;
	ROM_DW_4_1 dw_4_1_weights
				(
				.clka(clk),
				.addra(rom_dw_4_1_data_address),
				.douta(rom_dw_4_1_data_out),
				.ena(  rom_dw_4_1_data_read_enable),
				.sleep(rom_dw_4_1_sleep)
				);
	
	// PW 4 2
	wire [127:0]  rom_pw_4_2_data_out;
	wire [12:0] rom_pw_4_2_data_address;
	wire 	    rom_pw_4_2_data_read_enable;
	wire 	    rom_pw_4_2_sleep;
	ROM_PW_4_2 pw_4_2_weights
				(
				.clka(clk),
				.addra(rom_pw_4_2_data_address),
				.douta(rom_pw_4_2_data_out),
				.ena(  rom_pw_4_2_data_read_enable),
				.sleep(rom_pw_4_2_sleep)
				);
	
	// PW 5 0
	wire [39:0]  rom_pw_5_0_data_out;
	wire [9:0] rom_pw_5_0_data_address;
	wire 	    rom_pw_5_0_data_read_enable;
	wire 	    rom_pw_5_0_sleep;
	ROM_PW_5_0 pw_5_0_weights
				(
				.clka(clk),
				.addra(rom_pw_5_0_data_address),
				.douta(rom_pw_5_0_data_out),
				.ena(  rom_pw_5_0_data_read_enable),
				.sleep(rom_pw_5_0_sleep)
				);
	
	///
	// CREATE LAYERS
	
	// BLOCK 0 
	
	wire iw_0_0_reset;
	wire iw_0_0_enable;
	wire iw_0_0_finished;
	wire iw_0_0_last_data_received;
	InputLayer
		#(
		.BIT_WIDTH(8),
		.WIDTH(200),
		.HEIGHT(100),
		.CHANNELS(3),
		.GROUPS(4),
		.WRITE_MEMORY_LATENCY(2)
		)
		iv_0_0
		(
		.clk(clk),
		.enable(iw_0_0_enable),
		.reset(iw_0_0_reset),
		.data_in(data_in),
		.data_in_validity(data_in_validity),
		.data_out(ram_0_0_dina),
		.data_out_address(ram_0_0_addra),
		.data_out_validity(ram_0_0_wea),
		.finished(iw_0_0_finished),
		.last_data_received(iw_0_0_last_data_received)
		);
	
	// BLOCK 1
	// DW 1 0
	wire dw_1_0_reset;
	wire dw_1_0_enable;
	wire dw_1_0_finished;
	DepthwiseConv2dUnit #(
						.IN_WIDTH(200),
						.IN_HEIGHT(100),
						.IN_CHANNELS(3),
						.PADDING_W(1),
						.PADDING_H(1),
						.CHANNEL_MUL(5),
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
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(2),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_dw_1_0
						(
						.clk(clk),
						.reset(dw_1_0_reset),
						.enable(dw_1_0_enable),
						.finished(dw_1_0_finished),
						.in_data_memory_out(ram_0_0_doutb),
						.in_data_memory_address(ram_0_0_addrb),
						.in_data_memory_read_enable(ram_0_0_enb),
						.weights_memory_out(rom_dw_1_0_data_out),
						.weights_memory_address(rom_dw_1_0_data_address),
						.weights_memory_read_enable(rom_dw_1_0_data_read_enable),
						.out_data_memory_in(ram_1_0_data_in[0]),
						.out_data_memory_address(ram_1_0_addr_in[0]),
						.out_data_memory_write_enable(ram_1_0_write_enable[0])
						);
	
	// PW 1 1
	wire pw_1_1_reset;
	wire pw_1_1_enable;
	wire pw_1_1_finished;
	PointwiseConv2dUnit#(
						.IN_WIDTH(200),
						.IN_HEIGHT(100),
						.IN_CHANNELS(15),
						.OUT_CHANNELS(16),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.USE_MAXPOOL(1),
						.USE_MAXPOOL_CEIL_MODE(1),
						.PARALLELISM(2*8),
						.GROUPS(4),
						.USE_MAX_FINDER(0),
						.ANCHORS(3),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(2)
						)
						layer_pw_1_1
						(
						.clk(clk),
						.reset(pw_1_1_reset),
						.enable(pw_1_1_enable),
						.finished(pw_1_1_finished),
						.in_data_memory_out(ram_1_0_data_out[0]),
						.in_data_memory_address(ram_1_0_addr_out[0]),
						.in_data_memory_read_enable(ram_1_0_read_enable[0]),
						.weights_memory_out(rom_pw_1_1_data_out),
						.weights_memory_address(rom_pw_1_1_data_address),
						.weights_memory_read_enable(rom_pw_1_1_data_read_enable),
						.out_data_memory_in(ram_1_1_dina),
						.out_data_memory_address(ram_1_1_addra),
						.out_data_memory_write_enable(ram_1_1_wea)
						);
	
	// DW 1 2
	wire dw_1_2_reset;
	wire dw_1_2_enable;
	wire dw_1_2_finished;
	DepthwiseConv2dUnit #(
						.IN_WIDTH(100),
						.IN_HEIGHT(50),
						.IN_CHANNELS(16),
						.PADDING_W(1),
						.PADDING_H(1),
						.CHANNEL_MUL(2),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.GROUPS(4),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(2),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_dw_1_2
						(
						.clk(clk),
						.reset(dw_1_2_reset),
						.enable(dw_1_2_enable),
						.finished(dw_1_2_finished),
						.in_data_memory_out(ram_1_1_doutb),
						.in_data_memory_address(ram_1_1_addrb),
						.in_data_memory_read_enable(ram_1_1_enb),
						.weights_memory_out(rom_dw_1_2_data_out),
						.weights_memory_address(rom_dw_1_2_data_address),
						.weights_memory_read_enable(rom_dw_1_2_data_read_enable),
						.out_data_memory_in(ram_1_0_data_in[1]),
						.out_data_memory_address(ram_1_0_addr_in[1][15:0]),
						.out_data_memory_write_enable(ram_1_0_write_enable[1])
						);
	// bit length alignment
	assign ram_1_0_addr_in[1][16] = 1'b0;
	
	/// BLOCK 2
	// PW 2 0
	wire pw_2_0_reset;
	wire pw_2_0_enable;
	wire pw_2_0_finished;
	PointwiseConv2dUnit#(
						.IN_WIDTH(100),
						.IN_HEIGHT(50),
						.IN_CHANNELS(32),
						.OUT_CHANNELS(32),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.USE_MAXPOOL(1),
						.USE_MAXPOOL_CEIL_MODE(1),
						.PARALLELISM(2*8),
						.GROUPS(4),
						.USE_MAX_FINDER(0),
						.ANCHORS(3),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_pw_2_0
						(
						.clk(clk),
						.reset(pw_2_0_reset),
						.enable(pw_2_0_enable),
						.finished(pw_2_0_finished),
						.in_data_memory_out(ram_1_0_data_out[1]),
						.in_data_memory_address(ram_1_0_addr_out[1][17:0]),
						.in_data_memory_read_enable(ram_1_0_read_enable[1]),
						.weights_memory_out(rom_pw_2_0_data_out),
						.weights_memory_address(rom_pw_2_0_data_address),
						.weights_memory_read_enable(rom_pw_2_0_data_read_enable),
						.out_data_memory_in(ram_2_0_data_in[0]),
						.out_data_memory_address(ram_2_0_addr_in[0]),
						.out_data_memory_write_enable(ram_2_0_write_enable[0])
						);
	
	assign ram_1_0_addr_out[1][18] = 1'b0;
	
	// DW 2 1
	wire dw_2_1_reset;
	wire dw_2_1_enable;
	wire dw_2_1_finished;
	DepthwiseConv2dUnit #(
						.IN_WIDTH(50),
						.IN_HEIGHT(25),
						.IN_CHANNELS(32),
						.PADDING_W(1),
						.PADDING_H(1),
						.CHANNEL_MUL(2),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.GROUPS(4),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(2)
						)
						layer_dw_2_1
						(
						.clk(clk),
						.reset(dw_2_1_reset),
						.enable(dw_2_1_enable),
						.finished(dw_2_1_finished),
						.in_data_memory_out(ram_2_0_data_out[0]),
						.in_data_memory_address(ram_2_0_addr_out[0]),
						.in_data_memory_read_enable(ram_2_0_read_enable[0]),
						.weights_memory_out(rom_dw_2_1_data_out),
						.weights_memory_address(rom_dw_2_1_data_address),
						.weights_memory_read_enable(rom_dw_2_1_data_read_enable),
						.out_data_memory_in(ram_2_1_dina),
						.out_data_memory_address(ram_2_1_addra),
						.out_data_memory_write_enable(ram_2_1_wea)
						);
	
	// PW 2 2
	wire pw_2_2_reset;
	wire pw_2_2_enable;
	wire pw_2_2_finished;
	PointwiseConv2dUnit#(
						.IN_WIDTH(50),
						.IN_HEIGHT(25),
						.IN_CHANNELS(64),
						.OUT_CHANNELS(64),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.USE_MAXPOOL(1),
						.USE_MAXPOOL_CEIL_MODE(1),
						.PARALLELISM(2*8),
						.GROUPS(4),
						.USE_MAX_FINDER(0),
						.ANCHORS(3),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(2),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_pw_2_2
						(
						.clk(clk),
						.reset(pw_2_2_reset),
						.enable(pw_2_2_enable),
						.finished(pw_2_2_finished),
						.in_data_memory_out(ram_2_1_doutb),
						.in_data_memory_address(ram_2_1_addrb),
						.in_data_memory_read_enable(ram_2_1_enb),
						.weights_memory_out(rom_pw_2_2_data_out),
						.weights_memory_address(rom_pw_2_2_data_address),
						.weights_memory_read_enable(rom_pw_2_2_data_read_enable),
						.out_data_memory_in(ram_2_0_data_in[1]),
						.out_data_memory_address(ram_2_0_addr_in[1][12:0]),
						.out_data_memory_write_enable(ram_2_0_write_enable[1])
						);
	assign ram_2_0_addr_in[1][13] = 1'b0;
	
	// BLOCK 3
	// DW 3 0
	wire dw_3_0_reset;
	wire dw_3_0_enable;
	wire dw_3_0_finished;
	DepthwiseConv2dUnit #(
						.IN_WIDTH(25),
						.IN_HEIGHT(13),
						.IN_CHANNELS(64),
						.PADDING_W(1),
						.PADDING_H(1),
						.CHANNEL_MUL(2),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.GROUPS(4),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_dw_3_0
						(
						.clk(clk),
						.reset(dw_3_0_reset),
						.enable(dw_3_0_enable),
						.finished(dw_3_0_finished),
						.in_data_memory_out(ram_2_0_data_out[1]),
						.in_data_memory_address(ram_2_0_addr_out[1][14:0]),
						.in_data_memory_read_enable(ram_2_0_read_enable[1]),
						.weights_memory_out(rom_dw_3_0_data_out),
						.weights_memory_address(rom_dw_3_0_data_address),
						.weights_memory_read_enable(rom_dw_3_0_data_read_enable),
						.out_data_memory_in(ram_3_0_data_in[0]),
						.out_data_memory_address(ram_3_0_addr_in[0]),
						.out_data_memory_write_enable(ram_3_0_write_enable[0])
						);
	assign ram_2_0_addr_out[1][15] = 1'b0;
	
	// PW 3 1
	wire pw_3_1_reset;
	wire pw_3_1_enable;
	wire pw_3_1_finished;
	PointwiseConv2dUnit#(
						.IN_WIDTH(25),
						.IN_HEIGHT(13),
						.IN_CHANNELS(128),
						.OUT_CHANNELS(128),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.USE_MAXPOOL(1),
						.USE_MAXPOOL_CEIL_MODE(1),
						.PARALLELISM(2*8),
						.GROUPS(4),
						.USE_MAX_FINDER(0),
						.ANCHORS(3),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(2)
						)
						layer_pw_3_1
						(
						.clk(clk),
						.reset(pw_3_1_reset),
						.enable(pw_3_1_enable),
						.finished(pw_3_1_finished),
						.in_data_memory_out(ram_3_0_data_out[0]),
						.in_data_memory_address(ram_3_0_addr_out[0]),
						.in_data_memory_read_enable(ram_3_0_read_enable[0]),
						.weights_memory_out(rom_pw_3_1_data_out),
						.weights_memory_address(rom_pw_3_1_data_address),
						.weights_memory_read_enable(rom_pw_3_1_data_read_enable),
						.out_data_memory_in(ram_3_1_dina),
						.out_data_memory_address(ram_3_1_addra),
						.out_data_memory_write_enable(ram_3_1_wea)
						);
	
	// DW 3 2
	wire dw_3_2_reset;
	wire dw_3_2_enable;
	wire dw_3_2_finished;
	DepthwiseConv2dUnit #(
						.IN_WIDTH(13),
						.IN_HEIGHT(7),
						.IN_CHANNELS(128),
						.PADDING_W(1),
						.PADDING_H(1),
						.CHANNEL_MUL(2),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.GROUPS(4),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(2),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_dw_3_2
						(
						.clk(clk),
						.reset(dw_3_2_reset),
						.enable(dw_3_2_enable),
						.finished(dw_3_2_finished),
						.in_data_memory_out(ram_3_1_doutb),
						.in_data_memory_address(ram_3_1_addrb),
						.in_data_memory_read_enable(ram_3_1_enb),
						.weights_memory_out(rom_dw_3_2_data_out),
						.weights_memory_address(rom_dw_3_2_data_address),
						.weights_memory_read_enable(rom_dw_3_2_data_read_enable),
						.out_data_memory_in(ram_3_0_data_in[1]),
						.out_data_memory_address(ram_3_0_addr_in[1][12:0]),
						.out_data_memory_write_enable(ram_3_0_write_enable[1])
						);
	assign ram_3_0_addr_in[1][13] = 1'b0;
	
	/// BLOCK 4
	// PW 4 0
	wire pw_4_0_reset;
	wire pw_4_0_enable;
	wire pw_4_0_finished;
	PointwiseConv2dUnit#(
						.IN_WIDTH(13),
						.IN_HEIGHT(7),
						.IN_CHANNELS(256),
						.OUT_CHANNELS(128),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.USE_MAXPOOL(0),
						.USE_MAXPOOL_CEIL_MODE(0),
						.PARALLELISM(2*8),
						.GROUPS(4),
						.USE_MAX_FINDER(0),
						.ANCHORS(3),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_pw_4_0
						(
						.clk(clk),
						.reset(pw_4_0_reset),
						.enable(pw_4_0_enable),
						.finished(pw_4_0_finished),
						.in_data_memory_out(ram_3_0_data_out[1]),
						.in_data_memory_address(ram_3_0_addr_out[1][14:0]),
						.in_data_memory_read_enable(ram_3_0_read_enable[1]),
						.weights_memory_out(rom_pw_4_0_data_out),
						.weights_memory_address(rom_pw_4_0_data_address),
						.weights_memory_read_enable(rom_pw_4_0_data_read_enable),
						.out_data_memory_in(ram_4_0_data_in[0]),
						.out_data_memory_address(ram_4_0_addr_in[0][11:0]),
						.out_data_memory_write_enable(ram_4_0_write_enable[0])
						);
	assign ram_3_0_addr_out[1][15] = 1'b0;
	assign ram_4_0_addr_in[0][12] = 1'b0;
	
	// DW 4 1
	wire dw_4_1_reset;
	wire dw_4_1_enable;
	wire dw_4_1_finished;
	DepthwiseConv2dUnit #(
						.IN_WIDTH(13),
						.IN_HEIGHT(7),
						.IN_CHANNELS(128),
						.PADDING_W(1),
						.PADDING_H(1),
						.CHANNEL_MUL(2),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.GROUPS(4),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(2)
						)
						layer_dw_4_1
						(
						.clk(clk),
						.reset(dw_4_1_reset),
						.enable(dw_4_1_enable),
						.finished(dw_4_1_finished),
						.in_data_memory_out(ram_4_0_data_out[0]),
						.in_data_memory_address(ram_4_0_addr_out[0][13:0]),
						.in_data_memory_read_enable(ram_4_0_read_enable[0]),
						.weights_memory_out(rom_dw_4_1_data_out),
						.weights_memory_address(rom_dw_4_1_data_address),
						.weights_memory_read_enable(rom_dw_4_1_data_read_enable),
						.out_data_memory_in(ram_4_1_dina),
						.out_data_memory_address(ram_4_1_addra),
						.out_data_memory_write_enable(ram_4_1_wea)
						);
	assign ram_4_0_addr_out[0][14] = 1'b0;
	
	// PW 4 2
	wire pw_4_2_reset;
	wire pw_4_2_enable;
	wire pw_4_2_finished;
	PointwiseConv2dUnit#(
						.IN_WIDTH(13),
						.IN_HEIGHT(7),
						.IN_CHANNELS(256),
						.OUT_CHANNELS(256),
						.USE_BIAS(0),
						.USE_BN(1),
						.USE_RELU(1),
						.USE_MAXPOOL(0),
						.USE_MAXPOOL_CEIL_MODE(0),
						.PARALLELISM(2*8),
						.GROUPS(4),
						.USE_MAX_FINDER(0),
						.ANCHORS(3),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(1),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(2),
						.WRITE_MEMORY_LATENCY(3)
						)
						layer_pw_4_2
						(
						.clk(clk),
						.reset(pw_4_2_reset),
						.enable(pw_4_2_enable),
						.finished(pw_4_2_finished),
						.in_data_memory_out(ram_4_1_doutb),
						.in_data_memory_address(ram_4_1_addrb),
						.in_data_memory_read_enable(ram_4_1_enb),
						.weights_memory_out(rom_pw_4_2_data_out),
						.weights_memory_address(rom_pw_4_2_data_address),
						.weights_memory_read_enable(rom_pw_4_2_data_read_enable),
						.out_data_memory_in(ram_4_0_data_in[1]),
						.out_data_memory_address(ram_4_0_addr_in[1]),
						.out_data_memory_write_enable(ram_4_0_write_enable[1])
						);
	
	// BLOCK 5
	// PW 5 0
	wire pw_5_0_reset;
	wire pw_5_0_enable;
	wire pw_5_0_finished;
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
						.PARALLELISM(5*1),
						.GROUPS(1),
						.USE_MAX_FINDER(1),
						.ANCHORS(3),
						.IN_DATA_BIT_WIDTH(8),
						.IN_DATA_INT_WIDTH(1),
						.IN_DATA_SIGN(1),
						.WEIGHT_DATA_BIT_WIDTH(8),
						.WEIGHT_DATA_INT_WIDTH(3),
						.WEIGHT_DATA_SIGN(1),
						.OUT_DATA_BIT_WIDTH(8),
						.OUT_DATA_INT_WIDTH(3),
						.OUT_DATA_SIGN(1),
						.READ_MEMORY_LATENCY(3),
						.WRITE_MEMORY_LATENCY(2)
						)
						layer_pw_5_0
						(
						.clk(clk),
						.reset(pw_5_0_reset),
						.enable(pw_5_0_enable),
						.finished(pw_5_0_finished),
						.in_data_memory_out(ram_4_0_data_out[1]),
						.in_data_memory_address(ram_4_0_addr_out[1]),
						.in_data_memory_read_enable(ram_4_0_read_enable[1]),
						.weights_memory_out(rom_pw_5_0_data_out),
						.weights_memory_address(rom_pw_5_0_data_address),
						.weights_memory_read_enable(rom_pw_5_0_data_read_enable),
						.out_data_memory_in(ram_5_0_dina),
						.out_data_memory_address(ram_5_0_addra),
						.out_data_memory_write_enable(ram_5_0_wea)
						);
	// END OF LAYERS
	//

	// enable registers
	reg iw_0_0_enable_reg = 1'b0;
	reg dw_1_0_enable_reg = 1'b0;
	reg pw_1_1_enable_reg = 1'b0;
	reg dw_1_2_enable_reg = 1'b0;
	reg pw_2_0_enable_reg = 1'b0;
	reg dw_2_1_enable_reg = 1'b0;
	reg pw_2_2_enable_reg = 1'b0;
	reg dw_3_0_enable_reg = 1'b0;
	reg pw_3_1_enable_reg = 1'b0;
	reg dw_3_2_enable_reg = 1'b0;
	reg pw_4_0_enable_reg = 1'b0;
	reg dw_4_1_enable_reg = 1'b0;
	reg pw_4_2_enable_reg = 1'b0;
	reg pw_5_0_enable_reg = 1'b0;
	// connect enables of layers with registers
	assign iw_0_0_enable = iw_0_0_enable_reg;
	assign dw_1_0_enable = dw_1_0_enable_reg;
	assign pw_1_1_enable = pw_1_1_enable_reg;
	assign dw_1_2_enable = dw_1_2_enable_reg;
	assign pw_2_0_enable = pw_2_0_enable_reg;
	assign dw_2_1_enable = dw_2_1_enable_reg;
	assign pw_2_2_enable = pw_2_2_enable_reg;
	assign dw_3_0_enable = dw_3_0_enable_reg;
	assign pw_3_1_enable = pw_3_1_enable_reg;
	assign dw_3_2_enable = dw_3_2_enable_reg;
	assign pw_4_0_enable = pw_4_0_enable_reg;
	assign dw_4_1_enable = dw_4_1_enable_reg;
	assign pw_4_2_enable = pw_4_2_enable_reg;
	assign pw_5_0_enable = pw_5_0_enable_reg;
	
	// reset registers
	reg iw_0_0_reset_reg = 1'b1;
	reg dw_1_0_reset_reg = 1'b1;
	reg pw_1_1_reset_reg = 1'b1;
	reg dw_1_2_reset_reg = 1'b1;
	reg pw_2_0_reset_reg = 1'b1;
	reg dw_2_1_reset_reg = 1'b1;
	reg pw_2_2_reset_reg = 1'b1;
	reg dw_3_0_reset_reg = 1'b1;
	reg pw_3_1_reset_reg = 1'b1;
	reg dw_3_2_reset_reg = 1'b1;
	reg pw_4_0_reset_reg = 1'b1;
	reg dw_4_1_reset_reg = 1'b1;
	reg pw_4_2_reset_reg = 1'b1;
	reg pw_5_0_reset_reg = 1'b1;
	// connect resets of layers
	assign iw_0_0_reset = iw_0_0_reset_reg;
	assign dw_1_0_reset = dw_1_0_reset_reg;
	assign pw_1_1_reset = pw_1_1_reset_reg;
	assign dw_1_2_reset = dw_1_2_reset_reg;
	assign pw_2_0_reset = pw_2_0_reset_reg;
	assign dw_2_1_reset = dw_2_1_reset_reg;
	assign pw_2_2_reset = pw_2_2_reset_reg;
	assign dw_3_0_reset = dw_3_0_reset_reg;
	assign pw_3_1_reset = pw_3_1_reset_reg;
	assign dw_3_2_reset = dw_3_2_reset_reg;
	assign pw_4_0_reset = pw_4_0_reset_reg;
	assign dw_4_1_reset = dw_4_1_reset_reg;
	assign pw_4_2_reset = pw_4_2_reset_reg;
	assign pw_5_0_reset = pw_5_0_reset_reg;
	
	// sleep registers
	// rams
	(* KEEP = "TRUE" *) reg ram_0_0_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg ram_1_1_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg ram_2_1_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg ram_3_1_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg ram_4_1_sleep_reg = 0;
	// roms
	(* KEEP = "TRUE" *) reg rom_dw_1_0_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_pw_1_1_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_dw_1_2_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_pw_2_0_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_dw_2_1_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_pw_2_2_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_dw_3_0_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_pw_3_1_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_dw_3_2_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_pw_4_0_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_dw_4_1_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_pw_4_2_sleep_reg = 0;
	(* KEEP = "TRUE" *) reg rom_pw_5_0_sleep_reg = 0;
	// connect rom sleeps
	assign rom_dw_1_0_sleep = rom_dw_1_0_sleep_reg;
	assign rom_pw_1_1_sleep = rom_pw_1_1_sleep_reg;
	assign rom_dw_1_2_sleep = rom_dw_1_2_sleep_reg;
	assign rom_pw_2_0_sleep = rom_pw_2_0_sleep_reg;
	assign rom_dw_2_1_sleep = rom_dw_2_1_sleep_reg;
	assign rom_pw_2_2_sleep = rom_pw_2_2_sleep_reg;
	assign rom_dw_3_0_sleep = rom_dw_3_0_sleep_reg;
	assign rom_pw_3_1_sleep = rom_pw_3_1_sleep_reg;
	assign rom_dw_3_2_sleep = rom_dw_3_2_sleep_reg;
	assign rom_pw_4_0_sleep = rom_pw_4_0_sleep_reg;
	assign rom_dw_4_1_sleep = rom_dw_4_1_sleep_reg;
	assign rom_pw_4_2_sleep = rom_pw_4_2_sleep_reg;
	assign rom_pw_5_0_sleep = rom_pw_5_0_sleep_reg;
	// input layer ram
	assign ram_0_0_sleep = ram_0_0_sleep_reg;
	// connect sleeps of full time used rams 
	assign ram_1_0_sleep = 1'b0;
	assign ram_2_0_sleep = 1'b0;
	assign ram_3_0_sleep = 1'b0;
	assign ram_4_0_sleep = 1'b0;
	// connect sleeps of block's internal memory rams 
	assign ram_1_1_sleep = ram_1_1_sleep_reg;
	assign ram_2_1_sleep = ram_2_1_sleep_reg;
	assign ram_3_1_sleep = ram_3_1_sleep_reg;
	assign ram_4_1_sleep = ram_4_1_sleep_reg;
	
	// connect enables port a (when writer layer is enabled) 
	// of internal blocks memories
	assign ram_0_0_ena = iw_0_0_enable;
	assign ram_1_1_ena = pw_1_1_enable;
	assign ram_2_1_ena = dw_2_1_enable;
	assign ram_3_1_ena = pw_3_1_enable;
	assign ram_4_1_ena = dw_4_1_enable;
	// sharing ram selectors
	// memories selectors write
	assign ram_1_0_write_sel = dw_1_2_enable;
	assign ram_2_0_write_sel = pw_2_2_enable;
	assign ram_3_0_write_sel = dw_3_2_enable;
	assign ram_4_0_write_sel = pw_4_2_enable;
	// memories selectors read
	assign ram_1_0_read_sel = pw_2_0_enable;
	assign ram_2_0_read_sel = dw_3_0_enable;
	assign ram_3_0_read_sel = pw_4_0_enable;
	assign ram_4_0_read_sel = pw_5_0_enable;
	// enable port a of shared memories when is needed writing
	assign ram_1_0_ena = dw_1_0_enable || dw_1_2_enable;
	assign ram_2_0_ena = pw_2_0_enable || pw_2_2_enable;
	assign ram_3_0_ena = dw_3_0_enable || dw_3_2_enable;
	assign ram_4_0_ena = pw_4_0_enable || pw_4_2_enable;
	
	(* KEEP = "TRUE" *)
	reg [3:0] state = 4'd13;
	
	localparam AWAKENING_TIME = 17;
	localparam AWAKENING_TIME_BITS = $clog2(AWAKENING_TIME);
	(* KEEP = "TRUE" *)
	reg [AWAKENING_TIME_BITS-1:0] awakening_cntr = 0;
	
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
				iw_0_0_reset_reg <= 0;
				dw_1_0_reset_reg <= 0;
				pw_1_1_reset_reg <= 0;
				dw_1_2_reset_reg <= 0;
				pw_2_0_reset_reg <= 0;
				dw_2_1_reset_reg <= 0;
				pw_2_2_reset_reg <= 0;
				dw_3_0_reset_reg <= 0;
				pw_3_1_reset_reg <= 0;
				dw_3_2_reset_reg <= 0;
				pw_4_0_reset_reg <= 0;
				dw_4_1_reset_reg <= 0;
				pw_4_2_reset_reg <= 0;
				pw_5_0_reset_reg <= 0;
				// turn off all modules
				iw_0_0_enable_reg <= 0;
				dw_1_0_enable_reg <= 0;
				pw_1_1_enable_reg <= 0;
				dw_1_2_enable_reg <= 0;
				pw_2_0_enable_reg <= 0;
				dw_2_1_enable_reg <= 0;
				pw_2_2_enable_reg <= 0;
				dw_3_0_enable_reg <= 0;
				pw_3_1_enable_reg <= 0;
				dw_3_2_enable_reg <= 0;
				pw_4_0_enable_reg <= 0;
				dw_4_1_enable_reg <= 0;
				pw_4_2_enable_reg <= 0;
				pw_5_0_enable_reg <= 0;
				
				// awake all rams
				awakening_cntr <= 0;
				// to first processing step
				state <= 4'd1;
				end
				
			// first processing step
			4'd1:
				begin
				iw_0_0_reset_reg <= 1'b1;
				pw_1_1_reset_reg <= 1'b1;
				pw_2_2_reset_reg <= 1'b1;
				pw_4_0_reset_reg <= 1'b1;
				
				// awakening of rams time
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
				iw_0_0_reset_reg <= 1'b0;
				pw_1_1_reset_reg <= 1'b0;
				pw_2_2_reset_reg <= 1'b0;
				pw_4_0_reset_reg <= 1'b0;
				
				iw_0_0_enable_reg <= 1'b1;
				pw_1_1_enable_reg <= 1'b1;
				pw_2_2_enable_reg <= 1'b1;
				pw_4_0_enable_reg <= 1'b1;
				// to working state
				state <= 4'd3;
				end
			4'd3:
				begin
				// turn off finished layers if finish work
				if (   iw_0_0_finished 
					&& pw_1_1_finished 
					&& pw_2_2_finished 
					&& pw_4_0_finished)
					begin
					iw_0_0_enable_reg <= 1'b0;
					pw_1_1_enable_reg <= 1'b0;
					pw_2_2_enable_reg <= 1'b0;
					pw_4_0_enable_reg <= 1'b0;
					// next processing step
					state <= 4'd4;
					end
				end
				
			// second processing step
			4'd4:
				begin
				dw_1_2_reset_reg <= 1'b1;
				dw_3_0_reset_reg <= 1'b1;
				dw_4_1_reset_reg <= 1'b1;
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
				dw_1_2_reset_reg <= 1'b0;
				dw_3_0_reset_reg <= 1'b0;
				dw_4_1_reset_reg <= 1'b0;
				
				dw_1_2_enable_reg <= 1'b1;
				dw_3_0_enable_reg <= 1'b1;
				dw_4_1_enable_reg <= 1'b1;
				// to working state
				state <= 4'd6;
				end
			4'd6:
				begin
				// turn off finished layers if finish work
				if (   dw_1_2_finished 
					&& dw_3_0_finished 
					&& dw_4_1_finished)
					begin
					dw_1_2_enable_reg <= 1'b0;
					dw_3_0_enable_reg <= 1'b0;
					dw_4_1_enable_reg <= 1'b0;
					// next processing step
					state <= 4'd7;
					end
				end
			
			// third processing step
			4'd7:
				begin
				pw_2_0_reset_reg <= 1'b1;
				pw_3_1_reset_reg <= 1'b1;
				pw_4_2_reset_reg <= 1'b1;
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
				pw_2_0_reset_reg <= 1'b0;
				pw_3_1_reset_reg <= 1'b0;
				pw_4_2_reset_reg <= 1'b0;
				
				pw_2_0_enable_reg <= 1'b1;
				pw_3_1_enable_reg <= 1'b1;
				pw_4_2_enable_reg <= 1'b1;
				// to working state
				state <= 4'd9;
				end
			4'd9:
				begin
				// turn off finished layers if finish work
				if (   pw_2_0_finished 
					&& pw_3_1_finished 
					&& pw_4_2_finished)
					begin
					pw_2_0_enable_reg <= 1'b0;
					pw_3_1_enable_reg <= 1'b0;
					pw_4_2_enable_reg <= 1'b0;
					// next processing step
					state <= 4'd10;
					end
				end
			
			// fourth processing step
			4'd10:
				begin
				dw_1_0_reset_reg <= 1'b1;
				dw_2_1_reset_reg <= 1'b1;
				dw_3_2_reset_reg <= 1'b1;
				pw_5_0_reset_reg <= 1'b1;
				
				// awakening of rams time
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
				dw_1_0_reset_reg <= 1'b0;
				dw_2_1_reset_reg <= 1'b0;
				dw_3_2_reset_reg <= 1'b0;
				pw_5_0_reset_reg <= 1'b0;
				
				dw_1_0_enable_reg <= 1'b1;
				dw_2_1_enable_reg <= 1'b1;
				dw_3_2_enable_reg <= 1'b1;
				pw_5_0_enable_reg <= 1'b1;
				// to working state
				state <= 4'd12;
				end
			4'd12:
				begin
				// turn off finished layers if finish work
				if (   dw_1_0_finished 
					&& dw_2_1_finished 
					&& dw_3_2_finished 
					&& pw_5_0_finished 
					&& output_was_read)
					begin
					dw_1_0_enable_reg <= 1'b0;
					dw_2_1_enable_reg <= 1'b0;
					dw_3_2_enable_reg <= 1'b0;
					pw_5_0_enable_reg <= 1'b0;
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
				iw_0_0_reset_reg <= 1'b1;
				dw_1_0_reset_reg <= 1'b1;
				pw_1_1_reset_reg <= 1'b1;
				dw_1_2_reset_reg <= 1'b1;
				pw_2_0_reset_reg <= 1'b1;
				dw_2_1_reset_reg <= 1'b1;
				pw_2_2_reset_reg <= 1'b1;
				dw_3_0_reset_reg <= 1'b1;
				pw_3_1_reset_reg <= 1'b1;
				dw_3_2_reset_reg <= 1'b1;
				pw_4_0_reset_reg <= 1'b1;
				dw_4_1_reset_reg <= 1'b1;
				pw_4_2_reset_reg <= 1'b1;
				pw_5_0_reset_reg <= 1'b1;
				// disable all modules
				iw_0_0_enable_reg <= 1'b0;
				dw_1_0_enable_reg <= 1'b0;
				pw_1_1_enable_reg <= 1'b0;
				dw_1_2_enable_reg <= 1'b0;
				pw_2_0_enable_reg <= 1'b0;
				dw_2_1_enable_reg <= 1'b0;
				pw_2_2_enable_reg <= 1'b0;
				dw_3_0_enable_reg <= 1'b0;
				pw_3_1_enable_reg <= 1'b0;
				dw_3_2_enable_reg <= 1'b0;
				pw_4_0_enable_reg <= 1'b0;
				dw_4_1_enable_reg <= 1'b0;
				pw_4_2_enable_reg <= 1'b0;
				pw_5_0_enable_reg <= 1'b0;
				
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
			
			// sleep control
			case (state)
				4'd0:
					begin
					// put sleep all rams and roms
					ram_0_0_sleep_reg <= 1;
					ram_1_1_sleep_reg <= 1;
					ram_2_1_sleep_reg <= 1;
					ram_3_1_sleep_reg <= 1;
					ram_4_1_sleep_reg <= 1;
					rom_dw_1_0_sleep_reg <= 1;
					rom_pw_1_1_sleep_reg <= 1;
					rom_dw_1_2_sleep_reg <= 1;
					rom_pw_2_0_sleep_reg <= 1;
					rom_dw_2_1_sleep_reg <= 1;
					rom_pw_2_2_sleep_reg <= 1;
					rom_dw_3_0_sleep_reg <= 1;
					rom_pw_3_1_sleep_reg <= 1;
					rom_dw_3_2_sleep_reg <= 1;
					rom_pw_4_0_sleep_reg <= 1;
					rom_dw_4_1_sleep_reg <= 1;
					rom_pw_4_2_sleep_reg <= 1;
					rom_pw_5_0_sleep_reg <= 1;
					end
				
				// processing step 1
				4'd1:
					begin
					// awake
					rom_pw_1_1_sleep_reg <= 0;
					rom_pw_2_2_sleep_reg <= 0;
					rom_pw_4_0_sleep_reg <= 0;
					
					ram_0_0_sleep_reg <= 0;
					ram_1_1_sleep_reg <= 0;
					ram_2_1_sleep_reg <= 0;
					end
				4'd2:
					begin
					// put to sleep
					rom_dw_1_0_sleep_reg <= 1;
					rom_dw_2_1_sleep_reg <= 1;
					rom_dw_3_2_sleep_reg <= 1;
					rom_pw_5_0_sleep_reg <= 1;
					
					ram_3_1_sleep_reg <= 1;
					end
				
				// processing step 2
				4'd4:
					begin
					// awake
					rom_dw_1_2_sleep_reg <= 0;
					rom_dw_3_0_sleep_reg <= 0;
					rom_dw_4_1_sleep_reg <= 0;
					
					ram_1_1_sleep_reg <= 0;
					ram_4_1_sleep_reg <= 0;
					end
				4'd5:
					begin
					// put to sleep
					ram_0_0_sleep_reg <= 1;
					ram_2_1_sleep_reg <= 1;
					ram_3_1_sleep_reg <= 1;
					
					rom_pw_1_1_sleep_reg <= 1;
					rom_pw_2_2_sleep_reg <= 1;
					rom_pw_4_0_sleep_reg <= 1;
					end
				
				// processing step 3
				4'd7:
					begin
					// awake
					ram_3_1_sleep_reg <= 0;
					ram_4_1_sleep_reg <= 0;
					
					rom_pw_2_0_sleep_reg <= 0;
					rom_pw_3_1_sleep_reg <= 0;
					rom_pw_4_2_sleep_reg <= 0;
					end
				4'd8:
					begin
					// put to sleep
					ram_0_0_sleep_reg <= 1;
					ram_1_1_sleep_reg <= 1;
					ram_2_1_sleep_reg <= 1;
					
					rom_dw_1_2_sleep_reg <= 1;
					rom_dw_3_0_sleep_reg <= 1;
					rom_dw_4_1_sleep_reg <= 1;
					end
				
				// processing step 4
				4'd10:
					begin
					ram_0_0_sleep_reg <= 0;
					ram_2_1_sleep_reg <= 0;
					ram_3_1_sleep_reg <= 0;
					
					rom_dw_1_0_sleep_reg <= 0;
					rom_dw_2_1_sleep_reg <= 0;
					rom_dw_3_2_sleep_reg <= 0;
					rom_pw_5_0_sleep_reg <= 0;
					end
				4'd11:
					begin
					// put to sleep
					ram_1_1_sleep_reg <= 1;
					ram_4_1_sleep_reg <= 1;
					
					rom_pw_2_0_sleep_reg <= 1;
					rom_pw_3_1_sleep_reg <= 1;
					rom_pw_4_2_sleep_reg <= 1;
					end
					
				default:
					begin
					end
			endcase
			
			end

		end
	// always end
	
	assign write_possible = !iw_0_0_last_data_received 
							&& iw_0_0_enable 
							&& !iw_0_0_reset;
	assign output_data = ram_5_0_registers;
	assign output_data_ready = pw_5_0_finished && pw_5_0_enable_reg && !pw_5_0_reset_reg;
	
endmodule // LittleNetAcc

