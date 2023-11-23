`timescale 1ns/1ps
// tb_alu_decoder.v
// ALU Decoder
// Authors: Sebastián García
//          Juliana Pineda


module tb_alu_decoder();
    reg [6:0] input_decoder;
    wire [2:0] alu_control;

    alu_decoder U0(
        .alu_op(input_decoder[6:5]),
        .funct3(input_decoder[4:2]),
        .op_5(input_decoder[1]),
        .funct7_5(input_decoder[0]),
        .alu_control(alu_control)
    );

    initial begin
        // alu_op = 00
        input_decoder = 7'b00_xxx_xx; // Add
        #1;
        
        // alu_op = 01
        input_decoder = 7'b01_xxx_xx;
        #1;

        // alu_op = 10
        input_decoder = 7'b10_000_00; // Add
        #1;
        input_decoder = 7'b10_000_01; // Add
        #1;
        input_decoder = 7'b10_000_10; // Add
        #1;
        input_decoder = 7'b10_000_11; // Substract
        #1;
        input_decoder = 7'b10_010_xx; // SLT
        #1;
        input_decoder = 7'b10_110_xx; // OR
        #1;
        input_decoder = 7'b10_111_xx; // AND
        #1;
        input_decoder = 7'b10_100_xx; // XOR
        #1;
        input_decoder = 7'b10_001_x0; // SLL
        #1;
        input_decoder = 7'b10_101_x0; // SRL
        #1;

        $finish;
    end

    // Export results
    initial begin
        $dumpfile("results_alu_decoder.vcd");
        $dumpvars;
    end

endmodule