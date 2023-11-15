`timescale 1ns/1ps
// tb_data_memory.v
// Data Memory
// Authors: Sebastián García
//          Juliana Pineda


module tb_data_memory();
    reg clk;
    reg [31:0] A;
    reg [31:0] WD;
    reg WE;

    wire [31:0] RD;

    // Peripherals (not used in this testbench)
    reg [15:0] sw;
    reg [4:0] btn;
    reg [3:0] ipin;

    wire [15:0] led;
    wire [3:0] opin;
    wire [6:0] hex;
    wire hex_dot;
    wire [3:0] hex_sel;

    memory U0 (
        .clk(clk),
        .A(A),
        .WD(WD),
        .WE(WE),
        .RD(RD),
        .sw(sw),
        .btn(btn),
        .ipin(ipin),
        .led(led),
        .opin(opin),
        .hex(hex),
        .hex_dot(hex_dot),
        .hex_sel(hex_sel)
    );

    initial begin
        // reset
        clk = 0;
        A = 32'd0;
        WE = 0;
        WD = 0;

        // Testbench Instruction Memory
        
        // Test 1:
        // Read first instructions
        A = 32'd0;
        #4;
    
        repeat (3) begin
            A = A + 4;
            #4;
        end

        // Test 2:
        // Try to write in instruction memory
        WE = 1;
        WD = 32'h2B345FD4;
        A = 32'd0;
        #4;

        // Testbench Data Memory

        // Test 1:
        // Save number in address 512 (First address of data memory)
        WE = 1;
        WD = 32'h2B345FD4;
        A = 32'd512;
        #4;

        // Test 2:
        // Read number from address 512
        #1;  // Don't sincronize with clock
        A = 32'd512;

        // Test 3:
        // Disable write
        WE = 0;
        WD = 32'hA391FFC3;
        A = 32'd512;
        #4;

        $finish;
    end

    always
        #2 clk = ~clk;

    // Export results
    initial begin
        $dumpfile("results_memory.vcd");
        $dumpvars;
    end

endmodule