`timescale 1ns/1ps
// tb_main_decoder.v
// Main Decoder
// Authors: Sebastián García
//          Juliana Pineda


module tb_main_decoder();
    reg [6:0] op;
    wire [12:0] output_decoder;

    main_decoder U0(
        .op(op),
        .reg_write(output_decoder[12]),
        .imm_src(output_decoder[11:9]),
        .alu_srcA(output_decoder[8]),
        .alu_srcB(output_decoder[7]),
        .mem_write(output_decoder[6]),
        .result_src(output_decoder[5:4]),
        .branch(output_decoder[3]),
        .alu_op(output_decoder[2:1]),
        .jump(output_decoder[0])
    );

    initial begin
        // lw
        op = 7'b0000011;
        #1;
        // sw
        op = 7'b0100011;
        #1;
        // R-type
        op = 7'b0110011;
        #1;
        // beq
        op = 7'b1100011;
        #1;
        // I-type
        op = 7'b0010011;
        #1;
        // jal
        op = 7'b1101111;
        #1;
        // U-type
        op = 7'b0110111;
        #1;
        $finish;
    end

    // Export results
    initial begin
        $dumpfile("results_main_decoder.vcd");
        $dumpvars;
    end

endmodule