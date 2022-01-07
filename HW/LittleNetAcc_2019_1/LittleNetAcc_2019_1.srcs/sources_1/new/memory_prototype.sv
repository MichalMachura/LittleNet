`timescale 1ns / 1ps

module FileROM
		#(
		 parameter path="/dst_dir/image.ppm",
		 parameter IMG_WIDTH=360,
		 parameter IMG_HIGHT=180,
		 parameter IMG_CHANNELS=3,
		 parameter WIDTH=8,
		 parameter DEPTH=IMG_CHANNELS*IMG_HIGHT*IMG_WIDTH,
		 
		 localparam ADDRESS_WIDTH = $clog2(DEPTH)
		 )
		 (
		 input clka,
		 input ena,
		 input [ADDRESS_WIDTH-1:0] addra,
		 output [WIDTH-1:0] douta,
		 
		 input sleep
		 );
		
	reg [WIDTH-1:0] memory [DEPTH];
	reg [ADDRESS_WIDTH-1:0] latched_in_address = 0;
	reg [WIDTH-1:0] latched_output = 0;
	
	initial
		begin
		for(int i=0; i < DEPTH; i = i+1)
			memory[i] = 0;
			
		$readmemb(path, memory);
		end
	
	always @(posedge clka)
		begin
		if (ena)
			begin
			latched_in_address <= addra;
			latched_output <= memory[latched_in_address];
			end
		end
	// always end
	
	assign douta = latched_output;
	
endmodule // FileReader


module SinglePortRAMSavable
				#(
				parameter path="/dst_dir/mem_%0d.ppm",
				parameter IMG_WIDTH=360,
				parameter IMG_HIGHT=180,
				parameter IMG_CHANNELS=3,
				parameter WIDTH=8,
				parameter DEPTH=IMG_CHANNELS*IMG_HIGHT*IMG_WIDTH,
				
				localparam ADDRESS_WIDTH = $clog2(DEPTH)
				)
				(
				input clka,
				input wea,
				input ena,
				input [ADDRESS_WIDTH-1:0] addra,
				input [WIDTH-1:0] dina,
				output [WIDTH-1:0] douta,
				
				input save,
				
				input sleep
				);
	reg [WIDTH-1:0] memory [DEPTH];
	reg [ADDRESS_WIDTH-1:0] latched_address = 0;
	reg [WIDTH-1:0] latched_input = 0;
	reg [WIDTH-1:0] latched_output = 0;
	reg saving = 0;
	
	reg prev_clka = 0;
	
	string format;
	int idx = 0; 
	
	initial
		begin
		for(int i=0; i < DEPTH; i = i+1)
			memory[i] = 0;
		
		forever
			begin
			if (prev_clka != clka)
				begin
				if (saving)
					begin
					$sformat(format, path, idx);
					$writememb(format, memory);
					saving = 0;
					idx = idx+1;
					end
				end
			
			prev_clka = clka;
			#1;
			end
		end
	
	always @(posedge clka)
		begin
		if (ena)
			begin
			if (wea)
				begin
				latched_address <= addra;
				latched_input <= dina;
				end
				
			memory[latched_address] <= latched_input;
			latched_output <= memory[latched_address];
			end
		end
	// always end
		
	always @(posedge save)
		begin
		saving <= 1;
		end
	// always end
	
	
endmodule // FileWriter

