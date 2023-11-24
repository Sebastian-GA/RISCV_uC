`timescale 1ns/1ps
// tb_register_file.v
// Register file
// Authors: Sebastián García
//          Juliana Pineda


module tb_register_file();
    reg clk;
    reg [4:0] A1;
    reg [4:0] A2;
    reg [4:0] A3;
    reg WE3;
    reg [31:0] WD3;

    wire [31:0] RD1;
    wire [31:0] RD2;

    register_file U0 (
        .clk(clk),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WE3(WE3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    initial begin
        // reset
        clk = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WE3 = 0;
        WD3 = 0;

        // Test 1:
        // Save number in register 5
        WE3 = 1;
        WD3 = 32'h2B345FD4;
        A3 = 5'd5;
        #4;

        // Test 2:
        // Read number from register 5
        #1;  // Don't sincronize with clock
        A1 = 5'd5;
        A2 = 5'd5;

        // Test 3:
        // Disable write in A3
        WE3 = 0;
        WD3 = 32'hA391FFC3;
        A3 = 5'd10;
        #4;

        // Test 4:
        // Verify Test 3. Read number from register 10
        A1 = 5'd10;
        #4;

        $finish;
    end

    always
        #2 clk = ~clk;

    // Export results
    initial begin
        $dumpfile("results_register_file.vcd");
        $dumpvars;
    end

endmodule