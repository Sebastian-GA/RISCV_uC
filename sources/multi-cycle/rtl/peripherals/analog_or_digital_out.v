`timescale 1ps/1ps
// analog_or_digital_out.v
// Analog or Digital output
// Author: Sebastian Garcia


module analog_or_digital_out
(
    input clk,
    input [19:0] WD,
    input WE,

    input [19:0] DOUT,
    input PWM,

    output [15:0] led,
    output [3:0] opin,
    output [31:0] RD
);

    // Peripheral register
    reg [19:0] ad_outputs = 0;
    assign RD = ad_outputs;

    // Assign output
    // For each led, select digital output or pwm depending on value on ad_outputs
    // If ad_outputs[i] == 1, then the output is pwm
    // If ad_outputs[i] == 0, then the output is digital
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: loop_leds
            assign led[i] = ad_outputs[i] ? PWM : DOUT[i];
        end
        for (i = 16; i < 20; i = i + 1) begin: loop_opins
            assign opin[i-16] = ad_outputs[i] ? PWM : DOUT[i];
        end
    endgenerate

    always @(posedge clk) begin
        ad_outputs <= WE ? WD[19:0] : ad_outputs;
    end

endmodule