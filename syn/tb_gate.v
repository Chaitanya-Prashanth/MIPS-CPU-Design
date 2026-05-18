`timescale 1ns/10ps
// tb_gate.v — Gate-level simulation testbench
// Used AFTER synthesis to verify the netlist behaves identically to RTL.
//
// How to run (Icarus Verilog example):
//   iverilog -o sim_gate \
//       ../output/mips_netlist.v \    <- synthesized netlist
//       /path/to/library/cells.v \   <- library cell models (ask TA for path)
//       ram.v tb_gate.v
//   vvp sim_gate
//
// The expected results are identical to tb_mips.v (RTL sim):
//   mem[255] = 3  after sb completes
//   $s1=3, $s2=1, $s3=2 in register file

`include "../output/mips_netlist.v"

module tb_gate;

    reg        clk, reset;
    wire       memread, memwrite;
    wire [7:0] adr, writedata;
    wire [7:0] memdata;

    // Instantiate gate-level netlist (same port names as RTL)
    mips dut (
        .clk       (clk),
        .reset     (reset),
        .memdata   (memdata),
        .memread   (memread),
        .memwrite  (memwrite),
        .adr       (adr),
        .writedata (writedata)
    );

    // Behavioral RAM (not synthesized)
    ram mem (
        .memdata   (memdata),
        .memwrite  (memwrite),
        .adr       (adr),
        .writedata (writedata),
        .clk       (clk)
    );

    // Clock
    initial clk = 0;
    always  #5 clk = ~clk;

    integer errors;
    integer cycle_count;

    initial begin
        errors      = 0;
        cycle_count = 0;
        reset       = 1;
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;
        $display("=== Gate-level simulation started ===");
    end

    always @(posedge clk)
        if (!reset) cycle_count = cycle_count + 1;

    // Watch for SB to complete
    always @(negedge clk) begin
        if (!reset && memwrite && adr == 8'd255) begin
            $display("[cyc %0d] SB to mem[255] = %0d (expect 3)", cycle_count, writedata);
            if (writedata == 8'd3)
                $display("PASS: Gate-level result correct.");
            else begin
                $display("FAIL: Expected 3, got %0d", writedata);
                errors = errors + 1;
            end
            #10;
            if (errors == 0)
                $display("GATE-LEVEL SIM: ALL PASSED");
            else
                $display("GATE-LEVEL SIM: %0d FAILURES", errors);
            $finish;
        end
    end

    // Timeout
    initial begin
        #10000;
        $display("TIMEOUT after %0d cycles", cycle_count);
        $finish;
    end

    initial begin
        $dumpfile("gate_waves.vcd");
        $dumpvars(0, tb_gate);
    end

endmodule
