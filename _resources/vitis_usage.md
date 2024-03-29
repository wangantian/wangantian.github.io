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
Vitis provide tutorial in Xilinx github page [https://github.com/Xilinx/Vitis_Accel_Examples/tree/main](https://github.com/Xilinx/Vitis_Accel_Examples/tree/main). I personally prefer the github repository for 2023.1 toolchain given its broader scope in examples. 
There exist multiple versions for Vitis online. Please try to follow the latest one. 

If you prefer GUI interface, the tutorial [https://xilinx.github.io/xup_compute_acceleration/Vitis_intro-1.html](https://xilinx.github.io/xup_compute_acceleration/Vitis_intro-1.html) provides necessary setting steps.

# OpenCL and XRT (Xilinx RunTime) 
There exists multiple way to design the host side program, OpenCL and XRT Native API are the ones that close to hardware layer, and OpenCL version is built upon XRT Native API in short. It might be desirable

[OpenCL](https://en.wikipedia.org/wiki/OpenCL) stands for Open Computing Language, which can also used for General Purpose GPU program desgin. Its design idea can be generalized to different computing devices. However, it is not a good programming platform/language you can create without a template. It is a good idea to find the corresponding examples, and then modify them to fits our usage. Lots of online course resources provide OpenCL tutorials.
 

# AXI interface
The RTL IP core for vitis needs to follow AXI interfaces, there exist lots of variant of AXI protocol for RTL IP core. This youtube playlist [https://www.youtube.com/playlist?list=PLkqJVNOiuuHtNrVaNK4O1BSgczja4obeW](https://www.youtube.com/playlist?list=PLkqJVNOiuuHtNrVaNK4O1BSgczja4obeW) provides a good overview. Under the installation path of vivado: VIVADO_INSTAL_PATH/VERSION/data/xilinx_vip/hdl/ gives necessary HDL description of the protocol to deepen the understanding.  

# Basic Vitis running

The below tutorial is adapted from [https://github.com/OCT-FPGA/Vitis-Tutorials-U280/tree/2022.2/VitisAccelHelloWorld](https://github.com/OCT-FPGA/Vitis-Tutorials-U280/tree/2022.2/VitisAccelHelloWorld). 

## Lazy method for RTL kernel emulation
Copy the entire directory of Vitis_Accel_Examples, and only keep the common and rtl_kernel directory, so you do not need to change the directory within the makefiles. 

## Cleaning building results
There are lots of files generated during the building process, if you make any change, the safest way is to execute the following command to make sure your new build reflects the latest using the example makefiles.

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
You are not required to perform SW emulation if it is too hard to do it. The directory maybe different based on your or your system administor's installation, but the files should looks similar. 

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
 * Forget export XCL_EMULATION_MODE before emulation.
 
## Custom tutorial
The following tutorial was developed for helping Lao's group in developing Vitis and Vivado workflow. The tool we are using is Vitis 2023.1. Some featues may not be avaliable in earlier/later versions.
 * Tutorial 1 Simple custom RTL kernel using AXI-stream.
 * Tutorial 2


