`timescale 1ns / 1ps
//=====================================================================
// pl_signal.v
//
// Custom PL logic that sits on the PS <-> PL data path for Task 3.
// Target: RealDigital AUP-ZU3, Zynq UltraScale+ XCZU3EG (8 GB).
//
//   enable_in : 1-bit value from the PS, arriving over AXI GPIO
//               channel 1. High -> this module blinks the PL LED.
//               Low -> LED off. So the PS decides "blink or not", and
//               the actual blinking is generated here in hardware.
//
//   led_out   : drives one white PL LED pin.
//
//   sw_in     : one PL slide switch pin. It is synchronized here and
//               handed back to the PS over AXI GPIO channel 2 as
//               sw_out, so the PS can read a PL input.
//
//   clk       : pl_clk0 from the processor (about 100 MHz). The exact
//               frequency does not matter for a blink; CLK_HZ is only
//               used to pick the divider, and being a few percent off
//               just shifts the blink rate slightly.
//
// The 1-bit AXI-facing ports are declared as [0:0] vectors so they
// match the AXI GPIO gpio_io_o and gpio2_io_i pins exactly, which
// keeps the block-design connection clean.
//=====================================================================

module pl_signal #(
    parameter integer CLK_HZ   = 100_000_000, // pl_clk0 frequency, approx
    parameter integer BLINK_HZ = 1            // PL LED blink rate
)(
    input  wire       clk,
    input  wire [0:0] enable_in,   // from PS, AXI GPIO channel 1
    output wire       led_out,     // to PL white LED pin
    input  wire       sw_in,       // from PL slide switch pin
    output wire [0:0] sw_out       // to PS, AXI GPIO channel 2
);

    // Blink generator. Toggle every half period, so BLINK_HZ full cycles
    // per second. The counter is 32 bits so any sane parameter fits;
    // synthesis trims the unused upper bits.
    localparam integer HALF = CLK_HZ / (2 * BLINK_HZ);

    reg [31:0] cnt   = 32'd0;
    reg        blink = 1'b0;

    always @(posedge clk) begin
        if (cnt == HALF - 1) begin
            cnt   <= 32'd0;
            blink <= ~blink;
        end else begin
            cnt <= cnt + 32'd1;
        end
    end

    // PS -> PL: the enable bit gates the blink onto the LED.
    assign led_out = enable_in[0] & blink;

    // PL -> PS: synchronize the switch before it leaves the PL, then
    // present it on the channel-2 input bit.
    reg sw_meta = 1'b0;
    reg sw_ff   = 1'b0;

    always @(posedge clk) begin
        sw_meta <= sw_in;
        sw_ff   <= sw_meta;
    end

    assign sw_out[0] = sw_ff;

endmodule
