`timescale 1ns / 1ps


module LittleNetAcc_tb ();
	
	// CLOCK GENERATOR
	reg clk = 1'b0;
	// reg axi_clk = 1'b0;
	wire axi_clk = clk;
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
	
	// always @(posedge clk)
	// 	begin
	// 	axi_clk <= !axi_clk;
	// 	end
	// always end
	
	// reg [7:0] value = 0;
	// wire data_valid = 1;
	
	// always @(posedge axi_clk)
	// 	begin
	// 	value <= value+1;
	// 	end
	// always end
	
	wire acc_tready;
	wire [31:0] acc_tdata;
	wire acc_tvalid;
	wire [3:0] acc_tkeep = 4'b1111;
	wire acc_tlast;
	
	// localparam ADDR = $clog2(3*32*32/4);
	// localparam IMG_SIZE = 3*32*32/4;
	localparam IMG_SIZE = 3*112*208/4;
	localparam ADDR = $clog2(IMG_SIZE);
	
	reg [ADDR-1:0] cntr = 0;
	reg is_last_1 = 0;
	reg is_last_2 = 0;
	reg is_valid_1 = 0;
	reg is_valid_2 = 0;
	wire is_last = cntr == IMG_SIZE-1;
	wire [31:0] in_data_memory_out;
	wire [ADDR-1:0] in_data_memory_address = cntr;
	wire in_data_memory_read_enable = acc_tready;
		
	LittleNetAccAxi 
				ln
				(
				.clk(clk),
				.reset(1'b0),
				
				.s_axis_clk(axi_clk),
				.s_axis_tdata(in_data_memory_out),
				.s_axis_tkeep(4'b1111),
				.s_axis_tlast(is_last_2),
				.s_axis_tvalid(is_valid_2),
				.s_axis_tready(acc_tready),
				
				.m_axis_clk(axi_clk),
				.m_axis_tdata(acc_tdata),
				.m_axis_tkeep(acc_tkeep),
				.m_axis_tlast(acc_tlast),
				.m_axis_tvalid(acc_tvalid),
				.m_axis_tready(1'b1)
				);
	// INPUT DATA	
	
	always @(posedge axi_clk) 
		begin
		if (acc_tready)
			begin
			if(is_last)
				cntr = 0;
			else
				cntr = cntr + 1;
			is_last_1 <= is_last;
			is_last_2 <= is_last_1;
			is_valid_1 <= 1'b1;
			is_valid_2 <= is_valid_1;
			end
		end
		
	(*dont_touch = "true"*)
	xpm_memory_sprom #(
      .ADDR_WIDTH_A(ADDR),              // DECIMAL
      .AUTO_SLEEP_TIME(0),           // DECIMAL
      .CASCADE_HEIGHT(0),            // DECIMAL
      .ECC_MODE("no_ecc"),           // String
      .MEMORY_INIT_FILE("sim_memory_input.mem"),     // String
      .MEMORY_INIT_PARAM(""),       // String
      .MEMORY_OPTIMIZATION("true"),  // String
      .MEMORY_PRIMITIVE("distributed"),     // String
      .MEMORY_SIZE(32*IMG_SIZE),            // DECIMAL
      .MESSAGE_CONTROL(0),           // DECIMAL
      .READ_DATA_WIDTH_A(32),        // DECIMAL
      .READ_LATENCY_A(2),            // DECIMAL
      .READ_RESET_VALUE_A("0"),      // String
      .RST_MODE_A("SYNC"),           // String
      .SIM_ASSERT_CHK(0),            // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_MEM_INIT(1),              // DECIMAL
      .WAKEUP_TIME("disable_sleep")  // String
   )
   input_ROM_blk (
	  .clka(clk),
	  .douta(in_data_memory_out),
	  .addra(in_data_memory_address),
	  .ena(in_data_memory_read_enable),
	  .sleep(1'b0),
	
      .injectdbiterra(1'b0),
      .injectsbiterra(1'b0),
      .regcea(in_data_memory_read_enable),
      .rsta(1'b0)
   );
endmodule // LittleNetAcc_tb

