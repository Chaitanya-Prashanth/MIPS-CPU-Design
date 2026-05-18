`timescale 1ns/10ps
// mips.v — Top-level Tiny MIPS CPU
// Instantiates: controller, alucontrol, datapath

module mips (clk, reset, memdata, memread, memwrite, adr, writedata);
    input        clk, reset;
    input  [7:0] memdata;
    output       memread, memwrite;
    output [7:0] adr, writedata;

    // Internal control wires
    wire [31:0] instr;
    wire        zero;
    wire        alusrca, memtoreg, iord, pcen, regwrite, regdst;
    wire [1:0]  aluop, pcsource, alusrcb;
    wire [3:0]  irwrite;
    wire [2:0]  alucont;

    // Controller: generates all datapath control signals
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

    // ALU control: decodes funct field into ALU opcode
    alucontrol ac (
        .aluop   (aluop),
        .funct   (instr[5:0]),
        .alucont (alucont)
    );

    // Datapath: all registers, ALU, muxes, regfile
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
