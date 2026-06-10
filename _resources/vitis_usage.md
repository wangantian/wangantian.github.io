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

This AMI allows you to use latest configured Vitis tool to design for data center acceleration card. However the configured design is not usable for AWS F1 instance with [FPGA Developer AMI](https://aws.amazon.com/marketplace/pp/prodview-gimv3gqbpe57k), since [AWS's FPGA](https://github.com/aws/aws-fpga) runs on older version of the tool chain, and may not compatibable to the new features of the latest designs. Also, you need to aware the AMI may fail for GUI debug mode for RTL kernels.


* [Xilinx University Program](https://www.xilinx.com/support/university/xup-hacc.html)

Xilinx provide the cluster for develop using Xilinx Alveo and Versal accelerator cards. You need to use your professional email address to access these resources. 

The purpose of using the Linux version is the Linux version of Vitis has more extensive functionality compared with the Windows one, refer to the link here for details. 
[https://xilinx.github.io/Vitis-Tutorials/2021-2/build/html/docs/Getting_Started/Vitis/Part2.html](https://xilinx.github.io/Vitis-Tutorials/2021-2/build/html/docs/Getting_Started/Vitis/Part2.html)
"Windows OS support is limited to the Vitis embedded software development flow. The Vitis application acceleration flow is only supported on Linux."


* Local build machine 
It can save some tons of time in configuring the installation due to the limiation of 
If you want to configure your local Linux Desktop by yourself. Below is the one we used for your reference :
 * Latest possible CPU cores.
 * Large DDR memory with possible 64GB+.
 * Large SSD to accomodate the installation and large generated project files.
 * Try to avoid dual operating system.

In this [link](https://wangantian.github.io//vitis_install/), a detialed step-by-step installation tutorial is provided.

# Tutorial 
Vitis provides tutorials on the Xilinx GitHub page [https://github.com/Xilinx/Vitis_Accel_Examples/tree/main](https://github.com/Xilinx/Vitis_Accel_Examples/tree/main). I personally prefer the GitHub repository for the 2023.1 toolchain, given its broader scope in examples. 
There are multiple versions of Vitis available online. Please try to follow the latest one. 

If you prefer a GUI interface, the tutorial [https://xilinx.github.io/xup_compute_acceleration/Vitis_intro-1.html](https://xilinx.github.io/xup_compute_acceleration/Vitis_intro-1.html) provides necessary setting steps.

# OpenCL and XRT (Xilinx RunTime) 
There are multiple ways to design the host-side program; OpenCL and XRT (Xilinx RunTime) Native API are the ones closest to the hardware layer, and the OpenCL version is built upon the XRT Native API, in short. It might be desirable.

[OpenCL](https://en.wikipedia.org/wiki/OpenCL) stands for Open Computing Language, which can also be used for general-purpose GPU program design. Its design idea can be generalized to different computing devices. However, it is not a good programming platform or language to create without a template. It is a good idea to find the corresponding examples and then modify them to fit our usage. Many online course resources offer OpenCL tutorials.
 

# AXI interface
The RTL IP core for Vitis needs to follow the AXI protocol; there are many variants of the AXI protocol for RTL IP cores. This YouTube playlist [https://www.youtube.com/playlist?list=PLkqJVNOiuuHtNrVaNK4O1BSgczja4obeW](https://www.youtube.com/playlist?list=PLkqJVNOiuuHtNrVaNK4O1BSgczja4obeW) provides a good overview. Under the Vivado installation path, VIVADO_INSTAL_PATH/VERSION/data/xilinx_vip/hdl/, the necessary HDL description of the protocol can be found to deepen understanding.  

# Basic Vitis running

The tutorial below is adapted from [https://github.com/OCT-FPGA/Vitis-Tutorials-U280/tree/2022.2/VitisAccelHelloWorld](https://github.com/OCT-FPGA/Vitis-Tutorials-U280/tree/2022.2/VitisAccelHelloWorld). 

## Lazy method for RTL kernel emulation
Copy the entire Vitis_Accel_Examples directory, and keep only the common and rtl_kernel directories, so you do not need to change the directory in the makefiles. 

## Cleaning building results
There are many files generated during the build process. If you make any change, the safest way is to run the following command to ensure your new build reflects the latest using the example makefiles.

```bash
make cleanall
```

## Source the tools 

Make sure that ```XILINX_VITIS``` and ```XILINX_XRT``` environment variables are set. This can be done by

```bash
source /tools/Xilinx/Vitis/2022.2/settings64.sh
source /opt/xilinx/xrt/setup.sh
```
Then go to the corresponding directory by:
```bash
cd Vitis_Accel_Examples/hello_world
```

## Emulation 
You are not required to perform SW emulation if it is too difficult. The directory may be different based on your or your system administrator's installation, but the files should look similar. 

### SW emulation

```bash
make all TARGET=sw_emu PLATFORM=/opt/xilinx/platforms/xilinx_u280_gen3x16_xdma_1_202211_1/xilinx_u280_gen3x16_xdma_1_202211_1.xpfm
```
### SW emulation run 
```bash
export XCL_EMULATION_MODE=sw_emu
./hello_world ./build_dir.sw_emu.xilinx_u280_gen3x16_xdma_1_202211_1/vadd.xclbin
```

### HW emulation

```bash
make all TARGET=hw_emu PLATFORM=/opt/xilinx/platforms/xilinx_u280_gen3x16_xdma_1_202211_1/xilinx_u280_gen3x16_xdma_1_202211_1.xpfm
```
### HW emulation run 
```bash
export XCL_EMULATION_MODE=hw_emu
./hello_world ./build_dir.hw_emu.xilinx_u280_gen3x16_xdma_1_202211_1/vadd.xclbin
```

### HW build

```bash
make all TARGET=hw PLATFORM=/opt/xilinx/platforms/xilinx_u280_gen3x16_xdma_1_202211_1/xilinx_u280_gen3x16_xdma_1_202211_1.xpfm
```

### HW build run 

To update 

## Typical error:
 * Fail to check the file name, kernel name, or add necessary files.
 * Forget export XCL_EMULATION_MODE before emulation. We typically include it in the command when we load the tool.
 * Below is the typical issue that happens when we do the emulation. If it happens, delete any generated files and rebuild. It should work.
  * ERROR: [VPL 10-3180] cannot find port 'BLP_M_AXI_DATA_C2H_00_awsize' on this module [/SOME_DIRECTORY/vivado/vpl/prj/prj.ip_user_files/bd/pfm_top/sim/pfm_top.v:754]
  * ERROR: [VPL 10-3180] cannot find port 'BLP_M_AXI_DATA_C2H_00_arsize' on this module [/SOME_DIRECTORY/vivado/vpl/prj/prj.ip_user_files/bd/pfm_top/sim/pfm_top.v:743]
  * ERROR: [VPL 43-3322] Static elaboration of top level Verilog design unit(s) in library work failed
  * ERROR: [VPL 60-773] In '[/SOME_DIRECTORY/vivado/vpl/vivado.log', caught Tcl error: 
  * ERROR: [VPL 60-704] Integration error, Step failed: config_hw_emu.elaborate. An error stack with function names and arguments may be available in the 'vivado.log'.

 
## Custom tutorial
The following tutorial was developed to help Lao's group develop a Vitis and Vivado workflow. The tool we are using is Vitis 2023.1. Some features may not be available in earlier/later versions.
 * Tutorial 1 Simple custom RTL kernel using AXI-stream.
 * Tutorial 2


