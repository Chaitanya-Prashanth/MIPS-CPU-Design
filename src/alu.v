`timescale 1ns/10ps
// alu.v — 8-bit ALU for Tiny MIPS CPU
// Operations selected by alucont[2:0]:
//   000 = AND
//   001 = OR
//   010 = ADD
//   011 = unused (treat as ADD)
//   100 = unused
//   101 = unused
//   110 = SUB  (a - b)
//   111 = SLT  (set less than: 1 if a < b signed, else 0)

module alu (a, b, alucont, result);
    input  [7:0] a, b;
    input  [2:0] alucont;
    output [7:0] result;

    reg  [7:0] result;
    wire [7:0] b2;    // b or ~b depending on subtract/slt
    wire [7:0] sum;   // adder output
    wire [7:0] slt;   // set-less-than result

    // For SUB and SLT, invert b and add 1 (two's complement)
    assign b2  = alucont[2] ? ~b : b;
    assign sum = a + b2 + (alucont[2] ? 8'b1 : 8'b0);

    // SLT: 1 if result is negative (MSB set), else 0
    assign slt = {7'b0, sum[7]};

    always @(*) begin
        case (alucont)
            3'b000: result = a & b;    // AND
            3'b001: result = a | b;    // OR
            3'b010: result = sum;      // ADD
            3'b011: result = sum;      // ADD (spare)
            3'b100: result = a & b;    // spare — AND
            3'b101: result = a | b;    // spare — OR
            3'b110: result = sum;      // SUB  (b2 = ~b, carry-in = 1)
            3'b111: result = slt;      // SLT
            default: result = 8'b0;
        endcase
    end
endmodule
