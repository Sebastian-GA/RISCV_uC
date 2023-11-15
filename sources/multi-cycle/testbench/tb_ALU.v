`timescale 1ns/1ps
// tb_ALU.v
// ALU
// Authors: Sebastián García
//          Juliana Pineda


module tb_ALU();
    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] alu_control;
    wire [31:0] alu_out;
    wire zero;

    ALU U0(
        .A(A),
        .B(B),
        .alu_control(alu_control),
        .alu_out(alu_out),
        .zero(zero)
    );

    initial begin
        A = $urandom;
        B = $urandom;
        
        // Add
        alu_control = 3'b000;
        #1;

        // Substract
        alu_control = 3'b001;
        #1;

        // AND
        alu_control = 3'b010;
        #1;

        // OR
        alu_control = 3'b011;
        #1;

        // SLL
        alu_control = 3'b100;
        #1;

        // SLT
        alu_control = 3'b101;
        #1;

        // SRL
        alu_control = 3'b110;
        #1;

        // XOR
        alu_control = 3'b111;
        #1;

        // Verify zero flag
        B = A;
        alu_control = 3'b001;  // Substract
        #1;

        $finish;
    end

    // Export results
    initial begin
        $dumpfile("results_ALU.vcd");
        $dumpvars;
    end

endmodule