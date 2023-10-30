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
    localparam A_TIMER1 = 12;
    localparam A_PWM0 = 16;
    localparam A_ADOUT = 20;
    localparam A_7SEG = 24;

    localparam N_OUTPUTS = 16;

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
        .WD(WD[N_OUTPUTS-1:0]),
        .WE(WE_dout),
        .RD(RD_dout)
    );

    // Timer0
    wire WE_timer0;
    assign WE_timer0 = WE && (A == A_TIMER0);
    wire [31:0] RD_timer0;
    timer #(0) timer0(
        .clk(clk),
        .WD(WD[31:0]),
        .WE(WE_timer0),
        .RD(RD_timer0)
    );

    // Timer1
    wire WE_timer1;
    assign WE_timer1 = WE && (A == A_TIMER1);
    wire [31:0] RD_timer1;
    timer #(50_000) timer1(
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

    // Analog or Digital output
    wire WE_adout;
    assign WE_adout = WE && (A == A_ADOUT);
    wire [31:0] RD_adout;
    analog_or_digital_out #(N_OUTPUTS) analog_or_digital_out(
        .clk(clk),
        .WD(WD[N_OUTPUTS-1:0]),
        .WE(WE_adout),
        .DOUT(RD_dout[N_OUTPUTS-1:0]),
        .PWM(PWM0),
        .led(led),
        .RD(RD_adout)
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
            A_TIMER1: RD = RD_timer1;
            A_PWM0: RD = RD_pwm0;
            A_ADOUT: RD = RD_adout;
            A_7SEG: RD = RD_7seg;
            default: RD = 0;
        endcase

endmodule
