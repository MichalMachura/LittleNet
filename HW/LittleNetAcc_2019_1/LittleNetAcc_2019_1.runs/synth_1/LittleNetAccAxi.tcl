# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param chipscope.maxJobs 2
set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL-1065} -limit 10000
set_msg_config  -id {IP_Flow 19-3153}  -string {{WARNING: [IP_Flow 19-3153] Bus Interface 'm_axis_clk': ASSOCIATED_BUSIF bus parameter is missing.}}  -suppress 
create_project -in_memory -part xczu3eg-sbva484-1-i

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.cache/wt [current_project]
set_property parent.project_path F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs [current_project]
update_ip_catalog
set_property ip_output_repo f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_dw_1_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_dw_1_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_pw_1_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_pw_2_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_dw_2_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_pw_2_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_dw_3_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_pw_3_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_dw_3_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_pw_4_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_dw_4_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_pw_4_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/imports/LittleNet_ACC/memory_init/rom_pw_5_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_dw_1_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_pw_1_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_dw_1_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_pw_2_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_dw_2_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_pw_2_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_dw_3_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_pw_3_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_dw_3_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_pw_4_0.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_dw_4_1.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_pw_4_2.coe
add_files F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/rom_init/rom_pw_5_0.coe
read_verilog -library xil_defaultlib -sv {
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/delay_line.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/depthwise_conv2d_unit.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/little_net_acc.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/maxpool2d_unit.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/mux_writer_unit.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/pointwise_conv2d_unit.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/shift_reg.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/sliding_window_unit.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/streamer_unit.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/utils.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/weights_loading_unit.sv
  F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/new/packaged_littlenet.sv
}
read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_C/DSP_A_mul_B_add_C.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_C/DSP_A_mul_B_add_C_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_add_C/DSP_A_add_C.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_add_C/DSP_A_add_C_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_ACC/DSP_A_mul_B_ACC.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_ACC/DSP_A_mul_B_ACC_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_STREAMER/DSP_STREAMER.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_STREAMER/DSP_STREAMER_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_C_PCOUT/DSP_A_mul_B_add_C_PCOUT.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_C_PCOUT/DSP_A_mul_B_add_C_PCOUT_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_PCIN/DSP_A_mul_B_add_PCIN.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_PCIN/DSP_A_mul_B_add_PCIN_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_PCIN_PCOUT/DSP_A_mul_B_add_PCIN_PCOUT.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_PCIN_PCOUT/DSP_A_mul_B_add_PCIN_PCOUT_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_PCOUT/DSP_A_mul_B_PCOUT.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_PCOUT/DSP_A_mul_B_PCOUT_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_5824e_13a_B8_15a/RAM_A32_5824e_13a_B8_15a.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_5824e_13a_B8_15a/RAM_A32_5824e_13a_B8_15a_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_2912e_12a_B8_14a/RAM_A32_2912e_12a_B8_14a.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_2912e_12a_B8_14a/RAM_A32_2912e_12a_B8_14a_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_10400e_14a_B8_16a/RAM_A32_10400e_14a_B8_16a.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_10400e_14a_B8_16a/RAM_A32_10400e_14a_B8_16a_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_20000e_15a_B8_17a/RAM_A32_20000e_15a_B8_17a.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_20000e_15a_B8_17a/RAM_A32_20000e_15a_B8_17a_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_10000e_14a_B8_16a/RAM_A32_10000e_14a_B8_16a.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_10000e_14a_B8_16a/RAM_A32_10000e_14a_B8_16a_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_75000e_17a_B8_19a/RAM_A32_75000e_17a_B8_19a.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_75000e_17a_B8_19a/RAM_A32_75000e_17a_B8_19a_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_15000e_14a_B8_16a/RAM_A32_15000e_14a_B8_16a.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_15000e_14a_B8_16a/RAM_A32_15000e_14a_B8_16a_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_1_0/ROM_DW_1_0.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_1_0/ROM_DW_1_0_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_1_2/ROM_DW_1_2.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_1_2/ROM_DW_1_2_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_2_1/ROM_DW_2_1.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_2_1/ROM_DW_2_1_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_3_0/ROM_DW_3_0.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_3_0/ROM_DW_3_0_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_3_2/ROM_DW_3_2.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_3_2/ROM_DW_3_2_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_4_1/ROM_DW_4_1.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_4_1/ROM_DW_4_1_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_1_1/ROM_PW_1_1.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_1_1/ROM_PW_1_1_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_2_0/ROM_PW_2_0.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_2_0/ROM_PW_2_0_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_2_2/ROM_PW_2_2.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_2_2/ROM_PW_2_2_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_3_1/ROM_PW_3_1.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_3_1/ROM_PW_3_1_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_4_0/ROM_PW_4_0.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_4_0/ROM_PW_4_0_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_4_2/ROM_PW_4_2.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_4_2/ROM_PW_4_2_ooc.xdc]

read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_5_0/ROM_PW_5_0.xci
set_property used_in_implementation false [get_files -all f:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_5_0/ROM_PW_5_0_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top LittleNetAccAxi -part xczu3eg-sbva484-1-i -keep_equivalent_registers -resource_sharing off -control_set_opt_threshold 0


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef LittleNetAccAxi.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file LittleNetAccAxi_utilization_synth.rpt -pb LittleNetAccAxi_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
