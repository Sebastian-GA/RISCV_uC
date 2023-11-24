`timescale 1ns/1ps
// tb_instruction_memory.v
// Instruction Memory
// Authors: Sebastián García
//          Juliana Pineda


module tb_instruction_memory();
    localparam N = 8;
    
    reg [N-1:0] A;
    wire [31:0] d_out;

    instruction_memory U0(
        .A(A),
        .RD(d_out)
    );

    initial begin
        A = 0;
        #1;
        
        repeat (10) begin
            A = A + 4;
            #1;
        end
        $finish;
    end

    // Export results
    initial begin
        $dumpfile("results_instruction_memory.vcd");
        $dumpvars;
    end

endmodule