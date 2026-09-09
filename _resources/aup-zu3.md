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

# Let the Zynq (PS) and HDL (PL) talk