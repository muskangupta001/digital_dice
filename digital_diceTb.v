`timescale 1ns / 1ps

module tb_digital_dice;

    reg clk;
    reg reset;
    reg btn; // Button signal
    wire [2:0] dice_out;
    wire [6:0] seg;

    digital_dice_top uut (
        .clk(clk),
        .reset(reset),
        .btn(btn),
        .dice_out(dice_out)
        .seg(seg)
    );

    always #50 clk = ~clk;  // 10 MHz clock

    initial begin
        $dumpfile("dice_waveform.vcd");
        $dumpvars(0, tb_digital_dice);

        clk = 0;
        reset = 1;
        btn = 0;

        #100;
        reset = 0;

        // Simulate button presses
        #300; btn = 1; #100; btn = 0; // Press 1
        #500; btn = 1; reset = 1; #100; btn = 0; reset = 0; // Press 2
        #700; btn = 1; #100; btn = 0; // Press 3
      #850; btn = 1; #100; btn = 0; // Press 1
      #950; btn = 1; #100; btn = 0; // Press 1
      #1050; btn = 1; #100; btn = 0; // Press 1
      #1150; btn = 1; #100; btn = 0; // Press 1

        #2000;

        $finish;
    end

endmodule
