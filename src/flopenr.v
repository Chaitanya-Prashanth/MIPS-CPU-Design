`timescale 1ns/10ps
// flopenr.v — 8-bit D flip-flop with synchronous enable and synchronous reset
module flopenr (clk, reset, en, d, q);
    input            clk, reset, en;
    input      [7:0] d;
    output reg [7:0] q;

    always @(posedge clk)
        if      (reset) q <= 8'b0;
        else if (en)    q <= d;
	else q<=q;
endmodule
