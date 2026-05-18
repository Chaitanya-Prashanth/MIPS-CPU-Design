`timescale 1ns/10ps
// regfile.v — 8x8-bit register file ($zero hardwired to 0, $s0–$s7)
//
// Register address mapping (3-bit):
//   000 = $zero  (hardwired 0)
//   001 = $s0
//   010 = $s1
//   011 = $s2
//   100 = $s3
//   101 = $s4
//   110 = $s5
//   111 = $s6
//
// In the instruction encoding used by this Tiny MIPS, the register
// field instr[20:16] maps as: $s0=00000, $s1=00001 ... $s7=00111
// The datapath uses only bits [2:0] of those fields (ra1, ra2, wa).

module regfile (clk, regwrite, ra1, ra2, wa, wd, rd1, rd2);
    input            clk;
    input            regwrite;
    input      [2:0] ra1, ra2, wa;
    input      [7:0] wd;
    output     [7:0] rd1, rd2;

    // 8 registers of 8 bits each
    reg [7:0] REGS [7:0];

    // Synchronous write
    always @(posedge clk)
        if (regwrite && wa != 3'b000)   // never write $zero
            REGS[wa] <= wd;

    // Asynchronous read; $zero always returns 0
    assign rd1 = (ra1 == 3'b000) ? 8'b0 : REGS[ra1];
    assign rd2 = (ra2 == 3'b000) ? 8'b0 : REGS[ra2];

endmodule
