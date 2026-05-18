`timescale 1ns/10ps
// tb_flops.v — Self-checking testbench for flop.v, flopen.v, flopenr.v
// 100ns clock period for clear SimVision waveform visibility

module tb_flops;

    reg        clk, en, reset;
    reg  [7:0] d;
    wire [7:0] q_flop, q_flopen, q_flopenr;

    integer errors;

    flop    dut0 (.clk(clk), .d(d), .q(q_flop));
    flopen  dut1 (.clk(clk), .en(en), .d(d), .q(q_flopen));
    flopenr dut2 (.clk(clk), .reset(reset), .en(en), .d(d), .q(q_flopenr));

    // ---- Waveform dump ----
    initial begin
        $shm_open("dump_flops.vcd");
        $shm_probe("AS");
    end

    // ---- 100ns clock (50ns half-period) ----
    initial clk = 0;
    always #50 clk = ~clk;

    task check_val;
        input [7:0] actual, expected;
        input [255:0] name;
        begin
            if (actual === expected)
                $display("PASS | %-40s = %3d (0x%02h)", name, actual, actual);
            else begin
                $display("FAIL | %-40s = %3d (exp %3d)", name, actual, expected);
                errors = errors + 1;
            end
        end
    endtask

    // Apply input before posedge, check after
    task apply_and_check_flop;
        input [7:0] data;
        input [7:0] expected;
        input [255:0] name;
        begin
            @(negedge clk); d = data;  // apply at negedge
            @(posedge clk); #5;        // sample shortly after posedge
            check_val(q_flop, expected, name);
        end
    endtask

    initial begin
        errors = 0;
        d      = 8'd0;
        en     = 1'b0;
        reset  = 1'b0;

        // 3 idle cycles — visible flat region at start of waveform
        repeat(3) @(posedge clk);

        $display("\n=== Flop Testbench ===");

        // ---- flop: always captures ----
        $display("\n-- flop (no enable, no reset) --");
        apply_and_check_flop(8'd42,  8'd42,  "flop: d=42  -> q=42");
        apply_and_check_flop(8'd100, 8'd100, "flop: d=100 -> q=100");
        apply_and_check_flop(8'd0,   8'd0,   "flop: d=0   -> q=0");
        apply_and_check_flop(8'd255, 8'd255, "flop: d=255 -> q=255");

        // 2 idle cycles between sections — visible gap
        repeat(2) @(posedge clk);

        // ---- flopen ----
        $display("\n-- flopen (captures only when en=1) --");

        // en=0: should hold previous value
        @(negedge clk); d = 8'd99; en = 1'b0;
        @(posedge clk); #5;
        check_val(q_flopen, 8'd0, "flopen: en=0 d=99 -> holds 0");

        // en=1: captures
        @(negedge clk); en = 1'b1;
        @(posedge clk); #5;
        check_val(q_flopen, 8'd99, "flopen: en=1 d=99 -> q=99");

        // en=0: holds 99
        @(negedge clk); d = 8'd77; en = 1'b0;
        @(posedge clk); #5;
        check_val(q_flopen, 8'd99, "flopen: en=0 d=77 -> holds 99");

        // en=1: captures 77
        @(negedge clk); en = 1'b1;
        @(posedge clk); #5;
        check_val(q_flopen, 8'd77, "flopen: en=1 d=77 -> q=77");

        repeat(2) @(posedge clk);

        // ---- flopenr ----
        $display("\n-- flopenr (enable + synchronous reset) --");

        // Normal capture
        @(negedge clk); d = 8'd55; en = 1'b1; reset = 1'b0;
        @(posedge clk); #5;
        check_val(q_flopenr, 8'd55, "flopenr: en=1 d=55 -> q=55");

        // Synchronous reset overrides enable and data
        @(negedge clk); d = 8'd99; en = 1'b1; reset = 1'b1;
        @(posedge clk); #5;
        check_val(q_flopenr, 8'd0, "flopenr: reset=1 -> q=0");

        // After reset, en=0 holds zero
        @(negedge clk); d = 8'd33; en = 1'b0; reset = 1'b0;
        @(posedge clk); #5;
        check_val(q_flopenr, 8'd0, "flopenr: en=0 after reset -> holds 0");

        // en=1 captures new value
        @(negedge clk); en = 1'b1;
        @(posedge clk); #5;
        check_val(q_flopenr, 8'd33, "flopenr: en=1 d=33 -> q=33");

        // Final hold — 5 idle cycles visible at end
        repeat(5) @(posedge clk);

        $display("\n=== Flops: %0d error(s) ===", errors);
        if (errors == 0) $display("ALL FLOP TESTS PASSED");
        else             $display("SOME FLOP TESTS FAILED");
        $finish;
    end

endmodule
