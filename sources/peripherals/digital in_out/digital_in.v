`timescale 1ns / 1ps
// digital_in.v
// Digital input
// Author: Sebastian Garcia
//         Juliana Pineda


module digital_in(
    input clk,
    input [15:0] sw,
    input [4:0] btn,
    input [3:0] ipin,
    
    output [31:0] RD
);
    // Peripherals registers
    reg [24:0] inputs = 0;
    assign RD = inputs;

    always @ (posedge clk)
        inputs <= {btn, ipin, sw};

endmodule
