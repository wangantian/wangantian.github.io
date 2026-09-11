#=====================================================================
# build_ps_pl.tcl   AUP-ZU3 (8 GB), Task 3 hardware.
#
# Builds, in one run:
#   Zynq UltraScale+ PS (correct 8 GB DDR via the board preset)
#   + AXI GPIO (dual channel: ch1 1-bit out, ch2 1-bit in)
#   + custom pl_signal module on the data path
# then runs synthesis, implementation, and bitstream, and exports an
# XSA WITH the bitstream included (Task 3 uses the PL, so a bitstream
# is required, unlike Task 2).
#
# The AXI plumbing is wired explicitly rather than through connection
# automation, so the result does not depend on the automation engine's
# guesses and is repeatable.
#
# HOW TO RUN
#   1. Put pl_signal.v, ps_pl_link.xdc, and this script in one folder.
#   2. Edit the two paths marked EDIT below.
#   3. From the Vivado Tcl Shell or the GUI Tcl console:
#          cd  <that folder>          ;# forward slashes on Windows
#          source build_ps_pl.tcl
#=====================================================================

# ---- paths: EDIT these two -----------------------------------------
set bsp_boardfiles "YOUR DIRECTORY/aup-zu3-bsp-master/board-files"   ;# path to aup-zu3-bsp/board-files
set xsa_out        "./ps_pl_8gb.xsa" ;# where to write the XSA

# ---- names (leave as is) -------------------------------------------
set src_v    "./pl_signal.v"
set src_xdc  "./ps_pl_link.xdc"
set proj     "ps_pl"
set proj_dir "./vivado_ps_pl"
set bd       "ps_pl_bd"
set part     "xczu3eg-sfvc784-2-e"
set board    "realdigital.org:aup-zu3-8gb:part0:1.0"
set jobs     8

# ---- board files + project -----------------------------------------
set_param board.repoPaths [list $bsp_boardfiles]
create_project $proj $proj_dir -part $part -force
set_property board_part $board [current_project]

# ---- sources (add before referencing the module in the BD) ---------
add_files -norecurse $src_v
add_files -fileset constrs_1 -norecurse $src_xdc
update_compile_order -fileset sources_1

# ---- block design + PS with correct 8 GB preset --------------------
create_bd_design $bd
create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:* zynq_ultra_ps_e_0
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
    -config {apply_board_preset "1"} [get_bd_cells zynq_ultra_ps_e_0]

# Task 3 needs the LPD AXI master and pl_clk0 ON (Task 2 turned them
# off). Keep GPIO bank 0 and UART1 for the PS button/LED and console.
set_property -dict [list \
    CONFIG.PSU__USE__M_AXI_GP2 {1} \
    CONFIG.PSU__FPGA_PL0_ENABLE {1} \
    CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
    CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 32 .. 33} \
    CONFIG.PSU__UART1__BAUD_RATE {115200} \
] [get_bd_cells zynq_ultra_ps_e_0]

# ---- AXI GPIO: dual channel, ch1 1-bit output, ch2 1-bit input -----
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:* axi_gpio_0
set_property -dict [list \
    CONFIG.C_IS_DUAL {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO2_WIDTH {1} \
    CONFIG.C_ALL_INPUTS_2 {1} \
] [get_bd_cells axi_gpio_0]

# ---- custom module on the data path --------------------------------
create_bd_cell -type module -reference pl_signal pl_signal_0

# ---- AXI plumbing, wired explicitly --------------------------------
create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:* smartconnect_0
set_property CONFIG.NUM_SI {1} [get_bd_cells smartconnect_0]
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:* proc_sys_reset_0

# One clock (pl_clk0) drives the master port, the interconnect, the AXI
# GPIO, the reset block, and the custom module.
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] \
    [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_lpd_aclk] \
    [get_bd_pins smartconnect_0/aclk] \
    [get_bd_pins axi_gpio_0/s_axi_aclk] \
    [get_bd_pins proc_sys_reset_0/slowest_sync_clk] \
    [get_bd_pins pl_signal_0/clk]

# Reset chain from the PS PL reset.
connect_bd_net [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0] \
    [get_bd_pins proc_sys_reset_0/ext_reset_in]
connect_bd_net [get_bd_pins proc_sys_reset_0/interconnect_aresetn] \
    [get_bd_pins smartconnect_0/aresetn]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
    [get_bd_pins axi_gpio_0/s_axi_aresetn]

# AXI data path: PS master -> smartconnect -> AXI GPIO.
connect_bd_intf_net [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_LPD] \
    [get_bd_intf_pins smartconnect_0/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/M00_AXI] \
    [get_bd_intf_pins axi_gpio_0/S_AXI]

# ---- GPIO bits <-> custom module -----------------------------------
# channel-1 output bit -> module enable_in ; module sw_out -> channel-2 input bit
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins pl_signal_0/enable_in]
connect_bd_net [get_bd_pins pl_signal_0/sw_out]   [get_bd_pins axi_gpio_0/gpio2_io_i]

# ---- external pins to the board ------------------------------------
create_bd_port -dir O pl_led
connect_bd_net [get_bd_ports pl_led] [get_bd_pins pl_signal_0/led_out]
create_bd_port -dir I pl_sw
connect_bd_net [get_bd_ports pl_sw]  [get_bd_pins pl_signal_0/sw_in]

# ---- address, validate, generate -----------------------------------
assign_bd_address
validate_bd_design
save_bd_design
generate_target all [get_files ${bd}.bd]

# ---- HDL wrapper ---------------------------------------------------
make_wrapper -files [get_files ${bd}.bd] -top
set wrp [glob -nocomplain \
    ${proj_dir}/${proj}.gen/sources_1/bd/${bd}/hdl/${bd}_wrapper.v \
    ${proj_dir}/${proj}.srcs/sources_1/bd/${bd}/hdl/${bd}_wrapper.v]
add_files -norecurse [lindex $wrp 0]
set_property top ${bd}_wrapper [current_fileset]
update_compile_order -fileset sources_1

# ---- synthesis, implementation, bitstream --------------------------
launch_runs synth_1 -jobs $jobs
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1

# ---- export the XSA WITH the bitstream -----------------------------
write_hw_platform -fixed -include_bit -force -file $xsa_out
puts "Wrote $xsa_out"
