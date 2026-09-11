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

# Task 1: Blink the LEDs in HDL
In this part, you are expected to blink the LEDs using the board's switches and buttons. The design is the same as the existing HDL design at this stage: write the HDL design, run synthesis and implementation, and see the design run. Below is a small working HDL design, along with the constraint file [here](https://wangantian.github.io/files/aup-zu3_files/zu3.xdc), with minor modifications from the official documents. 

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


# Task 2: Let the Zynq (PS) run

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

# Task 3: Let the Zynq (PS) and HDL (PL) talk

Goal: move one bit across the PS/PL boundary in each direction, with custom HDL on one side and C on the other.

- PS to PL: the PS reads its button, sends the bit over AXI to the PL, and the custom HDL blinks a PL LED while the bit is high.
- PL to PS: a PL slide switch is synchronized in the custom HDL, sent back over AXI, and the PS mirrors it onto a PS LED.

## New reminders for Task 3

The four rules that made Task 2 work still apply. Task 3 adds two more, because Task 3 uses the programmable logic (PL) and Task 2 did not. Apart from the rules listed for the Task 2, there are several more added for the Task 3. 

5. **A bitstream is required, and must be included in the XSA.** Task 2 exported "Pre-synthesis" with no bitstream because the PL was empty. Task 3 has real PL logic, so you must run implementation and generate a bitstream, then export the hardware **with the bitstream included**. The build script does this with `write_hw_platform -include-bit`.
6. **The FPGA must be programmed at launch.** If the PL is not programmed, the AXI GPIO does not physically exist, and the first AXI read or write from the PS hangs (a bus transaction to a missing slave never completes). In Vitis Classic this is the "Program FPGA" option in the run configuration, which is on by default when the platform's XSA contains a bitstream. Verify it, and confirm the board's DONE LED lights after launch, which means the bitstream loaded.

## Board facts for Task 3

| Item | Value |
|---|---|
| Device part | `xczu3eg-sfvc784-2-e` |
| Vivado board part (8 GB) | `realdigital.org:aup-zu3-8gb:part0:1.0` |
| Processor | `psu_cortexa53_0` |
| Console UART | PS UART1, MIO32 (RXD) / MIO33 (TXD), 115200 8N1 |
| PS button | MIO6, input, active high |
| PS green LED1 | MIO17, output, active high |
| PL white LED LD1 | package pin AE7, LVCMOS12 |
| PL slide switch SW0 | package pin AB1, LVCMOS12 |

## The data path

```
  PS button (MIO6)                              PL slide switch (SW0, AB1)
        |                                                 |
   XGpioPs read                                     sw_in (pin)
        |                                                 |
   XGpio write ch1  --AXI-->  gpio_io_o[0]        pl_signal synchronizer
                                   |                      |
                             pl_signal:                sw_out[0]
                             enable & blink               |
                                   |               gpio2_io_i[0] <--AXI--  XGpio read ch2
                              led_out (pin)                                     |
                                   |                                     XGpioPs write
                           PL white LED (LD1, AE7)                        PS LED1 (MIO17)
```

The blinking itself happens in `pl_signal` (HDL). The PS only sends "enable or not". That is what puts custom HDL on the data path rather than letting AXI GPIO drive the LED directly.

## Prerequisite: board support files and source files

You already have the vendor repository from Task 2. If not, clone it into a folder you can write to (not `C:\Program Files` or `C:\Xilinx`):

```bash
git clone https://github.com/RealDigitalOrg/aup-zu3-bsp.git
```

Put these three files, provided alongside this guide, into one working folder:

- `pl_signal.v` (the custom PL module) available [here].(https://wangantian.github.io/files/aup-zu3_files/pl_signal.v)
- `ps_pl_link.xdc` (the two pin constraints)  [here].(https://wangantian.github.io/files/aup-zu3_files/ps_pl_link.xdc)
- `build_ps_pl.tcl` (the hardware build script)  [here].(https://wangantian.github.io/files/aup-zu3_files/build_ps_pl.tcl) You need to change the direcoty of the board support package in this file. 

In the paths below, replace `<BSP>` with the full path to your `aup-zu3-bsp` folder, and `<OUT>` with a working folder of your choice. 


## Part A: build the hardware in Vivado (one script)

The script builds the PS with correct 8 GB DDR, adds the AXI GPIO and the custom module, wires the AXI bus explicitly, runs implementation and bitstream, and exports the XSA with the bitstream. 

1. Open `build_ps_pl.tcl` and edit the two paths at the top: `bsp_boardfiles` to `<BSP>/board-files`, and `xsa_out` to `<OUT>/ps_pl_8gb.xsa`. Use forward slashes in every path, even on Windows; backslashes are treated as escape characters in Tcl.

2. Open the **Vivado 2023.1 Tcl Shell** from the Start menu. You may need to change versions based on the Vivado you installed. 

3. Change into your working folder (the one holding the three files) and run the script:

```tcl
cd <your working folder>
source build_ps_pl.tcl
```

4. The script runs for several minutes, mostly in implementation and bitstream. When it finishes it prints `Wrote <OUT>/ps_pl_8gb.xsa`. That XSA contains the bitstream. You may choose to build it in GUI. 

If you would rather build it in the GUI, you need to add the Zynq block and run block automation, enable `M_AXI_HPM0_LPD` and `pl_clk0` in the PS, add an AXI GPIO set to dual channel (channel 1 one output, channel 2 one input), add `pl_signal` with Add Module, run Connection Automation for the AXI GPIO, then connect `gpio_io_o[0]` to `pl_signal/enable_in`, connect `pl_signal/sw_out` to `gpio2_io_i[0]`, connect `pl_clk0` to `pl_signal/clk`, make `led_out` and `sw_in` external and rename them `pl_led` and `pl_sw`, then generate output products, create the HDL wrapper, run synthesis, implementation, and bitstream, and export hardware including the bitstream. The script is more convinent for such a procedure. 

## Part B: create a brand-new platform in Vitis

Do not reuse the Task 2 platform. This XSA has PL and a bitstream; the Task 2 XSA does not.

5. Remove any leftover run configurations so you cannot launch the wrong thing: menu Run, Run Configurations, delete any existing entries under Single Application Debug.

6. Create the platform: File, New, Platform Project. Name it, for example, `plat_pspl`. Choose "Create from hardware specification (XSA)" and select `<OUT>/ps_pl_8gb.xsa`. Set OS to standalone and processor to `psu_cortexa53_0`. Finish.

7. Build the platform: right-click `plat_pspl`, Build Project. Wait for it to finish. This regenerates the FSBL for the 8 GB DDR and packages the bitstream into the platform.
 
## Part C: prove the hardware with Hello World

8. File, New, Application Project. Select the `plat_pspl` platform. Domain standalone on `psu_cortexa53_0`. Template: **Hello World**. Name it `hello`. Finish. Then right-click `hello`, Build Project.

9. Board setup, and repeat this before every launch: BOOT switch on **JTAG**, SD card **removed**, powered from the **9V/3A** supply, PROG UART cable connected.

10. Open the serial terminal before launching: Window, Show View, Vitis Serial Terminal. Click the plus, select the board's COM port, set 115200 baud, 8 data bits, no parity, 1 stop bit. To find which COM port is the board, unplug the USB cable and see which one disappears.

11. Right-click `hello`, Run As, Launch Hardware (Single Application Debug).

12. Two checks. First, the launch log must **not** show the FSBL exit-breakpoint timeout. Second, the board's DONE LED should light, which confirms the bitstream was programmed. If the program pauses at `main`, click once in the Debug panel and press **F8** to resume. Do not press Suspend. "Hello World" prints on the serial terminal.

If Hello World prints and DONE is lit, the platform is correct and the FPGA programs. Move on. If not, fix that first.
 
## Part D: run the PS/PL link application

13. File, New, Application Project. Select `plat_pspl`. Domain standalone on `psu_cortexa53_0`. Template: **Empty Application(C)**. Name it `ps_pl_link`. Finish.

14. Right-click the application's `src` folder, New, File, name it `ps_pl_link.c`, and paste the code below (also provided as a file). If the template left any stub `.c`, delete it so there is only one `main`.

15. Right-click `ps_pl_link`, Build Project.

16. With the board set up as in step 9 and the terminal connected as in step 10, right-click `ps_pl_link`, Run As, Launch Hardware. Resume with F8 if it pauses.

17. What you should see. The startup line prints on the terminal. Press and hold the single PS button at the bottom edge of the board; the white PL LED (LD1) blinks about once a second, because the PS sent the enable bit and the PL generated the blink. Separately, slide PL switch SW0; the green PS LED1 turns on, because the switch value traveled over AXI into the PS. Each direction is a real AXI transfer.

```c
/*
 * ps_pl_link.c   AUP-ZU3 (8 GB), bare metal, Task 3.
 *   PS -> PL : PS button (MIO6) -> AXI GPIO ch1 -> PL blinks LED
 *   PL -> PS : PL switch -> AXI GPIO ch2 -> PS mirrors onto LED1 (MIO17)
 * All GPIO on this board is active high.
 */
#include "xparameters.h"
#include "xgpiops.h"
#include "xgpio.h"
#include "sleep.h"
#include "xil_printf.h"

#define PS_BTN_PIN    6U    /* MIO6  : PS button, input  */
#define PS_LED1_PIN  17U    /* MIO17 : PS LED1,  output  */

#define AXI_CH_LED    1U    /* channel 1 : 1-bit output -> enable to PL */
#define AXI_CH_SW     2U    /* channel 2 : 1-bit input  <- switch from PL */

int main(void)
{
    XGpioPs_Config *ps_cfg;
    XGpioPs ps;
    XGpio   pl;

    ps_cfg = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);
    if (ps_cfg == NULL) {
        return XST_FAILURE;
    }
    if (XGpioPs_CfgInitialize(&ps, ps_cfg, ps_cfg->BaseAddr) != XST_SUCCESS) {
        return XST_FAILURE;
    }
    XGpioPs_SetDirectionPin(&ps, PS_BTN_PIN, 0U);
    XGpioPs_SetDirectionPin(&ps, PS_LED1_PIN, 1U);
    XGpioPs_SetOutputEnablePin(&ps, PS_LED1_PIN, 1U);
    XGpioPs_WritePin(&ps, PS_LED1_PIN, 0U);

    if (XGpio_Initialize(&pl, XPAR_AXI_GPIO_0_DEVICE_ID) != XST_SUCCESS) {
        return XST_FAILURE;
    }
    XGpio_SetDataDirection(&pl, AXI_CH_LED, 0x0U);   /* outputs */
    XGpio_SetDataDirection(&pl, AXI_CH_SW,  0x1U);   /* input   */
    XGpio_DiscreteWrite(&pl, AXI_CH_LED, 0x0U);

    xil_printf("AUP-ZU3 PS/PL link: PS button -> PL LED (blinks), "
               "PL switch -> PS LED1.\r\n");

    while (1) {
        u32 btn = XGpioPs_ReadPin(&ps, PS_BTN_PIN) & 0x1U;  /* PS -> PL */
        XGpio_DiscreteWrite(&pl, AXI_CH_LED, btn);

        u32 sw = XGpio_DiscreteRead(&pl, AXI_CH_SW) & 0x1U; /* PL -> PS */
        XGpioPs_WritePin(&ps, PS_LED1_PIN, sw);

        usleep(10000U);
    }
    return 0;
}
```

Note for a newer toolchain [untested]: on Vitis Unified with the System Device Tree flow, the device-ID macros do not exist. Use `XPAR_XGPIOPS_0_BASEADDR` and `XPAR_AXI_GPIO_0_BASEADDR` in the lookup and initialize calls, and if `XGpioPs_Config` has no `BaseAddr` member, it is `BaseAddress`. On 2023.1 Classic the code above is correct as written.

# Task 4: Script-based PS and PL workflow

In the Task 3, we try the script-based PL-side configurations, and now we could consider a fully scripted based PS and PL workflow. 