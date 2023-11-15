`timescale 1ns/1ps
// tb_extend.v
// Extend
// Authors: Sebastián García
//          Juliana Pineda


module tb_extend();
	reg [24:0] imm;
    reg [2:0] imm_src;
    wire [31:0] imm_ext;

    extend U0(
        .imm(imm),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    initial begin
        imm = 0;

        // I-type
        imm[24:13] = -12'd55;
        imm_src = 3'b000;
        #1;
        
        // S-type
        imm[24:18] = 7'b1010010;
        imm[4:0] = 5'b10111;
        imm_src = 3'b001;
        #1;
        
        // B-type
        imm[24:18] = 7'b1011111;
        imm[4:0] = 5'b10000;
        imm_src = 3'b010;
        #1;
        
        // J-type
        imm[24:5] = 20'd922_000;
        imm_src = 3'b011;
        #1;
        
        // U-type
        imm[24:5] = 20'd5_542;
        imm_src = 3'b100;
        #1;

        $finish;
    end

    // Export results
    initial begin
        $dumpfile("results_extend.vcd");
        $dumpvars;
    end

endmodule