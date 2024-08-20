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
* Motherboard ASUS ProArt Z790, please note that the DP input is INPUT to the motherboard. Use Type-C or HDMI for the display purpose. Error x 2.
* DDR5 RAM ideally 96GB (2 x 48GB), we tried an 2 x 32GB +2 x 48GB version. 
* CPU cooler, idealy using water cooling solution, since wind cooler may limit avaliable RAM slots. Be mindful over Case, water cooling might not fit within the case comfortablly.
* High Power supply with Fan.
* Large Computer case with additional PWM Fans, we use Lian Li LancooL 216 Black Steel/Tempered Glass ATX Mid Tower Computer Case,2X 160 mm PWM Fans Included (Non-RGB)- LANCOOL 216X Black. 

The above settings were provided by Zhenyu Xu from Dr. Wei's [NEXT Lab research group](https://sites.google.com/g.clemson.edu/nextlabdoc/home) at Clemson University. 

# Operation system preparation
You are not expected to run it over Virtual Machine. Thus, you need to install Linux in your desktop. We use Ubuntu 22.04 LTS for convinence, which is avaliable in [https://ubuntu.com/download/desktop](https://ubuntu.com/download/desktop). Different from Virtual Machine, you need to use tool like Rufs which is avaliable here [https://rufus.ie/en](https://rufus.ie/en) to make your USB flash drive as a bootstrable drive. The following video below shows how you use it:

[![How to Download and Install Linux from USB Flash Drive Step-By-Step Guide.](https://img.youtube.com/vi/pwWfJwlZLWg/0.jpg)](https://youtu.be/pwWfJwlZLWg "How to Download and Install Linux from USB Flash Drive Step-By-Step Guide.")

WARNING, if you used provided motherboard, please check your BIOS version, IT HAVE TO BE 0816 [preferred] OR 0904 X86 to be fully support 22.04 installation. Otherwise, it will return out of memory.

Version 0904 has an issue with SSD port labeled as C is not usable with Intel i7 14700k CPU. Later BIOS versions may fix this issue. 0816 version has good support for Intel i7 13700k CPU.
You can install Ubuntu 24.04 with later BIOS (like 1801), but it cannot support Xilinx toolchain at this moment. 
The steps for the installation is avaliable [https://www.asus.com/support/faq/1012815/](https://www.asus.com/support/faq/1012815/).
You can download the driver from [https://www.asus.com/us/motherboards-components/motherboards/proart/proart-z790-creator-wifi/helpdesk_bios?model2Name=ProArt-Z790-CREATOR-WIFI](https://www.asus.com/us/motherboards-components/motherboards/proart/proart-z790-creator-wifi/helpdesk_bios?model2Name=ProArt-Z790-CREATOR-WIFI)

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

## Known issues 
If you stopped generating installed device, you need to install the following, and restart the installation after completion. 

```bash
sudo apt install libtinfo5 libncurses5
```


# XRT download and build

XRT is avaliable at [https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html) in xrt_<version>.deb or xrt_<version>.rpm file based on your operation system. While, it might fail. 

A better way is to build it from github, which can be followed using the build instruction is avaliable at [https://xilinx.github.io/XRT/master/html/build.html](https://xilinx.github.io/XRT/master/html/build.html) and  [https://docs.xilinx.com/r/en-US/ug1301-getting-started-guide-alveo-accelerator-cards/XRT-and-Deployment-Package-Installation-Procedures-on-Ubuntu](https://docs.xilinx.com/r/en-US/ug1301-getting-started-guide-alveo-accelerator-cards/XRT-and-Deployment-Package-Installation-Procedures-on-Ubuntu)

```bash
git clone https://github.com/Xilinx/XRT.git
sudo <XRT>/src/runtime_src/tools/scripts/xrtdeps.sh
cd <XRT>/build
source /tools/Xilinx/Vitis/2023.1/settings64.sh
./build.sh
cd /Release 
sudo apt install ./xrt*.deb
```

## Known issues 
If you encounter the error: 
cmake: error while loading shared libraries: libidn.so.11: cannot open shared object file: No such file or directory
From [https://askubuntu.com/questions/1477217/cant-install-libidn11-on-my-ubuntu-22-04](https://askubuntu.com/questions/1477217/cant-install-libidn11-on-my-ubuntu-22-04), you need to:

```
sudo apt update
wget http://mirrors.kernel.org/ubuntu/pool/main/libi/libidn/libidn11_1.33-2.2ubuntu2_amd64.deb
sudo apt install ./libidn11_1.33-2.2ubuntu2_amd64.deb
```

If you happen to have two cmake version within your XILINX library after load the Vitis.
With the issue as
cmake version issue:
CMake Error at CMakeLists.txt:4 (cmake_minimum_required):
  CMake 3.5.0 or higher is required.  You are running version 3.3.2
You can check by 

```bash
which cmake
```
which may possibly returns: /tools/Xilinx/Vitis/2023.1/tps/lnx64/cmake-3.3.2/bin/cmake

Go to the directory of "/tools/Xilinx/Vitis/2023.1/tps/lnx64", and see if there is a newer cmake there. If so, copy that directory, and the ENTIRE PATH environment variable by first copy the current PATH variable, and then :

```bash
export PATH=/tools/Xilinx/Vitis_HLS/2023.1/bin:/tools/Xilinx/Model_Composer/2023.1/bin:/tools/Xilinx/Vitis/2023.1/bin:/tools/Xilinx/Vitis/2023.1/gnu/microblaze/lin/bin:/tools/Xilinx/Vitis/2023.1/gnu/arm/lin/bin:/tools/Xilinx/Vitis/2023.1/gnu/microblaze/linux_toolchain/lin64_le/bin:/tools/Xilinx/Vitis/2023.1/gnu/aarch32/lin/gcc-arm-linux-gnueabi/bin:/tools/Xilinx/Vitis/2023.1/gnu/aarch32/lin/gcc-arm-none-eabi/bin:/tools/Xilinx/Vitis/2023.1/gnu/aarch64/lin/aarch64-linux/bin:/tools/Xilinx/Vitis/2023.1/gnu/aarch64/lin/aarch64-none/bin:/tools/Xilinx/Vitis/2023.1/gnu/armr5/lin/gcc-arm-none-eabi/bin:/tools/Xilinx/Vitis/2023.1/tps/lnx64/cmake-3.24.2/bin:/tools/Xilinx/Vitis/2023.1/aietools/bin:/tools/Xilinx/Vivado/2023.1/bin:/tools/Xilinx/DocNav:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin
```

If you face the error:

cmake: error while loading shared libraries: libssl.so.10: cannot open shared object file: No such file or directory

You need to follow the link [https://support.xilinx.com/s/question/0D54U00006RtdwzSAB/cmake-version-upgrade-can-not-find-library?language=en_US](https://support.xilinx.com/s/question/0D54U00006RtdwzSAB/cmake-version-upgrade-can-not-find-library?language=en_US) by entering:

```bash
export LD_LIBRARY_PATH=/<YOUR PATH>/Vitis/2022.2/tps/lnx64/cmake-3.21.4/libs/Ubuntu:$LD_LIBRARY_PATH
```

Other errors:
./build.sh: line 5: grep: command not found
./build.sh: line 5: awk: command not found
./build.sh: line 5: tr: command not found

```bash
sudo apt install grep
sudo apt-get install gawk
```

# Uninstall XRT
```bash
sudo apt remove xrt
```

# Platform data download
Similar but different from Vivado, you need to download the Alveo data accelearation card from [https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/alveo.html) by choosing the appropriate software and operating system.

Apart from download the .tar.gz files for your desired platform. We only do U200, U250, U280, and untar the tarball, install using the following command: 

```bash
source /tools/Xilinx/Vitis/2023.1/settings64.sh
sudo apt install ./*.deb
```

You also need to download the Development Target Platform. You need to download and install the desired platform one by one.

