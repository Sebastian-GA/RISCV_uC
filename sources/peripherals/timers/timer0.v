`timescale 1ns / 1ps
// timer0.v
// Timer0
// Authors: Sebastian Garcia
//         Juliana Pineda


module timer0(
    input clk,
    input [31:0] WD,
    input WE,

    output [31:0] RD
);

    // Timer0 register
    reg [31:0] timer0 = 0;
    assign RD = timer0;

    always @ (posedge clk)
        timer0 <= WE ? WD[31:0] : timer0 + 1;

endmodule
