`timescale 1ns / 1ps
// display_7seg.v
// Display_7seg controller module
// Author: Sebastian Garcia


module display_7seg(
    input clk,
    input [3:0] num0,
    input [3:0] num1,
    input [3:0] num2,
    input [3:0] num3,
    input [3:0] nums_enable,
    input [3:0] dots_enable,

    output [6:0] hex,
    output reg hex_dot,
    output reg [3:0] hex_sel
);
    
    // Frequency divider
    localparam NBITS = 15;
    reg [NBITS-1:0] Z = 0;
    wire enable;

    always @(posedge clk)
        Z <= enable ? 0 : Z + 1'b1;
    
    assign enable = (Z == {NBITS{1'b1}});

    // Number selector
    reg [1:0] num_selected;

    always @(posedge clk)
        if (enable)
            num_selected <= num_selected + 1'b1;
    
    // Number
    reg [3:0] num_out;

    always @(*)
        case (num_selected)
            2'b00: num_out = num0;
            2'b01: num_out = num1;
            2'b10: num_out = num2;
            2'b11: num_out = num3;
        endcase
    
    bin_to_7seg converter(
        .num(num_out),
        .hex(hex)
    );
    
    // Selector
    always @(*)
        case (num_selected)
            2'b00: begin
                hex_sel = {3'b111, ~nums_enable[0]};
                hex_dot = dots_enable[0];
            end
            2'b01: begin
                hex_sel = {2'b11, ~nums_enable[1], 1'b1};
                hex_dot = dots_enable[1];
            end
            2'b10: begin
                hex_sel = {1'b1, ~nums_enable[2], 2'b11};
                hex_dot = dots_enable[2];
            end
            2'b11: begin
                hex_sel = {~nums_enable[3], 3'b111};
                hex_dot = dots_enable[3];
            end
        endcase
    
endmodule
