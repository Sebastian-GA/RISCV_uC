`timescale 1ns / 1ps
// control_unit.v
// Control Unit
// Authors: Sebastian Garcia
//          Juliana Pineda


module control_unit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7_5,
    input zero,

    output pc_src,
    output [1:0] result_src,
    output mem_write,
    output [2:0] alu_control,
    output alu_srcA,
    output alu_srcB,
    output [2:0] imm_src,
    output reg_write
);

    wire [1:0] alu_op;
    wire branch;
    wire jump;
    assign pc_src = (branch & zero) | jump;

    main_decoder main_decoder(
        .op(op),
        .branch(branch),
        .jump(jump),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB),
        .imm_src(imm_src),
        .reg_write(reg_write),
        .alu_op(alu_op)
    );

    alu_decoder alu_decoder(
        .alu_op(alu_op),
        .op_5(op[5]),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .alu_control(alu_control)
    );

endmodule
