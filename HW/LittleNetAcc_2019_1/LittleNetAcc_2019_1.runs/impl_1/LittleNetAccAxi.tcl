# 
# Report generation script generated by Vivado
# 

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
proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL-1065} -limit 10000
set_msg_config  -id {IP_Flow 19-3153}  -string {{WARNING: [IP_Flow 19-3153] Bus Interface 'm_axis_clk': ASSOCIATED_BUSIF bus parameter is missing.}}  -suppress 

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param chipscope.maxJobs 2
  create_project -in_memory -part xczu3eg-sbva484-1-i
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.cache/wt [current_project]
  set_property parent.project_path F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.xpr [current_project]
  set_property ip_repo_paths F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs [current_project]
  update_ip_catalog
  set_property ip_output_repo F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_MEMORY [current_project]
  add_files -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.runs/synth_1/LittleNetAccAxi.dcp
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_C/DSP_A_mul_B_add_C.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_add_C/DSP_A_add_C.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_ACC/DSP_A_mul_B_ACC.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_STREAMER/DSP_STREAMER.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_C_PCOUT/DSP_A_mul_B_add_C_PCOUT.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_PCIN/DSP_A_mul_B_add_PCIN.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_add_PCIN_PCOUT/DSP_A_mul_B_add_PCIN_PCOUT.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/DSP_A_mul_B_PCOUT/DSP_A_mul_B_PCOUT.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_5824e_13a_B8_15a/RAM_A32_5824e_13a_B8_15a.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_2912e_12a_B8_14a/RAM_A32_2912e_12a_B8_14a.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_10400e_14a_B8_16a/RAM_A32_10400e_14a_B8_16a.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_20000e_15a_B8_17a/RAM_A32_20000e_15a_B8_17a.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_10000e_14a_B8_16a/RAM_A32_10000e_14a_B8_16a.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_75000e_17a_B8_19a/RAM_A32_75000e_17a_B8_19a.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/RAM_A32_15000e_14a_B8_16a/RAM_A32_15000e_14a_B8_16a.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_1_0/ROM_DW_1_0.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_1_2/ROM_DW_1_2.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_2_1/ROM_DW_2_1.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_3_0/ROM_DW_3_0.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_3_2/ROM_DW_3_2.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_DW_4_1/ROM_DW_4_1.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_1_1/ROM_PW_1_1.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_2_0/ROM_PW_2_0.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_2_2/ROM_PW_2_2.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_3_1/ROM_PW_3_1.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_4_0/ROM_PW_4_0.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_4_2/ROM_PW_4_2.xci
  read_ip -quiet F:/LittleNet_ACC_verilog/LittleNetAcc_2019_1/LittleNetAcc_2019_1.srcs/sources_1/ip/ROM_PW_5_0/ROM_PW_5_0.xci
  link_design -top LittleNetAccAxi -part xczu3eg-sbva484-1-i
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force LittleNetAccAxi_opt.dcp
  create_report "impl_1_opt_report_drc_0" "report_drc -file LittleNetAccAxi_drc_opted.rpt -pb LittleNetAccAxi_drc_opted.pb -rpx LittleNetAccAxi_drc_opted.rpx"
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step power_opt_design
set ACTIVE_STEP power_opt_design
set rc [catch {
  create_msg_db power_opt_design.pb
  power_opt_design 
  write_checkpoint -force LittleNetAccAxi_pwropt.dcp
  close_msg_db -file power_opt_design.pb
} RESULT]
if {$rc} {
  step_failed power_opt_design
  return -code error $RESULT
} else {
  end_step power_opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  if { [llength [get_debug_cores -quiet] ] > 0 }  { 
    implement_debug_core 
  } 
  place_design 
  write_checkpoint -force LittleNetAccAxi_placed.dcp
  create_report "impl_1_place_report_io_0" "report_io -file LittleNetAccAxi_io_placed.rpt"
  create_report "impl_1_place_report_utilization_0" "report_utilization -file LittleNetAccAxi_utilization_placed.rpt -pb LittleNetAccAxi_utilization_placed.pb"
  create_report "impl_1_place_report_control_sets_0" "report_control_sets -verbose -file LittleNetAccAxi_control_sets_placed.rpt"
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step post_place_power_opt_design
set ACTIVE_STEP post_place_power_opt_design
set rc [catch {
  create_msg_db post_place_power_opt_design.pb
  power_opt_design 
  write_checkpoint -force LittleNetAccAxi_postplace_pwropt.dcp
  close_msg_db -file post_place_power_opt_design.pb
} RESULT]
if {$rc} {
  step_failed post_place_power_opt_design
  return -code error $RESULT
} else {
  end_step post_place_power_opt_design
  unset ACTIVE_STEP 
}

start_step phys_opt_design
set ACTIVE_STEP phys_opt_design
set rc [catch {
  create_msg_db phys_opt_design.pb
  phys_opt_design 
  write_checkpoint -force LittleNetAccAxi_physopt.dcp
  close_msg_db -file phys_opt_design.pb
} RESULT]
if {$rc} {
  step_failed phys_opt_design
  return -code error $RESULT
} else {
  end_step phys_opt_design
  unset ACTIVE_STEP 
}

  set_msg_config -source 4 -id {Route 35-39} -severity "critical warning" -new_severity warning
start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force LittleNetAccAxi_routed.dcp
  create_report "impl_1_route_report_drc_0" "report_drc -file LittleNetAccAxi_drc_routed.rpt -pb LittleNetAccAxi_drc_routed.pb -rpx LittleNetAccAxi_drc_routed.rpx"
  create_report "impl_1_route_report_methodology_0" "report_methodology -file LittleNetAccAxi_methodology_drc_routed.rpt -pb LittleNetAccAxi_methodology_drc_routed.pb -rpx LittleNetAccAxi_methodology_drc_routed.rpx"
  create_report "impl_1_route_report_power_0" "report_power -file LittleNetAccAxi_power_routed.rpt -pb LittleNetAccAxi_power_summary_routed.pb -rpx LittleNetAccAxi_power_routed.rpx"
  create_report "impl_1_route_report_route_status_0" "report_route_status -file LittleNetAccAxi_route_status.rpt -pb LittleNetAccAxi_route_status.pb"
  create_report "impl_1_route_report_timing_summary_0" "report_timing_summary -max_paths 10 -file LittleNetAccAxi_timing_summary_routed.rpt -pb LittleNetAccAxi_timing_summary_routed.pb -rpx LittleNetAccAxi_timing_summary_routed.rpx"
  create_report "impl_1_route_report_incremental_reuse_0" "report_incremental_reuse -file LittleNetAccAxi_incremental_reuse_routed.rpt"
  create_report "impl_1_route_report_clock_utilization_0" "report_clock_utilization -file LittleNetAccAxi_clock_utilization_routed.rpt"
  create_report "impl_1_route_report_bus_skew_0" "report_bus_skew -warn_on_violation -file LittleNetAccAxi_bus_skew_routed.rpt -pb LittleNetAccAxi_bus_skew_routed.pb -rpx LittleNetAccAxi_bus_skew_routed.rpx"
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force LittleNetAccAxi_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step post_route_phys_opt_design
set ACTIVE_STEP post_route_phys_opt_design
set rc [catch {
  set tool_flow [get_property -quiet TOOL_FLOW [current_project -quiet]]
  if {$tool_flow eq {SDx}} {send_msg_id {101-1} {status} {Starting optional post-route physical design optimization.} }
  create_msg_db post_route_phys_opt_design.pb
  phys_opt_design 
  write_checkpoint -force LittleNetAccAxi_postroute_physopt.dcp
  create_report "impl_1_post_route_phys_opt_report_timing_summary_0" "report_timing_summary -max_paths 10 -warn_on_violation -file LittleNetAccAxi_timing_summary_postroute_physopted.rpt -pb LittleNetAccAxi_timing_summary_postroute_physopted.pb -rpx LittleNetAccAxi_timing_summary_postroute_physopted.rpx"
  create_report "impl_1_post_route_phys_opt_report_bus_skew_0" "report_bus_skew -warn_on_violation -file LittleNetAccAxi_bus_skew_postroute_physopted.rpt -pb LittleNetAccAxi_bus_skew_postroute_physopted.pb -rpx LittleNetAccAxi_bus_skew_postroute_physopted.rpx"
  close_msg_db -file post_route_phys_opt_design.pb
  set tool_flow [get_property TOOL_FLOW [current_project]]
  if {$tool_flow eq {SDx}} {send_msg_id {101-1} {status} {Finished optional post-route physical design optimization.} }
} RESULT]
if {$rc} {
  step_failed post_route_phys_opt_design
  return -code error $RESULT
} else {
  end_step post_route_phys_opt_design
  unset ACTIVE_STEP 
}

