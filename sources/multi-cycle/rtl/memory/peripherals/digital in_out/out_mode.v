`timescale 1ps/1ps
// out_mode.v
// Output Mode
// Author: Sebastian Garcia


module out_mode
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
    reg [19:0] outputs_mode = 0;
    assign RD = outputs_mode;

    // Assign output
    // For each led/opin, select digital output or pwm depending on value on outputs_mode
    // If outputs_mode[i] == 1, then the output is pwm
    // If outputs_mode[i] == 0, then the output is digital
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: loop_leds
            assign led[i] = outputs_mode[i] ? PWM : DOUT[i];
        end
        for (i = 16; i < 20; i = i + 1) begin: loop_opins
            assign opin[i-16] = outputs_mode[i] ? PWM : DOUT[i];
        end
    endgenerate

    always @(posedge clk) begin
        outputs_mode <= WE ? WD[19:0] : outputs_mode;
    end

endmodule