set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:1 order:LATE scoped_inst:ln/in_ram/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:2 order:LATE scoped_inst:ln/ram_1_0/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:3 order:LATE scoped_inst:ln/ram_1_1/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:4 order:LATE scoped_inst:ln/ram_2_0/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:5 order:LATE scoped_inst:ln/ram_2_1/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:6 order:LATE scoped_inst:ln/ram_3_1/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:7 order:LATE scoped_inst:ln/ram_4_1/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:8 order:LATE scoped_inst:ln/ram_3_0/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:9 order:LATE scoped_inst:ln/ram_4_0/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:10 order:LATE scoped_inst:ln/ram_5_0/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
set_property SRC_FILE_INFO {cfile:/media/michal/HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl rfile:../../../../../../../HDD_Linux1/Xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/tcl/xpm_memory_xdc.tcl id:11 order:LATE scoped_inst:ln/ram_5_1/xpm_memory_sdpram_inst unmanaged:yes} [current_design]
current_instance ln/in_ram/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:1 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_1_0/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:2 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_1_1/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:3 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_2_0/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:4 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_2_1/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:5 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_3_1/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:6 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_4_1/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:7 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_3_0/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:8 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_4_0/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:9 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_5_0/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:10 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
current_instance
current_instance ln/ram_5_1/xpm_memory_sdpram_inst
set_property src_info {type:SCOPED_XDC file:11 line:3 export:INPUT save:NONE read:READ} [current_design]
set my_var [get_property dram_emb_xdc [get_cells -hier  -filter {PRIMITIVE_SUBGROUP==LUTRAM || PRIMITIVE_SUBGROUP==dram || PRIMITIVE_SUBGROUP==uram || PRIMITIVE_SUBGROUP==BRAM}]]
