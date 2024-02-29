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
* CPU cooler, idealy using water cooling solution, since wind cooler may limit avaliable RAM slots. 
* High Power supply with Fan.
* Large Computer case with additional PWM Fans, we use Lian Li LancooL 216 Black Steel/Tempered Glass ATX Mid Tower Computer Case,2X 160 mm PWM Fans Included (Non-RGB)- LANCOOL 216X Black. 

The above settings were provided by Zhenyu Xu from Dr. Wei's [NEXT Lab research group](https://sites.google.com/g.clemson.edu/nextlabdoc/home) at Clemson University. 

# Operation system preparation
You are not expected to run it over Virtual Machine. Thus, you need to install Linux in your desktop. We use Ubuntu 22.04 LTS for convinence, which is avaliable in [https://ubuntu.com/download/desktop](https://ubuntu.com/download/desktop). Different from Virtual Machine, you need to use tool like Rufs which is avaliable here [https://rufus.ie/en](https://rufus.ie/en) to make your USB flash drive as a bootstrable drive. The following video below shows how you use it:

[![How to Download and Install Linux from USB Flash Drive Step-By-Step Guide.](https://img.youtube.com/vi/pwWfJwlZLWg/0.jpg)](https://youtu.be/pwWfJwlZLWg "How to Download and Install Linux from USB Flash Drive Step-By-Step Guide.")


# Vitis unified design download and installation
The Vitis is can be download from [https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vitis.html)

Once you signin, we have two option, Single File Download (SFD) or using web installer.


## Single File Download (SFD) [Recommend]

The download speed will probably faster than using web installer. Extract the files from the Xilinx_<version>.tar.gz archive:
```bash
tar -xvf Xilinx_<version>.tar.gz
```
 
Run the installer:
 
```bash
sudo ./xsetup
```

## Use web installer
Download the .bin file, you need to change your directory to your download path, you need to make the .bin file executable and start the running by 

```bash
chmod +x <installer>.bin && sudo ./<installer>.bin
```

## Known issue 
If you stopped generating installed device, you need to install the following, and restart the installation after completion. 

```bash
sudo apt install libtinfo5 libncurses5
```

# Platform data download
Similar but different from Vivado, you need to download the Alveo data accelearation card from [https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html) by choosing the appropriate software and operating system.

Apart from download the .tar.gz files for your desired platform. We only do U200, U250, U280, and untar the tarball, install using the following command: 

```bash
sudo apt install ./*.deb
```

You also need to download the Development Target Platform, this part seems to have to be installed one platform by another rather than install every platform at once. 

# XRT download and build

XRT is avaliable at [https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html) in xrt_<version>.deb or xrt_<version>.rpm file based on your operation system. While, it might fail. A better way is to build it from github, which can be followed using the build instruction is avaliable [https://xilinx.github.io/XRT/master/html/build.html](https://xilinx.github.io/XRT/master/html/build.html) and [https://docs.xilinx.com/r/en-US/ug1301-getting-started-guide-alveo-accelerator-cards/XRT-and-Deployment-Package-Installation-Procedures-on-Ubuntu](https://docs.xilinx.com/r/en-US/ug1301-getting-started-guide-alveo-accelerator-cards/XRT-and-Deployment-Package-Installation-Procedures-on-Ubuntu)

```bash
git clone https://github.com/Xilinx/XRT.git
sudo <XRT>/src/runtime_src/tools/scripts/xrtdeps.sh
cd <XRT>/build
./build.sh
sudo apt install ./xrt*.deb
```

If you happen to have two cmake version within your XILINX library after load the Vitis, you may change it similar as follows:
```bash
export PATH=/tools/Xilinx/Vitis/2023.1/tps/lnx64/cmake-3.XXX:$PATH
```

It is inspired from [https://support.xilinx.com/s/question/0D54U00006RtdwzSAB/cmake-version-upgrade-can-not-find-library?language=en_US](https://support.xilinx.com/s/question/0D54U00006RtdwzSAB/cmake-version-upgrade-can-not-find-library?language=en_US) used for other installation step.

```bash
export LD_LIBRARY_PATH=/<YOUR PATH>/Vitis/2022.2/tps/lnx64/cmake-3.21.4/libs/Ubuntu:$LD_LIBRARY_PATH
```

# Uninstall XRT
```bash
sudo apt remove xrt
```
