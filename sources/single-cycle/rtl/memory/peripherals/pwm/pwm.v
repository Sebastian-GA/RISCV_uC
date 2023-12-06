`timescale 1ps/1ps
// pwm.v
// PWM module at 1kHz
// Author: Sebastian Garcia


module pwm (
    input clk,
    input [6:0] WD,
    input WE,

    output reg PWM,
    output [31:0] RD
);

    // Peripheral register
    reg [6:0] pwm_duty_cycle;
    assign RD = pwm_duty_cycle;

    // PWM signal
    reg [6:0] pwm_counter = 0;

    // Frequency divider
    localparam F_DIV = 1_176;
    reg [10:0] f_div_counter = 0;
    wire f_div_enable;
    assign f_div_enable = (f_div_counter == F_DIV) ? 1 : 0;

    always @ (posedge clk) begin
        pwm_duty_cycle <= WE ? WD[6:0] : pwm_duty_cycle;

        f_div_counter <= (f_div_enable) ? 0 : f_div_counter + 1;
        pwm_counter <= f_div_enable ? ((pwm_counter == 100) ? 0: pwm_counter + 1) : pwm_counter;

        PWM <= (pwm_counter >= pwm_duty_cycle) ? 0 : 1;
    end

    
endmodule
