`timescale 1ns / 1ps
// instr_decoder.v
// Immediate Instruction Decoder
// Authors: Sebastian Garcia
//          Juliana Pineda


module instr_decoder(
    input [6:0] op,
    output reg [2:0] imm_src
);

    always @(*)
    case (op)
        7'b0010011: imm_src = 3'b000; // I-type
        7'b0100011: imm_src = 3'b001; // S-type
        7'b1100011: imm_src = 3'b010; // B-type
        7'b1101111: imm_src = 3'b011; // J-type
        7'b0110111: imm_src = 3'b100; // U-type
        default: imm_src = 3'b000;
    endcase

endmodule
