`timescale 1ns / 1ps
// ALU.v
// ALU
// Authors: Sebastian Garcia
//          Juliana Pineda


module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] alu_control,

    output reg [31:0] alu_out,
    output zero
);

    // Add / Sub
    wire [31:0] B_sign;
    wire [31:0] sum;

    assign B_sign = alu_control[0] ? ~B : B;
    assign sum = A + B_sign + alu_control[0]; // ignore carry-out

    // Overflow
    wire xnor_overflow;
    wire xor_overflow;
    wire not_overflow;
    wire and_overflow;

    assign xnor_overflow = ~(A[31] ^ B[31] ^ alu_control[0]);
    assign xor_overflow = A[31] ^ sum[31];
    assign not_overflow = alu_control[1];

    assign and_overflow = xnor_overflow & xor_overflow & not_overflow;

    wire slt_out;
    assign slt_out = and_overflow ^ sum[31];

    // Zero flag
    assign zero = (sum == 0);

    always @(*)
    case (alu_control)
        3'b000: alu_out = sum; // Add
        3'b001: alu_out = sum; // Substract
        3'b010: alu_out = A & B; // AND
        3'b011: alu_out = A | B; // OR
        3'b100: alu_out = A << B[4:0]; // SLL
        3'b101: alu_out = {{31{1'b0}}, slt_out}; // SLT
        3'b110: alu_out = A >> B[4:0]; // SRL
        3'b111: alu_out = A ^ B; // XOR
        default: alu_out = 0;
    endcase

endmodule
