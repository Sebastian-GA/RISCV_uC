`timescale 1ns/1ps
// tb_instr_decoder.v
// Immediate Instruction Decoder
// Authors: Sebastián García
//          Juliana Pineda


module tb_instr_decoder();
    reg [6:0] op;
    wire [2:0] imm_src;

    instr_decoder U0(
        .op(op),
        .imm_src(imm_src)
    );

    initial begin
        // I-type
        op = 7'b0010011;
        #1;

        // S-type
        op = 7'b0100011;
        #1;

        // B-type
        op = 7'b1100011;
        #1;

        // J-type
        op = 7'b1101111;
        #1;

        // U-type
        op = 7'b0110111;
        #1;
        
        $finish;
    end

    // Export results
    initial begin
        $dumpfile("results_instr_decoder.vcd");
        $dumpvars;
    end

endmodule