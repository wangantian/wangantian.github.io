---
permalink: /aup-zu3/
title: "RealDigital AUP-ZU3 Development Board usage memo"
author_profile: true
redirect_from:  
  - /aup-zu3.html
---

<p>This page provides an evolving summary of resources and notes for using the AUP-ZU3 FPGA board. The AUP-ZU3 is a newer Zynq-based FPGA development board, available <a href="https://www.realdigital.org/hardware/aup-zu3">here</a>. It is currently available for purchase only by academic institutions. Consider purchasing the Accessory Kit, especially if you do not already have the required cables, SD card, and power adapter. Note that the kit comes with only two cables and one adapter. If you want to download the design to the board, you need a third cable to perform the download to the UART/PROG port</p>

<p>The official documentation is available <a href="https://xilinx.github.io/AUP-ZU3/">here</a>.</p>

Part of the document is adapted from the discussions <a href="https://uri-nextlab.github.io/ParallelProgrammingLabs/">here</a>. The Generative AI tools assist with part of the content.

# Blink the LEDs in HDL
In this part, you are expected to blink the LEDs using the switches and buttons on the board. The design itself is no different from the existing HDL design at this stage: write the HDL code, run synthesis and implementation, and see the design run. Here, a small working HDL design is provided below, along with the constraint file [here](https://wangantian.github.io/files/zu3_hdl.xdc), with some minor modifications from the official documents. 

# Blink the LEDs using Zynq 


# Let the Zynq (PS) and HDL (PL) talks