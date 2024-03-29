# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Alexia/Vivado_projects/project_2_1/project_1.cache/wt [current_project]
set_property parent.project_path C:/Users/Alexia/Vivado_projects/project_2_1/project_1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property ip_output_repo c:/Users/Alexia/Vivado_projects/project_2_1/project_1.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/RegisterFile.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/UE.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/UC.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/MPG_debouncer.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/Memorie.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/Instr_Fetch.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/7segment.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/ID.vhd
  C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/sources_1/new/test_new.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/constrs_1/new/constr.xdc
set_property used_in_implementation false [get_files C:/Users/Alexia/Vivado_projects/project_2_1/project_1.srcs/constrs_1/new/constr.xdc]


synth_design -top test_new -part xc7a35tcpg236-1


write_checkpoint -force -noxdef test_new.dcp

catch { report_utilization -file test_new_utilization_synth.rpt -pb test_new_utilization_synth.pb }
