---
permalink: /vivado/
title: "Vivado"
author_profile: true
redirect_from:  
  - /vivado.html
---
Vivado is the software tools developed by [Xilinx](https://www.xilinx.com/products/silicon-devices/fpga.html) for designing and programming Xilinx [FPGAs](https://www.xilinx.com/products/silicon-devices/fpga/what-is-an-fpga.html) and SoCs, which are widely used in research. The workflow includes design, synthesis, implementation, and programming with simple clicks in project mode. 

#GUI/Project mode Vivado workflow

Typically we can use Xilinx for freely [downlable](https://www.xilinx.com/support/download.html) in Windows, and can let vivado sythesis in most of the FPGA boards available. The preferred edition is 2020.1 since it encompasses most of the widely used boards for implementation. 

I typically includes every related HDL code included in one project, and set the top file based on the implementation needs, to simplify workflow and excessive storage for project mode workflow. It will help you to track the hierarchy of the code, and avoid creating multiple project that occupies too many memories in the computer. 

## Possible new errors from simulation to sythesis:
* Difference in bitwidth for wires/registers.

## Possible new errors from sythesis to implementation:
* resource usage out of board limitation, implementation stopped. 
* unresolvable bit-width issue in some connections (mostly happened in memory). 
* There should be always some tcl output in tcl console. If the Vivado fall in the falling cases, the design might be too large for Vivado GUI/Project mode. 
	*If the design run clock is not moving.
	*CPU/memory usage for Vivado is low.
	*It is more than 3 hours in gui mode.
	
## Avoid IP core in Vivado
One of the issue with vivado is the IP core in prior/alter version will not be available. 

The most widely used one is BRAM/ROM, it is highly recommended to use [XPM](https://docs.xilinx.com/r/en-US/ug974-vivado-ultrascale-libraries/XPM_MEMORY_TDPRAM) rathrer than block memory IP core to design BRAM/ROM to avoid the issue of transferring the project between different board/vivado versions. 

## Family-wise/board wise difference
Though all FPGA boards available in Xilinx Vivado are called FPGA, there possiblly have signifcant differences between their performances based on the size of design. Typically [Artix-7 board AC701](https://www.xilinx.com/products/boards-and-kits/ek-a7-ac701-g.html) may have inferior performance to [Ultrascale family](https://www.xilinx.com/products/technology/ultrascale.html). Some boards with different layout could also contribute performance differences. 

## Use of TCL script:
Clicking the menus in GUI/Project mode could be devastating. Use of the TCL script can avoid the long waiting time after the design implementation is completed. 

Below is the TCL file we typically used. 

<pre>
cd [get_property DIRECTORY [current_project]]

set date_time_str [clock format [clock seconds] -format {%Y%b%d%I%M%S%p}]

create_clock -period 5.000 -name sysclk -waveform {0.000 2.500} [get_ports clk]
set_false_path -setup -hold -rise -fall -from reset 
set_false_path -setup -hold -rise -fall -from ap_rst_n
set_input_delay 0 -min -add_delay 0.000  -clock sysclk [all_inputs]
set_input_delay 0 -max -add_delay 0.000  -clock sysclk [all_inputs]
set_output_delay 0 -min -add_delay 0.000  -clock sysclk [all_outputs]
set_output_delay 0 -max -add_delay 0.000  -clock sysclk [all_outputs]

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
 
set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_drc.txt" ]
report_drc -name drc_1 -ruledecks {default opt_checks placer_checks router_checks bitstream_checks incr_eco_checks eco_checks abs_checks}  -file  $filename

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_power_report.txt" ]
report_power -file $filename 

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_method.txt" ] 
report_methodology -name ultrafast_methodology_1  -file $filename 

set filename [format "%s%s%s" $date_time_str   [get_property top [current_fileset]] "_qor.txt" ] 
report_qor_suggestions -file  $filename 
</pre>

Xilinx also provide [TCL reference]() for exploration
#Non-project mode Vivado workflow in Linux 
To update 
