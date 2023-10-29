`timescale 1ns / 1ps
// digital_out.v
// Digital output
// Authors: Sebastian Garcia
//         Juliana Pineda


module digital_out(
    input clk,
    input [15:0] WD,
    input WE,
    
    output [15:0] led,
    output [31:0] RD
);

    // Peripheral registers
    reg [15:0] outputs = 0;
    assign RD = outputs;
    
    // Assign led
    assign led = outputs[15:0];

    always @ (posedge clk)
        outputs <= WE ? WD : outputs;

endmodule
