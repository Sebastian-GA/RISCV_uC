`timescale 1ns / 1ps
// alu_decoder.v
// ALU Decoder
// Authors: Sebastian Garcia
//          Juliana Pineda


module alu_decoder(
    input [1:0] alu_op,
    input op_5,
    input [2:0] funct3,
    input funct7_5,

    output reg [2:0] alu_control
);

    always @(*)
    casex ({alu_op, funct3, op_5, funct7_5})
        7'b00_???_??: alu_control = 3'b000; // Add
        7'b01_???_??: alu_control = 3'b001; // Substract
        7'b10_000_11: alu_control = 3'b001; // Substract
        7'b10_000_??: alu_control = 3'b000; // Add
        7'b10_010_??: alu_control = 3'b101; // SLT
        7'b10_110_??: alu_control = 3'b011; // OR
        7'b10_111_??: alu_control = 3'b010; // AND
        7'b10_100_??: alu_control = 3'b111; // XOR
        7'b10_001_?0: alu_control = 3'b100; // SLL
        7'b10_101_?0: alu_control = 3'b110; // SRL
        default: alu_control = 3'b000;
    endcase

endmodule
