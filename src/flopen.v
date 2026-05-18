`timescale 1ns/10ps
// flopen.v — 8-bit D flip-flop with synchronous enable
module flopen (clk, en, d, q);
    input            clk, en;
    input      [7:0] d;
    output reg [7:0] q = 0;

  
    always @(posedge clk) begin
   	        if (en) q <= d;
		else q <= q;
	end
endmodule
