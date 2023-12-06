`timescale 1ns / 1ps
// peripherals.v
// Peripherals
// Authors: Sebastian Garcia
//          Juliana Pineda


module peripherals
(
    input clk,
    input [4:0] A,
    input [31:0] WD,
    input WE,

    output reg [31:0] RD,

    // Peripherals
    input [15:0] sw,
    input [4:0] btn,
    input [3:0] ipin,

    output [15:0] led,
    output [3:0] opin,
    output [6:0] hex,
    output hex_dot,
    output [3:0] hex_sel
);

    // Peripherals modules
    localparam A_DIN = 0;
    localparam A_DOUT = 4;
    localparam A_TIMER0 = 8;
    localparam A_TIMER1 = 12;
    localparam A_PWM0 = 16;
    localparam A_OUTM = 20;
    localparam A_7SEG = 24;

    localparam N_OUTPUTS = 20;

    // Digital input
    wire [31:0] RD_din;
    digital_in digital_in(
        .clk(clk),
        .sw(sw),
        .btn(btn),
        .ipin(ipin),
        .RD(RD_din)
    );

    // Digital output
    wire WE_dout;
    assign WE_dout = WE && (A == A_DOUT);
    wire [31:0] RD_dout;
    digital_out digital_out(
        .clk(clk),
        .WD(WD[19:0]),
        .WE(WE_dout),
        .RD(RD_dout)
    );

    // Timer0 (micros)
    wire WE_timer0;
    assign WE_timer0 = WE && (A == A_TIMER0);
    wire [31:0] RD_timer0;
    timer #(118) timer0(
        .clk(clk),
        .WD(WD[31:0]),
        .WE(WE_timer0),
        .RD(RD_timer0)
    );

    // Timer1 (millis)
    wire WE_timer1;
    assign WE_timer1 = WE && (A == A_TIMER1);
    wire [31:0] RD_timer1;
    timer #(117_647) timer1(
        .clk(clk),
        .WD(WD[31:0]),
        .WE(WE_timer1),
        .RD(RD_timer1)
    );

    // PWM0
    wire WE_pwm0;
    assign WE_pwm0 = WE && (A == A_PWM0);
    wire [31:0] RD_pwm0;
    wire PWM0;
    pwm pwm0(
        .clk(clk),
        .WD(WD[6:0]),
        .WE(WE_pwm0),
        .PWM(PWM0),
        .RD(RD_pwm0)
    );

    // Output mode
    wire WE_outm;
    assign WE_outm = WE && (A == A_OUTM);
    wire [31:0] RD_outm;
    out_mode out_mode(
        .clk(clk),
        .WD(WD[19:0]),
        .WE(WE_outm),
        .DOUT(RD_dout[19:0]),
        .PWM(PWM0),
        .led(led),
        .opin(opin),
        .RD(RD_outm)
    );

    // Display 7-segment
    wire WE_7seg;
    assign WE_7seg = WE && (A == A_7SEG);
    wire [31:0] RD_7seg;
    peripheral_display_7seg peripheral_display_7seg(
        .clk(clk),
        .WD(WD[24:0]),
        .WE(WE_7seg),
        .hex(hex),
        .hex_dot(hex_dot),
        .hex_sel(hex_sel),
        .RD(RD_7seg)
    );

    // Output multiplexer
    always @(*)
        case (A)
            A_DIN: RD = RD_din;
            A_DOUT: RD = RD_dout;
            A_TIMER0: RD = RD_timer0;
            A_TIMER1: RD = RD_timer1;
            A_PWM0: RD = RD_pwm0;
            A_OUTM: RD = RD_outm;
            A_7SEG: RD = RD_7seg;
            default: RD = 0;
        endcase

endmodule
