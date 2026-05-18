`timescale 1ns/10ps
// datapath.v — Tiny MIPS multicycle datapath
//
// Key connections (refer to Figure 1 in the spec):
//   PC  → memory address (via adrmux when iord=0)
//   IR  → 4 bytes fetched over 4 cycles via ir0–ir3 flopen registers
//   A   → holds rd1 after decode
//   B   → held in writedata flop (also the SB store value)
//   ALUOut → holds ALU result across cycles
//   MDR → holds memory read data (md)

module datapath (clk, reset, memdata,
                 alusrca, memtoreg, iord, pcen,
                 regwrite, regdst,
                 pcsource, alusrcb,
                 irwrite, alucont,
                 zero, instr, adr, writedata);

    input        clk, reset;
    input  [7:0] memdata;
    input        alusrca, memtoreg, iord, pcen, regwrite, regdst;
    input  [1:0] pcsource, alusrcb;
    input  [3:0] irwrite;
    input  [2:0] alucont;

    output        zero;
    output [31:0] instr;
    output  [7:0] adr, writedata;

    // Internal constants
    parameter CONST_ZERO = 8'b0;
    parameter CONST_ONE  = 8'b1;

    // Internal wires
    wire [2:0] ra1, ra2, wa;
    wire [7:0] pc, nextpc, md;
    wire [7:0] rd1, rd2, wd;
    wire [7:0] a;           // registered rs value
    wire [7:0] src1, src2;
    wire [7:0] aluresult, aluout;
    wire [7:0] constx4;     // jump target (instr[5:0] << 2)

    // Jump target: low 8 bits of jump address = instr[5:0] concat 00
    assign constx4 = {instr[5:0], 2'b00};

    // ---- Register file address mux ----
    // RegDst=0: write to RT (instr[18:16])
    // RegDst=1: write to RD (instr[13:11])
    mux23 regmux (instr[18:16], instr[13:11], regdst, wa);

    // Read addresses always from instruction fields
    assign ra1 = instr[23:21];  // RS field
    assign ra2 = instr[18:16];  // RT field

    // ---- Instruction register (4 bytes, byte-addressable memory) ----
    flopen ir0 (clk, irwrite[0], memdata, instr[31:24]);
    flopen ir1 (clk, irwrite[1], memdata, instr[23:16]);
    flopen ir2 (clk, irwrite[2], memdata, instr[15:8]);
    flopen ir3 (clk, irwrite[3], memdata, instr[7:0]);

    // ---- Program Counter ----
    flopenr pcreg (clk, reset, pcen, nextpc, pc);

    // ---- Memory Data Register (MDR) ----
    flop mdr (clk, memdata, md);

    // ---- A register: latches RS value after decode ----
    flop areg (clk, rd1, a);

    // ---- B/WriteData register: latches RT value ----
    flop wrd (clk, rd2, writedata);

    // ---- ALUOut register: holds result between cycles ----
    flop res (clk, aluresult, aluout);

    // ---- Address mux: PC (normal) or ALUOut (data access) ----
    mux2 adrmux (pc, aluout, iord, adr);

    // ---- ALU source A: PC or register A ----
    mux2 src1mux (pc, a, alusrca, src1);

    // ---- ALU source B mux ----
    // 00=writedata(rd2)  01=CONST_ONE  10=sign-ext imm  11=imm<<2
    mux4 src2mux (writedata, CONST_ONE, instr[7:0], constx4, alusrcb, src2);

    // ---- PC next mux ----
    // 00=ALUResult(PC+1)  01=ALUOut(branch target)  10=constX4(jump)  11=unused
    mux4 pcmux (aluresult, aluout, constx4, CONST_ZERO, pcsource, nextpc);

    // ---- Write-data mux for register file ----
    // 0=ALUOut  1=MDR (load)
    mux2 wdmux (aluout, md, memtoreg, wd);

    // ---- Register file ----
    regfile rf (clk, regwrite, ra1, ra2, wa, wd, rd1, rd2);

    // ---- ALU ----
    alu alunit (src1, src2, alucont, aluresult);

    // ---- Zero detector ----
    zerodetect zd (aluresult, zero);

endmodule
