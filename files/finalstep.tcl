reset_run synth_1

launch_runs synth_1
wait_on_run synth_1
open_run synth_1

launch_runs impl_1
wait_on_run impl_1
open_run impl_1

 
create_clock -period 5.000 -name sysclk -waveform {0.000 2.500} [get_ports clk]
create_clock -period 5.000 -name sysclk -waveform {0.000 2.500} [get_ports ap_clk]
set_false_path -setup -hold -rise -fall -from reset 
set_false_path -setup -hold -rise -fall -from ap_rst_n
set_input_delay 0 -min -add_delay 0.000  -clock sysclk [all_inputs]
set_input_delay 0 -max -add_delay 0.000  -clock sysclk [all_inputs]
set_output_delay 0 -min -add_delay 0.000  -clock sysclk [all_outputs]
set_output_delay 0 -max -add_delay 0.000  -clock sysclk [all_outputs]

set_input_delay  -clock sysclk -min 0 [all_inputs]  
set_input_delay -clock sysclk -max 0 [all_inputs]  
set_output_delay -clock sysclk -min 0 [all_outputs]  
set_output_delay -clock sysclk -max 0 [all_outputs]  

cd [get_property DIRECTORY [current_project]]

set date_time_str [clock format [clock seconds] -format {%Y%b%d%I%M%S%p}]

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_timing_report.txt" ]
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 100 -input_pins -routable_nets -name timing_1 -file  $filename 
set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_timing_report_large.txt" ]
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10000 -input_pins -routable_nets -name timing_1 -file  $filename 
set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_utilization_report.txt" ]
report_utilization -hierarchical  -file $filename

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_congest.txt" ]
report_design_analysis -congestion -hierarchical_depth 10 -file $filename  
set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_high_fanout.txt" ]
report_high_fanout -max_net 1000 -timing -load_types -clock_regions -slr -histogram      -file $filename  
report_high_fanout -max_net 1000 -timing   -slr    -file $filename
 
phys_opt_design -force_replication_on_nets [get_nets reset]
set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.ARGS.DIRECTIVE AggressiveExplore [get_runs impl_1]
set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_drc.txt" ]
report_drc -name drc_1 -ruledecks {default opt_checks placer_checks router_checks bitstream_checks incr_eco_checks eco_checks abs_checks}  -file  $filename

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_power_report.txt" ]
report_power -file $filename 

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_method.txt" ] 
report_methodology -name ultrafast_methodology_1  -file $filename 

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_qor.txt" ] 
report_qor_suggestions -file  $filename 
 
