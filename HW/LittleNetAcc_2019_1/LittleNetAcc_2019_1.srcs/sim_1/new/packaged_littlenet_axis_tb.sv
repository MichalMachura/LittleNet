`timescale 10ns / 100ps

module LittleNetAccAxi_tb();
	
	// CLOCK GENERATOR
	reg clk = 1'b0;
	initial 
		begin
		clk <= 1'b0;
		#5;
		forever
			begin
			#5; clk <= 1'b1;
			#5; clk <= 1'b0;
			end
		end
	
	reg [31:0] data = 0;
	reg data_validity = 0;
	// INPUT DATA
	
	reg [7:0] memory [3*100*200]; 
	initial
		begin
		$readmemb("F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/custom_memory_inits/rom_init_data_net.txt", memory);
		end
	
	
	wire reset = 0;
	wire s_axis_clk = clk;
	wire [31:0] s_axis_tdata = data;
	wire [3:0] s_axis_tkeep = 4'b1111;
	reg s_axis_tlast = 1'b0;
	wire s_axis_tvalid = data_validity;
	wire s_axis_tready;
	
	initial
		begin
		forever
			begin
			@(posedge clk);
			#1;
			// wait(clk);
			
			for(int iter = 0, flag= 1; iter < (3*100*200)/4; iter = iter+1)
				begin
				flag = 1;
				data = {memory[4*iter+3],
						memory[4*iter+2],
						memory[4*iter+1],
						memory[4*iter]};
				data_validity = 1;
				s_axis_tlast = iter == (3*100*200)/4-1;
				while (flag)
					begin
					@(posedge clk);
					// if slave were ready
					if (s_axis_tready)
						begin
						// wait for end of edge when clk is == 1
						#1;
						// wait(clk);
						// break while loop
						flag = 0;
						end
					end
				end
			// for end
			
			data_validity = 0;
			s_axis_tlast = 0;
			end
		
		end
	
	
	wire m_axis_clk = clk;
	wire [31:0] m_axis_tdata;
	wire [3:0] m_axis_tkeep;
	wire m_axis_tlast;
	wire m_axis_tvalid;
	reg m_axis_tready = 0;
	
	always @(posedge clk)
	   begin
	   m_axis_tready <= !m_axis_tready;
	   end
	
	
	LittleNetAccAxi LNAA
		(
		.clk(clk),
		.reset(reset),
		.s_axis_clk(s_axis_clk),
		.s_axis_tdata(s_axis_tdata),
		.s_axis_tkeep(s_axis_tkeep),
		.s_axis_tlast(s_axis_tlast),
		.s_axis_tvalid(s_axis_tvalid),
		.s_axis_tready(s_axis_tready),
		.m_axis_clk(m_axis_clk),
		.m_axis_tdata(m_axis_tdata),
		.m_axis_tkeep(m_axis_tkeep),
		.m_axis_tlast(m_axis_tlast),
		.m_axis_tvalid(m_axis_tvalid),
		.m_axis_tready(m_axis_tready)
		);
	
endmodule
