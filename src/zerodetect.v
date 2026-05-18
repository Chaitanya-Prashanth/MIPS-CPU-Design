`timescale 1ns/10ps
// zerodetect.v — asserts y=1 when all bits of a are zero
module zerodetect (a, y);
    input  [7:0] a;
    output       y;

    assign y = (a == 8'b0);
endmodule
