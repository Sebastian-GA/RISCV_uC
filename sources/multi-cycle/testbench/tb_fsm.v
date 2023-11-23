`timescale 1ns / 1ps
// tb_fsm.v
// Main FSM
// Authors: Sebastian Garcia
//          Juliana Pineda


module tb_fsm();
    reg clk;
    reg [6:0] op;

    wire branch;
    wire pc_update;
    wire reg_write;
    wire mem_write;
    wire ir_write;
    wire [1:0] result_src;
    wire [1:0] alu_srcA;
    wire [1:0] alu_srcB;
    wire adr_src;
    wire [1:0] alu_op;

    // Instantiate main FSM
    main_fsm U0(
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

    initial
    begin
        // Reset
        clk = 1'b0;

        // lw
        op = 7'b0000011;
        #10;

        // sw
        op = 7'b0100011;
        #8;

        // R-type
        op = 7'b0110011;
        #8;

        // I-type
        op = 7'b0010011;
        #8;

        // jal
        op = 7'b1101111;
        #8;

        // beq
        op = 7'b1100011;
        #6;

        // U-type
        op = 7'b0110111;
        #6;

        $finish;
    end

    always
        #1 clk = !clk;

    // Export results
    initial begin
        $dumpfile("results_fsm.vcd");
        $dumpvars;
    end


endmodule
