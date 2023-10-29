`timescale 1ns / 1ps
// peripherals.v
// Peripherals
// Authors: Sebastian Garcia
//          Juliana Pineda


module peripherals
(
    input clk,
    input [3:0] A,
    input [31:0] WD,
    input WE,

    output reg [31:0] RD,

    // Peripherals
    input [4:0] btn,
    input [15:0] sw,

    output [15:0] led,
    output [6:0] HEX,
    output [3:0] HEX_Selector
);

    // Peripherals modules
    localparam A_DIN = 0;
    localparam A_DOUT = 4;
    localparam A_TIMER0 = 8;
    localparam A_7SEG = 12;

    // Digital input
    wire [31:0] RD_din;
    digital_in digital_in(
        .clk(clk),
        .btn(btn),
        .sw(sw),
        .RD(RD_din)
    );

    // Digital output
    wire WE_dout;
    assign WE_dout = WE && (A == A_DOUT);
    wire [31:0] RD_dout;
    digital_out digital_out(
        .clk(clk),
        .WD(WD[15:0]),
        .WE(WE_dout),
        .led(led),
        .RD(RD_dout)
    );

    // Timer0
    wire WE_timer0;
    assign WE_timer0 = WE && (A == A_TIMER0);
    wire [31:0] RD_timer0;
    timer0 timer0(
        .clk(clk),
        .WD(WD[31:0]),
        .WE(WE_timer0),
        .RD(RD_timer0)
    );

    // Display 7-segment
    wire WE_7seg;
    assign WE_7seg = WE && (A == A_7SEG);
    wire [31:0] RD_7seg;
    peripheral_display_7seg peripheral_display_7seg(
        .clk(clk),
        .WD(WD[20:0]),
        .WE(WE_7seg),
        .display(HEX),
        .selector(HEX_Selector),
        .RD(RD_7seg)
    );

    // Output multiplexer
    always @(*)
        case (A)
            A_DIN: RD = RD_din;
            A_DOUT: RD = RD_dout;
            A_TIMER0: RD = RD_timer0;
            A_7SEG: RD = RD_7seg;
            default: RD = 0;
        endcase

endmodule
