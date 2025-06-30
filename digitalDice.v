`timescale 1ns / 1ps
// LFSR-based 3-bit random number generator
module lfsr_random(
    input clk,
    input reset,
    output reg [2:0] rand_num = 3'b001
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            rand_num <= 3'b001;
        else
            rand_num <= {rand_num[1:0], rand_num[2] ^ rand_num[0]};
    end
endmodule


// Mapping LFSR output to dice number 1 to 6
module dice_number(
    input [2:0] rand_num,
    output reg [2:0] dice_out
);
    always @(*) begin
        case(rand_num % 6)
            3'd0: dice_out = 3'd1;
            3'd1: dice_out = 3'd2;
            3'd2: dice_out = 3'd3;
            3'd3: dice_out = 3'd4;
            3'd4: dice_out = 3'd5;
            3'd5: dice_out = 3'd6;
            default: dice_out = 3'd1;
        endcase
    end
endmodule

module seven_seg_decoder(
    input [2:0] dice_out,
    output reg [6:0] seg
);
    always @(*) begin
        case(dice_out)
            3'd1: seg = 7'b0000110;
            3'd2: seg = 7'b1011011;
            3'd3: seg = 7'b1001111;
            3'd4: seg = 7'b1100110;
            3'd5: seg = 7'b1101101;
            3'd6: seg = 7'b1111101;
            default: seg = 7'b0000001;  // Blank/default
        endcase
    end
endmodule


// Top-level Module without 7-segment, outputs only dice number
module digital_dice_top(
    input clk, 
    input reset,
    input btn,          // New button input
    output reg [2:0] dice_out,
    output [6:0] seg
);
    wire [2:0] rand_num;
    reg [2:0] dice_temp;

    lfsr_random lfsr(
        .clk(clk), 
        .reset(reset), 
        .rand_num(rand_num)
    );

    dice_number dice(
        .rand_num(rand_num), 
        .dice_out(dice_temp)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            dice_out <= 3'd1;  // Default output
        else if (btn)
            dice_out <= dice_temp;  // Update only when button is pressed
        else
            dice_out <= dice_out;   // Hold previous value
    end

      seven_seg_decoder segdec(
          .dice_out(dice_out),
          .seg(seg)
      );

endmodule

