---
permalink: /vivado/
title: "Vivado"
author_profile: true
redirect_from:  
  - /vivado.html
---
Vivado is the software tool developed by [Xilinx](https://www.xilinx.com/products/silicon-devices/fpga.html) for designing and programming Xilinx [FPGAs](https://www.xilinx.com/products/silicon-devices/fpga/what-is-an-fpga.html) and SoCs, which are widely used in research. The workflow includes design, synthesis, implementation, and programming with a single click in project mode.  

# GUI/Project mode Vivado workflow

Typically, we can use Xilinx for free [downloadable](https://www.xilinx.com/support/download.html) on Windows and can use Vivado synthesis on most FPGA boards available. The preferred edition is 2020.1, as it supports most widely used boards for implementation. 

I typically include all related HDL code in a single project and set the top file based on the implementation needs to simplify the workflow and avoid excessive storage in project mode. It will help you track the code hierarchy and avoid creating multiple projects that occupy too much memory on the computer. 

## Possible new errors from simulation to synthesis:
* Difference in bitwidth for wires/registers.

## Possible new errors from synthesis to implementation:
* Resource usage out of board limitation, implementation stopped. 
* Unresolvable bit-width issue in some connections (mostly happened in memory). 
* There should always be some TCL output in the TCL console. If Vivado falls into the falling cases, the design might be too large for Vivado GUI/Project mode. 
	*If the design run clock is not moving.
	*CPU/memory usage for Vivado is low.
	*It is more than 3 hours in GUI mode.
	
## Avoid IP core in Vivado
One issue with Vivado is that IP cores from prior/alter versions will not be available. 

The most widely used one is BRAM/ROM. It is highly recommended to use [XPM](https://docs.xilinx.com/r/en-US/ug974-vivado-ultrascale-libraries/XPM_MEMORY_TDPRAM) rather than a block memory IP core to design BRAM/ROM to avoid issues with transferring the project between different boards and Vivado versions. At the same time, it is still good to browse through the BRAM document available at [https://docs.xilinx.com/r/en-US/ug583-ultrascale-pcb-design/9.-Block-RAM](https://docs.xilinx.com/r/en-US/ug583-ultrascale-pcb-design/9.-Block-RAM).

Suppose you find that the various types of xpram went missing when you try to do simulation/synthesis. Try loading the XPM IP directly from your installation path: $XILINX_VIVADO/data/ip/xpm.

## Use of constraint
Clock signals and set false paths for the reset signal are the major constraints we used for FPGA implementation.
It can be set by following the tutorial here [https://docs.xilinx.com/r/en-US/ug903-vivado-using-constraints/Timing-Constraints](https://docs.xilinx.com/r/en-US/ug903-vivado-using-constraints/Timing-Constraints)
You need to set it before running the implementation to allow good power estimation. If we don't set it beforehand, the power may stay at 50W, but if we do, it may be around 5W.

Another set of constraints lies in the pin assignment, which can be handled by modifying the example pin layout file for the individual project. The tutorial in [https://docs.xilinx.com/r/en-US/ug903-vivado-using-constraints/Pin-Assignment](https://docs.xilinx.com/r/en-US/ug903-vivado-using-constraints/Pin-Assignment) is a good starting point. 

## Family-wise/board wise difference
Although all FPGA boards in Xilinx Vivado are called FPGA, they may differ significantly in performance depending on the size of the design. Typically, the [Artix-7 board AC701](https://www.xilinx.com/products/boards-and-kits/ek-a7-ac701-g.html) may have inferior performance compared to the [Ultrascale family](https://www.xilinx.com/products/technology/ultrascale.html). Some boards with different layouts could also contribute to performance differences. 

## Attribute 
It is not recommended to use attributes in Xilinx, given their limited generalizability to cross-platform ASIC design. It has limited help. You may refer to the document here for this feature [https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes](https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes)
I only use "don't touch" for board-level functionality checks. I don't recommend reading through it if you already can reach the timing requirements. 

## Use of TCL script:
Clicking the menus in GUI/Project mode could be devastating. Using the TCL script can avoid the long wait time after design implementation is complete. 

[Here](https://wangantian.github.io/files/finalstep.tcl) is the example TCL file we typically use. Xilinx also provides [TCL reference]() for exploration

# Non-project mode Vivado workflow in Linux 
```bash
vivado -mode batch -source ./flow.tcl
```

