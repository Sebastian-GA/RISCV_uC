`timescale 1ns / 1ps
// digital_out.v
// Digital output
// Authors: Sebastian Garcia
//         Juliana Pineda


module digital_out(
    input clk,
    input [4:0] WD,
    input WE,
    
    output [4:0] led,
    output [31:0] RD
);

    // Peripheral registers
    reg [4:0] outputs = 0;
    assign RD = outputs;
    
    // Assign led
    assign led = outputs[4:0];

    always @ (posedge clk)
        outputs <= WE ? WD : outputs;

endmodule
