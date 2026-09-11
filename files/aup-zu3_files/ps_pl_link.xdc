#=====================================================================
# ps_pl_link.xdc   Task 3, AUP-ZU3 (8 GB)
#
# Only two physical pins are constrained here. The AXI GPIO and the
# custom module are clocked by pl_clk0 from the processor, which is
# already a defined clock inside the block design, so there is no
# external clock pin and no create_clock line.
#
# Pins and I/O standard verified against the vendor master constraints
# file hw/constraints/mpsoc.xdc in
#   https://github.com/RealDigitalOrg/aup-zu3-bsp
# The white LEDs and slide switches are LVCMOS12 (not LVCMOS33; the
# reference manual's LVCMOS33 for user I/O is a documentation error).
#
# The port names pl_led and pl_sw must match the block-design port
# names created in the build script.
#=====================================================================

# PL white LED LD1, blinked by the PL when the PS sends enable = 1
set_property -dict { PACKAGE_PIN AE7 IOSTANDARD LVCMOS12 } [get_ports pl_led]

# PL slide switch SW0, read back to the PS over AXI GPIO channel 2
set_property -dict { PACKAGE_PIN AB1 IOSTANDARD LVCMOS12 } [get_ports pl_sw]

# The switch is asynchronous and goes straight into a synchronizer, so
# its input path does not need to be timed.
set_false_path -from [get_ports pl_sw]
