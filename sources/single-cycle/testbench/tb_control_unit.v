`timescale 1ns/1ps
// tb_control_unit.v
// Control Unit
// Authors: Sebastián García
//          Juliana Pineda


module tb_control_unit();
    reg [6:0] op;
    reg [2:0] funct3;
    reg funct7_5;
    reg zero;

    wire [12:0] control_unit_output;

    control_unit U0(
        .op(op),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .zero(zero),
        
        .pc_src(control_unit_output[12]),
        .result_src(control_unit_output[11:10]),
        .mem_write(control_unit_output[9]),
        .alu_control(control_unit_output[8:6]),
        .alu_srcA(control_unit_output[5]),
        .alu_srcB(control_unit_output[4]),
        .imm_src(control_unit_output[3:1]),
        .reg_write(control_unit_output[0])
    );

    initial begin
        // Reset values
        op = 0;
        funct3 = 0;
        funct7_5 = 0;

        // Test pc_src
        zero = 0;

        repeat (2) begin
            // R-type
            // branch = 0; jump = 0;
            op = 7'b0110011;
            #1;

            // beq
            // branch = 1; jump = 0;
            op = 7'b1100011;
            #1;

            // jal
            // branch = 0; jump = 1;
            op = 7'b1101111;
            #1;

            // next iteration change zero = 1
            zero = 1;
        end

        $finish;
    end

    // Export results
    initial begin
        $dumpfile("results_control_unit.vcd");
        $dumpvars;
    end

endmodule
