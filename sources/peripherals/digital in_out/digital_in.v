`timescale 1ns / 1ps
// digital_in.v
// Digital input
// Author: Sebastian Garcia
//         Juliana Pineda


module digital_in(
    input clk,
    input [4:0] btn,
    input [15:0] sw,
    // input [4:0] ipins,
    
    output [31:0] RD
);
    // Peripherals registers
    reg [20:0] inputs = 0;
    assign RD = inputs;

    always @ (posedge clk)
        inputs <= {btn, sw};

endmodule
