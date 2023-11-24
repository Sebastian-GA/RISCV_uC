`timescale 1ns/1ps
// tb_data_memory.v
// Data Memory
// Authors: Sebastián García
//          Juliana Pineda


module tb_data_memory();
    localparam N = 8;
    
    reg clk;
    reg [N-1:0] A;
    reg [31:0] WD;
    reg WE;

    wire [31:0] RD;

    data_memory U0 (
        .clk(clk),
        .A(A),
        .WD(WD),
        .WE(WE),
        .RD(RD)
    );

    initial begin
        // reset
        clk = 0;
        A = 0;
        WE = 0;
        WD = 0;

        // Test 1:
        // Save number in address 22
        WE = 1;
        WD = 32'h2B345FD4;
        A = 32'd22;
        #4;

        // Test 2:
        // Read number from address 22
        #1;  // Don't sincronize with clock
        A = 32'd22;

        // Test 3:
        // Disable write
        WE = 0;
        WD = 32'hA391FFC3;
        A = 32'd2;
        #4;

        $finish;
    end

    always
        #2 clk = ~clk;

    // Export results
    initial begin
        $dumpfile("results_data_memory.vcd");
        $dumpvars;
    end

endmodule