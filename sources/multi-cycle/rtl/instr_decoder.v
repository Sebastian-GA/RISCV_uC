`timescale 1ns / 1ps
// instr_decoder.v
// Immediate Instruction Decoder
// Authors: Sebastian Garcia
//          Juliana Pineda


module instr_decoder(
    input [6:0] op,
    output [2:0] imm_src,
);

    always @(*)
    // All don't-care outputs are set to 0
    case (op)
        7'b0000011: imm_src = 3'b000; // lw
        7'b0100011: imm_src = 3'b001; // sw
        7'b0110011: imm_src = 3'b000; // R-type
        7'b1100011: imm_src = 3'b010; // beq
        7'b0010011: imm_src = 3'b000; // I-type
        7'b1101111: imm_src = 3'b011; // jal
        7'b0110111: imm_src = 3'b100; // U-type
        default: imm_src = 3'b000;
    endcase

endmodule
