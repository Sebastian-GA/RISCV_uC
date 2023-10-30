`timescale 1ns / 1ps
// timer0.v
// Timer0
// Authors: Sebastian Garcia
//         Juliana Pineda


module timer #(parameter F_DIV = 50_000)(
    input clk,
    input [31:0] WD,
    input WE,

    output [31:0] RD
);

    // Peripheral register
    reg [31:0] timer = 0;
    assign RD = timer;

    // Frequency divider
    reg [31:0] f_div_counter = 0;
    wire f_div_enable;
    assign f_div_enable = (f_div_counter == F_DIV) ? 1 : 0;

    always @ (posedge clk) begin
        f_div_counter <= (f_div_enable) ? 0 : f_div_counter + 1;

        timer <= WE ? WD[31:0] : (f_div_enable ? timer + 1 : timer);
    end

endmodule
