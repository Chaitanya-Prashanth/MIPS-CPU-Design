`timescale 1ns/10ps
// tb_zerodetect.v — Self-checking testbench for zerodetect.v
// Delays scaled for SimVision waveform visibility

module tb_zerodetect;

    reg  [7:0] a;
    wire       y;
    integer    errors;

    zerodetect dut (.a(a), .y(y));

    // ---- Waveform dump ----
    initial begin
        $shm_open("dump_zerodetect.shm");
        $shm_probe("AS");
    end

    // ---- Clock: 100ns period ----
    reg clk;
    initial clk = 0;
    always #50 clk = ~clk;

    task check;
        input [7:0] in_a;
        input       expected;
        input [255:0] name;
        begin
            @(negedge clk);
            a = in_a;
            @(posedge clk); #5;
            if (y === expected)
                $display("PASS | %-20s | a=0x%02h (%08b) | y=%0b",
                         name, in_a, in_a, y);
            else begin
                $display("FAIL | %-20s | a=0x%02h (%08b) | y=%0b (exp %0b)",
                         name, in_a, in_a, y, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;
        a      = 8'hFF;   // start non-zero so first transition is visible

        @(posedge clk);
        @(posedge clk);

        $display("\n=== ZeroDetect Testbench ===");

        check(8'h00, 1, "zero_all_zeros");
        check(8'h01, 0, "nonzero_LSB");
        check(8'hFF, 0, "nonzero_all_ones");
        check(8'h80, 0, "nonzero_MSB_only");
        check(8'h00, 1, "zero_again");
        check(8'hAA, 0, "nonzero_AA");
        check(8'h55, 0, "nonzero_55");
        check(8'h0F, 0, "nonzero_0F");
        check(8'hF0, 0, "nonzero_F0");
        check(8'h00, 1, "zero_final");

        repeat(5) @(posedge clk);

        $display("\n=== ZeroDetect: %0d error(s) ===", errors);
        if (errors == 0) $display("ALL ZERODETECT TESTS PASSED");
        else             $display("SOME ZERODETECT TESTS FAILED");
        $finish;
    end

endmodule
