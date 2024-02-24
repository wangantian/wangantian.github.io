---
permalink: /vitis_install/
title: "Vitis installation"
author_profile: true
redirect_from:  
  - /vitis_install.html
---
[Vitis](https://www.xilinx.com/products/design-tools/vitis.html) is the tool allow platform design for data acceleration card for Alevo series data center acceleration cards or embeded design for embedded Arm processors. 

Notice that, Vitis's linux edition only can do the design for data center acceleration card, while the windows edition only can do design for embeded system. The software requires high CPU and memory performance, thus it might not be ideal to do Vitis platform design on your own laptop.

Below show the step-by-step software installation on your local Linux Desktop. 

# Hardware preparation
Designing system scale hardware is costly but worthwhile. Below is one possible setting of installation:
* Intel i7 14700k CPU.
* SSD hard drive with at least 4TB, heatsink and latest PCIe. 
* DDR5 RAM ideally 96GB (2 x 48GB).
* CPU cooler, idealy using water cooling solution, since wind cooler may limit the space of avaliable RAM slots. 
* High Power supply with Fan.
* Large Computer case with additional PWM Fans, we use Lian Li LancooL 216 Black Steel/Tempered Glass ATX Mid Tower Computer Case,2X 160 mm PWM Fans Included (Non-RGB)- LANCOOL 216X Black. 

The above settings were provided by Zhenyu Xu from Dr. Wei's [NEXT Lab research group](https://sites.google.com/g.clemson.edu/nextlabdoc/home) at Clemson University. 

# Operation system preparation
You are not expected to run it over Virtual Machine. Thus, you need to install Linux in your desktop. We use Ubuntu 22.04 LTS for convinence, which is avaliable in [https://ubuntu.com/download/desktop](https://ubuntu.com/download/desktop). Different from Virtual Machine, you need to use tool like Rufs which is avaliable here [https://rufus.ie/en](https://rufus.ie/en) to make your USB flash drive as a bootstrable drive. The following video below shows how you use it:
(https://img.youtube.com/vi/pwWfJwlZLWg/0.jpg)](https://youtu.be/pwWfJwlZLWg "How to Download and Install Linux from USB Flash Drive Step-By-Step Guide.")

# Vitis unified design download and installation
The Vitis is can be download from [https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html)

Once downloaded, you need to get the sudo authority, and come to the download path.

Once in the download path, you need to make the .bin file executable and start the running by 

```bash
chmod +x <installer>.bin && sudo ./<installer>.bin
```
The above command is copied from [https://digilent.com/reference/programmable-logic/guides/installing-vivado-and-sdk](https://digilent.com/reference/programmable-logic/guides/installing-vivado-and-sdk)

# Platform data download
Similar but different from Vivado, you need to download the Alveo data accelear

# XRT download and build