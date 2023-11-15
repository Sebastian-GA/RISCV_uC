`timescale 1ns / 1ps
// digital_out.v
// Digital output
// Authors: Sebastian Garcia
//         Juliana Pineda


module digital_out #(N_OUTPUTS = 16)(
    input clk,
    input [N_OUTPUTS-1:0] WD,
    input WE,
    
    output [31:0] RD
);

    // Peripheral registers
    reg [N_OUTPUTS-1:0] outputs = 0;
    assign RD = outputs;

    always @ (posedge clk)
        outputs <= WE ? WD : outputs;

endmodule
