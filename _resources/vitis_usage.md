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