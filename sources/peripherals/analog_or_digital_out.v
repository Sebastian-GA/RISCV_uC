`timescale 1ps/1ps
// analog_or_digital_out.v
// Analog or Digital output
// Author: Sebastian Garcia


module analog_or_digital_out #(N_OUTPUTS = 16) (
    input clk,
    input [N_OUTPUTS-1:0] WD,
    input WE,

    input [N_OUTPUTS-1:0] DOUT,
    input PWM,

    output [15:0] led,
    output [31:0] RD
);

    // Peripheral register
    reg [N_OUTPUTS-1:0] ad_outputs = 0;
    assign RD = ad_outputs;

    // Assign output
    // For each led, select digital output or pwm depending on value on ad_outputs
    // If ad_outputs[i] == 1, then the output is pwm
    // If ad_outputs[i] == 0, then the output is digital
    genvar i;
    generate
        for (i = 0; i < N_OUTPUTS; i = i + 1) begin: loop_outputs
            assign led[i] = ad_outputs[i] ? PWM : DOUT[i];
        end
    endgenerate

    always @(posedge clk) begin
        ad_outputs <= WE ? WD[N_OUTPUTS-1:0] : ad_outputs;
    end

endmodule