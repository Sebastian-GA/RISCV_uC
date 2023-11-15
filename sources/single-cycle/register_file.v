`timescale 1ns / 1ps
// register_file.v
// Register file
// Authors: Sebastian Garcia
//          Juliana Pineda


module register_file(
    input clk,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input WE3,
    input [31:0] WD3,

    output [31:0] RD1,
    output [31:0] RD2
);

    // Registers
    reg [31:0] register [0:31];

    // Read data from register bank
    assign RD1 = register[A1];
    assign RD2 = register[A2];

    always @ (posedge clk)
    if (WE3 && A3 != 0)
        register[A3] <= WD3;
    
    initial begin
        register[0] = 32'h00000000;
    end

endmodule
