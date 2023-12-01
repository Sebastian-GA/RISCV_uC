`timescale 1ns / 1ps
// main_decoder.v
// Main Decoder
// Authors: Sebastian Garcia
//          Juliana Pineda


module main_decoder(
    input [6:0] op,

    output branch,
    output jump,
    output [1:0] result_src,
    output mem_write,
    output alu_srcA,
    output alu_srcB,
    output [2:0] imm_src,
    output reg_write,
    output [1:0] alu_op
);

    reg [12:0] output_decoder;

    always @(*)
    // All don't-care outputs are set to 0
    case (op)
        7'b0000011: output_decoder = 13'b1_000_0_1_0_01_0_00_0; // lw
        7'b0100011: output_decoder = 13'b0_001_0_1_1_00_0_00_0; // sw
        7'b0110011: output_decoder = 13'b1_000_0_0_0_00_0_10_0; // R-type
        7'b1100011: output_decoder = 13'b0_010_0_0_0_00_1_01_0; // beq
        7'b0010011: output_decoder = 13'b1_000_0_1_0_00_0_10_0; // I-type
        7'b1101111: output_decoder = 13'b1_011_0_0_0_10_0_00_1; // jal
        7'b0110111: output_decoder = 13'b1_100_0_0_0_11_0_000; // U-type
        default: output_decoder = 13'b0000000000000;
    endcase

    assign reg_write = output_decoder[12];
    assign imm_src = output_decoder[11:9];
    assign alu_srcA = output_decoder[8];
    assign alu_srcB = output_decoder[7];
    assign mem_write = output_decoder[6];
    assign result_src = output_decoder[5:4];
    assign branch = output_decoder[3];
    assign alu_op = output_decoder[2:1];
    assign jump = output_decoder[0];

endmodule
