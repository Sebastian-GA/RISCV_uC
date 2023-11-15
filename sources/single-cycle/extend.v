`timescale 1ns / 1ps
// extend.v
// Extend
// Authors: Sebastian Garcia
//          Juliana Pineda


module extend(
    input [24:0] imm,
    input [2:0] imm_src,

    output reg [31:0] imm_ext
);

    always @(*)
    case (imm_src)
        3'b000: imm_ext = {{20{imm[24]}}, imm[24:13]}; // I-type
        3'b001: imm_ext = {{20{imm[24]}}, imm[24:18], imm[4:0]}; // S-type
        3'b010: imm_ext = {{20{imm[24]}}, imm[0], imm[23:18], imm[4:1], 1'b0}; // B-type
        3'b011: imm_ext = {{12{imm[24]}}, imm[12:5], imm[13], imm[23:14], 1'b0}; // J-type
        3'b100: imm_ext = {imm[24:5], 12'd0}; // U-type
        default: imm_ext = 0;
    endcase

endmodule
