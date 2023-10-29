`timescale 1ns / 1ps
// bin_to_7seg.v
// Binary to 7-segment display converter
// Author: Sebastian Garcia


module bin_to_7seg(
    input [3:0] num,
    output reg [6:0] display
);

    always @(*)
        case (num)
            4'd0:  display = 7'b1000000;
            4'd1:  display = 7'b1111001;
            4'd2:  display = 7'b0100100;
            4'd3:  display = 7'b0110000;
            4'd4:  display = 7'b0011001;
            4'd5:  display = 7'b0010010;
            4'd6:  display = 7'b0000010;
            4'd7:  display = 7'b1111000;
            4'd8:  display = 7'b0000000;
            4'd9:  display = 7'b0011000;
            4'd10: display = 7'b0001000;
            4'd11: display = 7'b0000011;
            4'd12: display = 7'b1000110;
            4'd13: display = 7'b0100001;
            4'd14: display = 7'b0000110;
            4'd15: display = 7'b0001110;
        endcase

endmodule
