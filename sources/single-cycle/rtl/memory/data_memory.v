`timescale 1ns / 1ps
// data_memory.v
// Data Memory
// Authors: Sebastian Garcia
//          Juliana Pineda


module data_memory
# (parameter N = 8)(
    input clk,
    input [N-1:0] A,
    input [31:0] WD,
    input WE,

    output [31:0] RD
);
    
    // word-based memory
    reg [31:0] memory [0:(2**N)/4-1];

    always @ (posedge clk)
        if (WE) begin
            // memory[A] <= WD[7:0];
            // memory[A+1] <= WD[15:8];
            // memory[A+2] <= WD[23:16];
            // memory[A+3] <= WD[31:24];

            memory[A/4] <= WD[31:0];  // Done this way to write only once the memory and avoid warnings
                                      // also, allows memory to be implemented using RAM blocks
                                      // instead of registers. This increases the maximum frequency
        end

    // assign RD = {memory[A+3], memory[A+2], memory[A+1], memory[A]};
    assign RD = memory[A/4];

endmodule
