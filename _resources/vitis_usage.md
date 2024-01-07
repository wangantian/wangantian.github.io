---
permalink: /vitis/
title: "Vitis"
author_profile: true
redirect_from:  
  - /vitis.html
---
[Vitis](https://www.xilinx.com/products/design-tools/vitis.html) is the tool allow platform design for data acceleration card for Alevo series data center acceleration cards or embeded design for embedded Arm processors. 

Notice that, Vitis's linux edition only can do the design for data center acceleration card, while the windows edition only can do design for embeded system. The software requires high CPU and memory performance, thus it might not be ideal to do Vitis platform design on your own laptop.

# Building machine 
There exists platform to avoid the trouble of installing and configuring the Vitis design. Below are the list we currently found.
* [Vitis 2023.1 Developer AMI](https://aws.amazon.com/marketplace/pp/prodview-hxbanceez6tso)

This AMI allows you to use latest configured Vitis tool to design for data center acceleration card. However the configured design is not usable for AWS F1 instance with [FPGA Developer AMI](https://aws.amazon.com/marketplace/pp/prodview-gimv3gqbpe57k), since [AWS's FPGA](https://github.com/aws/aws-fpga) runs on older version of the tool chain, and may not compatibable to the new features of the latest designs 
* [Xilinx University Program](https://www.xilinx.com/support/university/xup-hacc.html)

Xilinx provide the cluster for develop using Xilinx Alveo and Versal accelerator cards. You need to use your professional email address to access these resources. 

If you want to configure your local Linux Desktop by yourself. Below is the one we used for your reference :
To Update 

# Tutorial 
Vitis provide tutorial in Xilinx github page [here](https://github.com/Xilinx/Vitis_Accel_Examples/tree/main). There probably have multiple versions for this tool online. Please try to follow the latest one. 

If you prefer GUI interface, the tutorial [here](https://xilinx.github.io/xup_compute_acceleration/Vitis_intro-1.html) provides necessary setting steps.

# OpenCL and XRT (Xilinx runtime) 
There exists multiple way to design the host side program, OpenCL and XRT Native API are the ones that close to hardware layer, and OpenCL version is built upon XRT Native API in short. It might be desirable 

[OpenCL](https://en.wikipedia.org/wiki/OpenCL) stands for Open Computing Language, which can also used for General Purpose GPU program desgin. Its design idea can be generalized to different computing devices.



Some may be duplicate/out-of order. 
May send to my github link for better order. 
Though I gave an extensive introduction to the current workflow.
I believe it is still far from the actual practice.
In this email thread, I will go through the Tool involved:
Vitis, Vivado's latest version, currently is 2023.1 in Linux. We may consider to install it locally.
The purpose of using the Linux version is the Linux version of Vitis has more extensive functionality compared with the Windows one, refer to the link here for details. 
https://xilinx.github.io/Vitis-Tutorials/2021-2/build/html/docs/Getting_Started/Vitis/Part2.html
"Windows OS support is limited to the Vitis embedded software development flow. The Vitis application acceleration flow is only supported on Linux."

Current computing platform used:
Amazon AWS (not free, good for deployment if we only do outdated VU9P), recommend use inf2 for building to ensure good performance. 
Xilinx HEACC(secondary, https://www.amd-haccs.io/get-started.html) 
Local linux system CPU Intel® Core™ i7-13700 or better Memory  Corsair 48GB * 2  SSD 4T+ Operation system ubuntu 22.04
university cluster after software installation (I may discuss with Prof. Wei about how to install it and make it run)
NERC/OCT(tertiary, we still need to figure out some issues), included as part of the HEACC

Vivado:
1. Historically, we use the vivado for Verilog FPGA design. It is a free tool in Windows by just downloading it. We typically only use the board available in the free version and run synthesis. It is a good reference for RTL implementation in FPGA before deployment. However, if it goes to actual deployment, there will be lots of extra engineering currently we don't know how to do.
2. Basic usage
The current Vivado tools have all the workflow shown on the right. If you secure the implementation is all correct, you can directly click "run implementation" and wait for it to come to an end. 
Otherwise, you may need to go from elaborate[initial check of Verilog code connectivity & syntax] -> simulation[mostly functional] -> synthesis [resource initial estimate] ->implementation[resource final estimate]->bitstream generation [design ready to download to the board, rarely used].
A cool feature of Vivado is you can have every related RTL HDL code included in one project, and set the top file at your will. It will help you to track the hierarchy of the code, and avoid creating multiple project that consumes too much memory in the computer. 

The common issues apart from Verilog syntax errors between these steps are:
Simulation -> synthesis:
a. bit-width issue
synthesis->implementation:
a. resource usage out of board limitation, implementation stopped. 
b. unresolvable bit-width issue in some connections (mostly happened in memory). 
c.
There should always be some tcl output in the tcl console. If the design run clock is not moving or your CPU/memory usage for Vivado is low or it is more than 3 hours in gui mode, the design is too large for Vivado GUI mode. 
Also, as a general principle, double check the generated logs and see if the warnings are intended or unintended. Remove all unintended errors before running the final implementation results .
3. BRAM using XPM.
One of the drawbacks of Vivado is that its IP is version-based, if you switch the version, it is no longer usable. The main IP we are using is block memory,(used both as ROM or True Dual Port Ram).
Its IP documentation is here https://docs.xilinx.com/r/en-US/ug583-ultrascale-pcb-design/9.-Block-RAM
We here will use XPM for block memory generation to avoid the cross-version implementations. 
4. TCL script for generating the report
The script is attached before. The purpose of 
5. Constraint:
In most case, we only identify clock signals and set false paths for reset signal.
It can be set by following the tutorial here.
https://docs.xilinx.com/r/en-US/ug903-vivado-using-constraints/Timing-Constraints
You need to set it before running the implementation to allow good power estimation. If we don't set it beforehand, the power may stay 50W, but if we set it, it may be around. 5W[both numbers are approximate values, just to leave an impression].
If we happen to need to deploy it over the actual evaluation board, we need to set the pins for individual pins, which could be the case for the remaining job over PQC. 
You may find the tutorial here useful. https://xilinx.eetrend.com/blog/2020/100049740.html
6. Family-wise/board wise difference. 
Please note that the FPGA board differs. We moved to the Ultrascale family right now, but if you happen to be set to AC701 or another low-end board, you may find even though the resource consumption is similar, the timing/routing is significantly different. It is partially due to the internal structure and technology we used. 
7. Attribute:
It is not recommended to use attributes in Xilinx given its generalibility to cross-platform, ASIC design. It has limited help 
You may refer to the document here for this feature https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes
I only use "don't touch" for board-level functionality checks. I don't recommend read through it if you already can reach the timing requirements. 
8. non-GUI mode workflow in Linux [To update]
9. non-project mode workflow in Linux [To update]


OpenCL:
1. OpenCL is the tool to connect, you may see it from both FPGA or GPU programming. However, it is not a good programming platform/language you can create without a template. It is a good idea to find the corresponding examples, and then modify them to fits our usage.
2. I don't recommend reading any OpenCL books for programming reference given their complexity. Any course talking about parallel computing/computer architecture should be good as a primer. Below are the two I found just right. Most of the learning will still based on Xilinx's examples
https://engineering.purdue.edu/~smidkiff/ece563/NVidiaGPUTeachingToolkit/Mod20OpenCL/3rd-Edition-AppendixA-intro-to-OpenCL.pdf
https://web.engr.oregonstate.edu/~mjb/cs575/Handouts/opencl.1pp.pdf
[Please switch to other handouts of this oregan state course related to opencl]
3. The OpenCL feature used in this project [TBD]
Flexible multi-core instantiation. 
Event-based dependency to allow out-of-order execution, multi-queue task enqueue process. 
HBM data transfer.
4. AXI-lite and AXI-stream 
The IP core source code is located under the installation path: Vivado/2021.2/data/xilinx_vip/hdl/ 
I don't recommend read through it if you already can configure it properly. 
5. Custom simulation in Vivado.
7. RTL-kernel surrogate model.
8. RTL kernel limitation
9. OPENCL+RTL
10. non-gui mode Vitis commands:
Refer to NERC's vitis started https://github.com/OCT-FPGA/Vitis-Tutorials-U280/tree/2022.2/VitisAccelHelloWorld, and double check the directory & device used. 
11. Host /OpenCL implementation:
From the host's perspective, what we want is to achieve the highest possible parallelism without extra effort in modifying RTL code as long as we configure the data flow in a good manner.The possible implementation can refer to the implementation here. 
https://github.com/Xilinx/Vitis_Accel_Examples/tree/main/host/mult_compute_units
Apart from that, we want to make it different from SW programming, that done sequentially. We want to make different kernels work concurrently in different schedule.
The possible implementation can refer to the implementation here. 
https://github.com/Xilinx/Vitis_Accel_Examples/tree/main/host/concurrent_kernel_execution


Best regards,
Antian(Andy)


On Fri, Oct 20, 2023 at 8:49 AM Antian Wang <antianw@g.clemson.edu> wrote:
Though I gave an extensive introduction to the current workflow.
I believe it is still far from the actual practice.
In this email thread, I will go through the Tool involved:
Vitis, Vivado's latest version, currently is 2023.1 in Linux. You don't need to install it locally. 
The purpose of using the Linux version is the Linux version of Vitis has more extensive functionality compared with the Windows one, refer to the link here for details. 

Current computing platform used:
Amazon AWS (not free, good for deployment), NERC/OCT(secondary, we still need to figure out some issues), university cluster after software installation (I may discuss with Prof. Wei about how to install it and make it run)

Vivado: