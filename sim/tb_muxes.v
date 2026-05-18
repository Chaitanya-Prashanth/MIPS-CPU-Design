`timescale 1ns/10ps
// tb_muxes.v — Self-checking testbench for mux2.v, mux4.v, mux23.v
// Delays scaled for SimVision waveform visibility

module tb_muxes;

    // mux2
    reg        s2;
    reg  [7:0] d0_2, d1_2;
    wire [7:0] y2;

    // mux4
    reg  [1:0] s4;
    reg  [7:0] d0_4, d1_4, d2_4, d3_4;
    wire [7:0] y4;

    // mux23
    reg        s23;
    reg  [2:0] d0_23, d1_23;
    wire [2:0] y23;

    integer errors;

    mux2  dut0 (.d0(d0_2),  .d1(d1_2),  .s(s2),  .y(y2));
    mux4  dut1 (.d0(d0_4),  .d1(d1_4),  .d2(d2_4), .d3(d3_4), .s(s4), .y(y4));
    mux23 dut2 (.d0(d0_23), .d1(d1_23), .s(s23), .y(y23));

    // ---- Waveform dump ----
    initial begin
        $shm_open("dump_muxes.shm");
        $shm_probe("AS");
    end

    // ---- Clock: 100ns period ----
    reg clk;
    initial clk = 0;
    always #50 clk = ~clk;

    task check8;
        input [7:0] actual, expected;
        input [255:0] name;
        begin
            if (actual === expected)
                $display("PASS | %-28s = 0x%02h (%3d)", name, actual, actual);
            else begin
                $display("FAIL | %-28s = 0x%02h (exp 0x%02h)", name, actual, expected);
                errors = errors + 1;
            end
        end
    endtask

    task check3;
        input [2:0] actual, expected;
        input [255:0] name;
        begin
            if (actual === expected)
                $display("PASS | %-28s = %03b", name, actual);
            else begin
                $display("FAIL | %-28s = %03b (exp %03b)", name, actual, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors  = 0;
        s2      = 0; d0_2   = 0;   d1_2   = 0;
        s4      = 0; d0_4   = 0;   d1_4   = 0; d2_4 = 0; d3_4 = 0;
        s23     = 0; d0_23  = 0;   d1_23  = 0;

        @(posedge clk);
        @(posedge clk);

        $display("\n=== Mux Testbench ===");

        // ---- mux2 ----
        $display("\n-- mux2 --");
        d0_2 = 8'd10; d1_2 = 8'd20;
        @(negedge clk); s2 = 0; @(posedge clk); #5; check8(y2, 8'd10,  "mux2 s=0->d0(10)");
        @(negedge clk); s2 = 1; @(posedge clk); #5; check8(y2, 8'd20,  "mux2 s=1->d1(20)");

        d0_2 = 8'hAA; d1_2 = 8'h55;
        @(negedge clk); s2 = 0; @(posedge clk); #5; check8(y2, 8'hAA,  "mux2 s=0->0xAA");
        @(negedge clk); s2 = 1; @(posedge clk); #5; check8(y2, 8'h55,  "mux2 s=1->0x55");

        // ---- mux4 ----
        $display("\n-- mux4 --");
        d0_4=8'd10; d1_4=8'd20; d2_4=8'd30; d3_4=8'd40;
        @(negedge clk); s4=2'b00; @(posedge clk); #5; check8(y4, 8'd10, "mux4 s=00->d0(10)");
        @(negedge clk); s4=2'b01; @(posedge clk); #5; check8(y4, 8'd20, "mux4 s=01->d1(20)");
        @(negedge clk); s4=2'b10; @(posedge clk); #5; check8(y4, 8'd30, "mux4 s=10->d2(30)");
        @(negedge clk); s4=2'b11; @(posedge clk); #5; check8(y4, 8'd40, "mux4 s=11->d3(40)");

        // ---- mux23 ----
        $display("\n-- mux23 --");
        d0_23 = 3'b101; d1_23 = 3'b010;
        @(negedge clk); s23=0; @(posedge clk); #5; check3(y23, 3'b101, "mux23 s=0->101");
        @(negedge clk); s23=1; @(posedge clk); #5; check3(y23, 3'b010, "mux23 s=1->010");

        d0_23 = 3'b000; d1_23 = 3'b111;
        @(negedge clk); s23=0; @(posedge clk); #5; check3(y23, 3'b000, "mux23 s=0->000");
        @(negedge clk); s23=1; @(posedge clk); #5; check3(y23, 3'b111, "mux23 s=1->111");

        repeat(5) @(posedge clk);

        $display("\n=== Muxes: %0d error(s) ===", errors);
        if (errors == 0) $display("ALL MUX TESTS PASSED");
        else             $display("SOME MUX TESTS FAILED");
        $finish;
    end

endmodule
