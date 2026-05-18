`timescale 1ns/10ps
// ram.v — 256-byte unified instruction/data memory
// NOTE: behavioral model for simulation only — does NOT synthesize.
// Reads ram.dat on startup (binary format, one byte per line).

module ram (memdata, memwrite, adr, writedata, clk);
    output reg [7:0] memdata;
    input            memwrite;
    input      [7:0] adr;
    input      [7:0] writedata;
    input            clk;

    reg [7:0] mips_ram [0:255];

    integer i, k;

    initial begin
        // Zero-initialize all memory
        for (i = 0; i < 256; i = i + 1)
            mips_ram[i] = 8'b0;
        $display("RAM: Initialized to zero.");

        // Load program from file
        $readmemb("ram.dat", mips_ram);
        $display("RAM: Loaded ram.dat");

        $display("RAM: Contents:");
        for (k = 0; k < 32; k = k + 1)
            $display("  [%0d] = %08b  (0x%02h)", k, mips_ram[k], mips_ram[k]);
    end

    // Clocked read/write — active on negedge to give datapath time to settle
    always @(negedge clk) begin
        if (memwrite) begin
            mips_ram[adr] = writedata;
            $writememb("ram.after.dat", mips_ram);
        end
        memdata <= mips_ram[adr];
    end

endmodule
