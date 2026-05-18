`timescale 1ns/10ps
// mips_scan.v — Top-level MIPS with scan ports added for DFT
// This is the version to use with dft_scan.tcl
// DC's insert_dft will internally wire scan_in → scan chain → scan_out
// You do NOT need to manually wire the chain — DC does it automatically.
// This file just adds the three scan ports to the module boundary.

module mips (clk, reset,
             memdata, memread, memwrite, adr, writedata,
             scan_in, scan_out, scan_en, test_mode);

    input        clk, reset;
    input  [7:0] memdata;
    output       memread, memwrite;
    output [7:0] adr, writedata;

    // DFT scan ports
    input        scan_in;
    output       scan_out;
    input        scan_en;
    input        test_mode;

    // Internal wires (identical to mips.v)
    wire [31:0] instr;
    wire        zero;
    wire        alusrca, memtoreg, iord, pcen, regwrite, regdst;
    wire [1:0]  aluop, pcsource, alusrcb;
    wire [3:0]  irwrite;
    wire [2:0]  alucont;

    controller cont (
        .clk      (clk),
        .reset    (reset),
        .op       (instr[31:26]),
        .zero     (zero),
        .memread  (memread),
        .memwrite (memwrite),
        .alusrca  (alusrca),
        .memtoreg (memtoreg),
        .iord     (iord),
        .pcen     (pcen),
        .regwrite (regwrite),
        .regdst   (regdst),
        .pcsource (pcsource),
        .alusrcb  (alusrcb),
        .aluop    (aluop),
        .irwrite  (irwrite)
    );

    alucontrol ac (
        .aluop   (aluop),
        .funct   (instr[5:0]),
        .alucont (alucont)
    );

    datapath dp (
        .clk       (clk),
        .reset     (reset),
        .memdata   (memdata),
        .alusrca   (alusrca),
        .memtoreg  (memtoreg),
        .iord      (iord),
        .pcen      (pcen),
        .regwrite  (regwrite),
        .regdst    (regdst),
        .pcsource  (pcsource),
        .alusrcb   (alusrcb),
        .irwrite   (irwrite),
        .alucont   (alucont),
        .zero      (zero),
        .instr     (instr),
        .adr       (adr),
        .writedata (writedata)
    );

endmodule
