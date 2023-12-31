`timescale 1ns / 1ps
// bin_to_7seg.v
// Binary to 7-segment hex converter
// Author: Sebastian Garcia


module bin_to_7seg(
    input [3:0] num,
    output reg [6:0] hex
);

    always @(*)
        case (num)
            4'd0:  hex = 7'b1000000;
            4'd1:  hex = 7'b1111001;
            4'd2:  hex = 7'b0100100;
            4'd3:  hex = 7'b0110000;
            4'd4:  hex = 7'b0011001;
            4'd5:  hex = 7'b0010010;
            4'd6:  hex = 7'b0000010;
            4'd7:  hex = 7'b1111000;
            4'd8:  hex = 7'b0000000;
            4'd9:  hex = 7'b0011000;
            4'd10: hex = 7'b0001000;
            4'd11: hex = 7'b0000011;
            4'd12: hex = 7'b1000110;
            4'd13: hex = 7'b0100001;
            4'd14: hex = 7'b0000110;
            4'd15: hex = 7'b0001110;
        endcase

endmodule
