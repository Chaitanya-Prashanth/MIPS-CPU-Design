`timescale 1ns/10ps
// mux23.v — 3-bit 2-to-1 multiplexer (for register address selection)
module mux23 (d0, d1, s, y);
    input        s;
    input  [2:0] d0, d1;
    output [2:0] y;

    assign y = s ? d1 : d0;
endmodule
