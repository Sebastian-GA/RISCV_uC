`timescale 1ns / 1ps
// peripheral_display_7seg.v
// Peripheral_7seg_display module
// Author: Sebastian Garcia


module peripheral_display_7seg(
    input clk,
    input [24:0] WD,
    input WE,

    output [6:0] hex,
    output hex_dot,
    output [3:0] hex_sel,
    output [31:0] RD
);

    // Peripheral registers
    reg [15:0] nums;
    reg [3:0] nums_enable;
    reg [3:0] dots_enable;
    reg nums_format;
    assign RD = {nums_format, dots_enable, nums_enable, nums};

    always @(posedge clk) begin
        nums <= WE ? WD[15:0] : nums;
        nums_enable <= WE ? WD[19:16] : nums_enable;
        dots_enable <= WE ? WD[23:20] : dots_enable;
        nums_format <= WE ? WD[24] : nums_format;
    end

    wire [15:0] bcd;
    wire [15:0] nums_corrected;

    bin_to_bcd converter(
        .bin(nums[13:0]),
        .bcd(bcd)
    );

    // If nums_format is 1, input is written in binary to its converted to BCD
    assign nums_corrected = nums_format ? bcd : nums;

    display_7seg display_7seg(
        .clk(clk),
        .num0(nums_corrected[3:0]),
        .num1(nums_corrected[7:4]),
        .num2(nums_corrected[11:8]),
        .num3(nums_corrected[15:12]),
        .nums_enable(nums_enable),
        .dots_enable(dots_enable),

        .hex(hex),
        .hex_dot(hex_dot),
        .hex_sel(hex_sel)
    );
    
endmodule
