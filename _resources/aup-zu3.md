---
permalink: /aup-zu3/
title: "RealDigital AUP-ZU3 Development Board usage memo"
author_profile: true
redirect_from:  
  - /aup-zu3.html
---

<p>This page provides an evolving summary of resources and notes for using the AUP-ZU3 FPGA board. The AUP-ZU3 is a newer Zynq-based FPGA development board, available <a href="https://www.realdigital.org/hardware/aup-zu3">here</a>. It is currently available for purchase only by academic institutions. Consider purchasing the Accessory Kit, especially if you do not already have the required cables, SD card, and power adapter. The kit includes only two cables and one adapter. If you want to download the design to the board, you need a third cable to perform the download to the UART/PROG port</p>

<p>The official documentation is available <a href="https://xilinx.github.io/AUP-ZU3/">here</a>.</p>

Part of the document is adapted from the discussions <a href="https://uri-nextlab.github.io/ParallelProgrammingLabs/">here</a>. The Generative AI tools assist with part of the content.

# Blink the LEDs in HDL
In this part, you are expected to blink the LEDs using the board's switches and buttons. The design is the same as the existing HDL design at this stage: write the HDL design, run synthesis and implementation, and see the design run. Below is a small working HDL design, along with the constraint file [here](https://wangantian.github.io/files/zu3.xdc), with minor modifications from the official documents. 

# Blink the LEDs using Zynq 

In this exercise, you will complete a Verilog module for the RealDigital AUP-ZU3 board (Zynq UltraScale+ XCZU3EG). The board provides slide switches, push buttons, white LEDs, RGB LEDs, and servo headers on the programmable logic (PL) side, all clocked by a 100 MHz differential clock.

By the end of this exercise, your design should do three things at once:

1. Blink the white LEDs at 1 Hz, but only for the switches that are turned on.
2. Use three push buttons as a 3-bit binary value that lights up the RGB LEDs, with the fourth push button flipping two of the four RGB LEDs to the opposite color.
3. Use two of the slide switches to command a servo motor: neutral, turn left, turn right, or hold the last position.

## Board facts you will need

- The board clock is 100 MHz, delivered as a differential pair (`PL_CLK_100_P` / `PL_CLK_100_N`). You will need an `IBUFDS` primitive to turn this into a single clean clock signal before using it anywhere else.
- Switches, buttons, and LEDs are all active high.
- Push buttons and switches are mechanical and asynchronous to your clock, so raw button/switch values should never be used directly in clocked logic. Pass them through a synchronizer first.
- The RGB LED outputs and the servo outputs are both 3-pin and 4-pin buses, respectively, matching one LED or one servo motor per index.
- A servo expects a repeating pulse roughly every 20 ms, where the *width* of the high pulse (not its presence or absence) tells the servo where to go. This is standard across hobby servos.
- The servo signal pin is separate from the servo's motor power pin. Even a perfectly correct signal will not move a servo if its power jumper isn't set. Check your board's servo header jumper (labeled `SPWR SEL`) before assuming your design is broken.

## Your task

Fill in the `TODO` sections in the skeleton below. Do not change the port list; the ports already match the AUP-ZU3 constraints file.

```verilog
`timescale 1ns / 1ps

module switch_blink (
    input  wire PL_CLK_100_P,
    input  wire PL_CLK_100_N,
    input  wire [7:0] PL_USER_SW,
    output wire [7:0] PL_USER_LED,
    output wire [2:0] PL_LEDRGB0, PL_LEDRGB1, PL_LEDRGB2, PL_LEDRGB3,
    input  wire [3:0] PL_USER_PB,
    input  wire [7:0] JA_tri_io, JB_tri_io,
    input  wire [5:0] JAB_tri_io,
    input  wire [27:0] RBP_GPIO_tri_io,
    input  wire [3:0] PL_GRV_tri_io,
    output wire [3:0] SERVO,
    input  wire [0:0] SEL_JOYSTICK,
    input  i2c_aic_scl_io, i2c_aic_sda_io,
    input  wire [0:0] AIC_nRST,
    input  wire [4:0] CAM0_IN,
    output wire [3:0] CAM0_OUT
);

    // -----------------------------------------------------------------
    // Step 1: Clock buffer
    // TODO: instantiate IBUFDS to turn PL_CLK_100_P/N into a single
    // clock signal called `clk`.
    // -----------------------------------------------------------------
    wire clk;


    // -----------------------------------------------------------------
    // Step 2: Synchronize the switches and push buttons
    // TODO: build a two-flip-flop synchronizer for PL_USER_SW and
    // another for PL_USER_PB. Name the synchronized outputs whatever
    // you like, but keep the naming consistent with the rest of your design.
    // -----------------------------------------------------------------


    // -----------------------------------------------------------------
    // Step 3: 1 Hz blink generator
    // TODO: build a counter off the 100 MHz clock that toggles a
    // `blink` register once every 0.5 seconds (so the LED appears to
    // blink at 1 Hz overall).
    // -----------------------------------------------------------------


    // -----------------------------------------------------------------
    // Step 4: White LEDs
    // TODO: drive each bit of PL_USER_LED as (synchronized switch bit)
    // AND (blink). A switch that is off should keep its LED off; a
    // switch that is on should blink its LED at 1 Hz.
    // -----------------------------------------------------------------


    // -----------------------------------------------------------------
    // Step 5: RGB LEDs from push buttons
    // TODO: take three of the four synchronized push buttons as a
    // 3-bit value and load that value onto all four RGB LED outputs.
    // Use the fourth push button as a "flip" control: while it is
    // pressed, two of the four RGB LEDs should show the bitwise
    // complement of the 3-bit value instead of the value itself.
    // -----------------------------------------------------------------


    // -----------------------------------------------------------------
    // Step 6: Servo control from switches
    // TODO: use two of the synchronized switch bits to command a
    // repeating ~20 ms pulse on all four SERVO outputs:
    //   00 -> neutral pulse width
    //   01 -> "left" pulse width
    //   10 -> "right" pulse width
    //   11 -> hold whatever pulse width was last commanded
    // Think about what should happen at power-up before any switch
    // has been touched, and pick a safe default.
    // -----------------------------------------------------------------


endmodule
```


# Let the Zynq (PS) run

This design lets you hold the single PS pushbutton and blink a green PS LED at about 2 Hz. This uses only the processing system (PS). This design uses no programmable logic and no bitstream.

Follow the rules below, since each one, when broken, can be time-consuming to fix.

1. **Use the RealDigital 8 GB board files.** Do not build a project with only the chip part selected. If you leave the PS on Vivado's default DDR settings, the First-stage Boot Loader (FSBL) hangs during DDR initialization; the core never starts, and nothing runs. The board files carry the correct DDR, clock, and MIO configuration for this board.

2. **Never reuse an old platform or an old XSA after you change the hardware.** Replacing the `.xsa` file on disk is not enough. Vitis keeps its own copy and its own generated FSBL. If you change the hardware, either update the platform through the proper menu and rebuild it, or, more reliably, create a brand-new platform from the new XSA.

3. **Boot the board in JTAG mode, with no SD card.** The BOOT switch near the SD slot must be set to JTAG and read-only at power-on. If it is on SD, or a PYNQ card is inserted, the board boots from the card instead, and the debugger cannot reach the ARM core.

4. **Prove the hardware with Hello World before running your own code.** If Hello World prints over the serial port, the DDR, the FSBL, the console, and the JTAG link are all good, and any remaining problem is in your application. This single check immediately tells you whether the failure is in the hardware setup or in your code.

## Board facts on the PS side

| Item | Value |
|---|---|
| Device part | `xczu3eg-sfvc784-2-e` |
| Vivado board part (8 GB) | `realdigital.org:aup-zu3-8gb:part0:1.0` |
| Processor | `psu_cortexa53_0` |
| Console UART | PS UART1 on MIO32 (RXD) and MIO33 (TXD) |
| Console settings | 115200 baud, 8 data bits, no parity, 1 stop bit |
| PS pushbutton | MIO6, input, active high |
| PS green LED0 | MIO20, output, active high |
| PS green LED1 | MIO17, output, active high |

The PS button and the two green LEDs sit at the bottom edge of the board, between the Grove and Raspberry Pi connectors. They are a separate cluster from the four white pushbuttons and eight white LEDs, which belong to the programmable logic and are not used here.

## Prerequisite: get the board support files

Clone the vendor repository once, into a folder you have write access to (for example, your Desktop or Documents, not `C:\Program Files` or `C:\Xilinx`).

```bash
git clone https://github.com/RealDigitalOrg/aup-zu3-bsp.git
```

It includes `board-files/` (the Vivado board definitions) and `hw/hw-base-8GB.tcl` (a ready-made processor-only design with correct 8 GB DDR). Nothing here needs administrator rights, as long as you write everything you generate in your own user folders.

In the paths below, replace `<BSP>` with the full path to your cloned `aup-zu3-bsp` folder, and `<OUT>` with a working folder of your choice.

---

## Part A: build the 8 GB hardware in Vivado

Use the vendor script. It configures 8 GB DDR correctly, which is the whole point of rule 1.

1. Open the **Vivado 2023.1 Tcl Shell** from the Start menu (not the GUI yet).

2. Point Vivado at the board files and confirm they load. In the Tcl console, **use forward slashes** in every path (backslashes are treated as escape characters in Tcl and will mangle the path):

```tcl
set_param board.repoPaths [list "<BSP>/board-files"]
get_board_parts *aup-zu3*
```

The output must include `realdigital.org:aup-zu3-8gb:part0:1.0`. If it does not, the path is wrong; fix it before continuing.

3. Change into the `hw` directory and run the script. The script uses relative paths, so you must be inside `hw` when you run it:

```tcl
cd <BSP>/hw
source hw-base-8GB.tcl
```

4. Open the generated project in the GUI:

```tcl
start_gui
```

5. Open the block design: Flow Navigator, IP Integrator, Open Block Design. Confirm the Zynq UltraScale+ block is present.

6. Set the Task 2 peripherals in one command. In the Tcl console, change `zynq_ultra_ps_e_0` if the block on the canvas has a different name:

```tcl
set_property -dict [list \
 CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {1} \
 CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
 CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 32 .. 33} \
 CONFIG.PSU__UART1__BAUD_RATE {115200} \
 CONFIG.PSU__USE__M_AXI_GP0 {0} \
 CONFIG.PSU__USE__M_AXI_GP2 {0} \
 CONFIG.PSU__FPGA_PL0_ENABLE {0} \
] [get_bd_cells zynq_ultra_ps_e_0]
```

Enabling GPIO0 MIO hands MIO6, MIO17, and MIO20 to the GPIO controller, because no other peripheral on this board claims them. You do not assign individual MIO pins. Turning off the AXI masters and the PL clock keeps the design clean, since there is no programmable logic.

7. Generate the output products.

```tcl
generate_target all [get_files *.bd]
```

8. Confirm a wrapper exists: Sources panel, Hierarchy tab. Design Sources should show a bold `..._wrapper.v`. If it is missing, right-click the `.bd`, choose Create HDL Wrapper, select "Let Vivado manage wrapper and auto-update", and click OK.

9. Export the hardware to a **fresh path with a distinct name**, never the old `design_1_wrapper.xsa`. Menu: File > Export > Export Hardware. Choose Fixed, then Pre-synthesis (no bitstream). Save as:

```
<OUT>/ps8gb.xsa
```

A new, clearly named file removes any chance of picking up an old XSA later.

---

## Part B: create a brand-new platform in Vitis 

10. Create the platform: File, New, Platform Project. Name it `plat8gb`. Choose "Create from hardware specification (XSA)" and select `<OUT>/ps8gb.xsa`. Set OS to standalone and processor to `psu_cortexa53_0`. Finish.

11. Build the platform: right-click `plat8gb`, Build Project. This generates the correct 8 GB FSBL. Wait for it to finish.

---

## Part C: Prove the hardware with Hello World

12. File, New, Application Project. Select the `plat8gb` platform. Domain: standalone on `psu_cortexa53_0`. Template: **Hello World**. Name it `hello`. Finish.

13. Right-click `hello`, Build Project.

14. Board setup, and repeat this before every launch:
    - BOOT switch near the SD slot set to **JTAG** and/or SD card **removed**
    - powered from the **9V/3A** USB-C supply
    - PROG UART USB-C cable connected

15. Open the serial terminal before launching: Window, Show View, Vitis Serial Terminal. Click the plus, select the board's COM port, set 115200 baud, 8 data bits, no parity, 1 stop bit. (To confirm which COM port is the board, unplug the USB cable and see which port disappears, then plug it back in.)

16. Right-click `hello`, Run As, Launch Hardware (Single Application Debug).

17. Read the launch log. Success means the warning `Exit breakpoint of FSBL (XFsbl_Exit) is not hit` is **absent**. If it is absent, the 8 GB DDR is correct and the core booted.
 
 ---

## Part D: run the button-blink application

18. File, New, Application Project. Select `plat8gb`. Domain: standalone on `psu_cortexa53_0`. Template: **Empty Application(C)**. Name it `ps_button_blink`. Finish.

19. Right-click the application's `src` folder, New, File, name it `ps_button_blink.c`, and paste the code below. If the template left any stub `.c` file, delete it so there is only one `main`.

20. Right-click `ps_button_blink` and select Build Project. A clean build ends by creating `ps_button_blink.elf`.

21. Set the board up as in step 16 and connect the terminal as in step 17. Right-click `ps_button_blink`, Run As, Launch Hardware. Resume with F8 if it pauses.

22. The startup line prints on the serial terminal. Press and hold the single PS button at the bottom edge of the board; the green LED0 next to it blinks about twice a second. It stays off until you press it, and it is not one of the white LEDs.

```c
/*
 * ps_button_blink.c   AUP-ZU3 (8 GB), bare metal.
 * Hold the PS button (MIO6) -> PS green LED0 (MIO20) blinks ~2 Hz.
 * All PS GPIO on this board are active high.
 */
#include "xparameters.h"
#include "xgpiops.h"
#include "sleep.h"
#include "xil_printf.h"

#define PS_BTN_PIN    6U    /* MIO6  : PS button, input  */
#define PS_LED0_PIN  20U    /* MIO20 : PS LED0,  output  */

int main(void){
    XGpioPs_Config *cfg;
    XGpioPs gpio;

    cfg = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
    if (cfg == NULL) {
        return XST_FAILURE;
    }
    if (XGpioPs_CfgInitialize(&gpio, cfg, cfg->BaseAddr) != XST_SUCCESS) {
        return XST_FAILURE;
    }

    /* Direction: 0 input, 1 output. An output also needs its driver
       enabled, which is a separate call and easy to forget. */
    XGpioPs_SetDirectionPin(&gpio, PS_BTN_PIN, 0U);
    XGpioPs_SetDirectionPin(&gpio, PS_LED0_PIN, 1U);
    XGpioPs_SetOutputEnablePin(&gpio, PS_LED0_PIN, 1U);
    XGpioPs_WritePin(&gpio, PS_LED0_PIN, 0U);

    xil_printf("AUP-ZU3: hold the PS button to blink PS LED0.\r\n");

    while (1) {
        if (XGpioPs_ReadPin(&gpio, PS_BTN_PIN) & 0x1U) {
            XGpioPs_WritePin(&gpio, PS_LED0_PIN, 1U);
            usleep(250000U);            /* 0.25 s on  */
            XGpioPs_WritePin(&gpio, PS_LED0_PIN, 0U);
            usleep(250000U);            /* 0.25 s off -> about 2 Hz */
        } else {
            XGpioPs_WritePin(&gpio, PS_LED0_PIN, 0U);
            usleep(10000U);             /* 10 ms idle poll */
        }
    }
    return 0;   /* never reached */
}
```

Note for a newer toolchain: Vitis Unified with the System Device Tree flow does not define device-ID macros. If `XPAR_XGPIOPS_0_DEVICE_ID` is not found, use `XPAR_XGPIOPS_0_BASEADDR` in the lookup call, and if the compiler reports that `XGpioPs_Config` has no member `BaseAddr`, the field is named `BaseAddress`. Nothing else changes. On Vitis 2023.1 Classic, the code above is correct as written.

---

# Let the Zynq (PS) and HDL (PL) talk