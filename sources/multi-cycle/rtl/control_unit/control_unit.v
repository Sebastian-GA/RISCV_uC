`timescale 1ns / 1ps
// control_unit.v
// Control Unit
// Authors: Sebastian Garcia
//          Juliana Pineda


module control_unit(
    input clk,

    input [6:0] op,
    input [2:0] funct3,
    input funct7_5,
    input zero,

    output pc_write,
    output adr_src,
    output mem_write,
    output ir_write,
    output [1:0] result_src,
    output [2:0] alu_control,
    output [1:0] alu_srcA,
    output [1:0] alu_srcB,
    output [2:0] imm_src,
    output reg_write
);

    wire branch;
    wire pc_update;
    wire [1:0] alu_op;
    assign pc_write = pc_update | (branch & zero);

    main_fsm main_fsm(
        .clk(clk),
        .op(op),
        .branch(branch),
        .pc_update(pc_update),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .ir_write(ir_write),
        .result_src(result_src),
        .alu_srcA(alu_srcA),
        .alu_srcB(alu_srcB),
        .adr_src(adr_src),
        .alu_op(alu_op)
    );

    alu_decoder alu_decoder(
        .alu_op(alu_op),
        .op_5(op[5]),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .alu_control(alu_control)
    );

    instr_decoder instr_decoder(
        .op(op),
        .imm_src(imm_src)
    );

endmodule
