`timescale 1ns/10ps
// tb_regfile.v — Self-checking testbench for regfile.v
// 100ns clock period for clear SimVision waveform visibility

module tb_regfile;

    reg        clk, regwrite;
    reg  [2:0] ra1, ra2, wa;
    reg  [7:0] wd;
    wire [7:0] rd1, rd2;

    integer errors;

    // ---- Test phase label (visible in SimVision waveform) ----
    reg [255:0] TEST_PHASE;

    regfile dut (.clk(clk), .regwrite(regwrite),
                 .ra1(ra1), .ra2(ra2), .wa(wa),
                 .wd(wd), .rd1(rd1), .rd2(rd2));

    // ---- Waveform dump ----
    initial begin
        $shm_open("dump_regfile.shm");
        $shm_probe("AS");
    end

    // ---- 100ns clock ----
    initial clk = 0;
    always #50 clk = ~clk;

    task write_reg;
        input [2:0] addr;
        input [7:0] data;
        begin
            @(negedge clk);
            wa = addr; wd = data; regwrite = 1;
            @(posedge clk); #5;
            regwrite = 0;
            // Hold for 1 extra cycle so write is clearly visible in waveform
            @(posedge clk);
        end
    endtask

    task check_rd1;
        input [2:0] addr;
        input [7:0] expected;
        input [255:0] name;
        begin
            @(negedge clk); ra1 = addr;
            @(posedge clk); #5;
            if (rd1 === expected)
                $display("PASS | %-35s | rd1[%0d]=%3d", name, addr, rd1);
            else begin
                $display("FAIL | %-35s | rd1[%0d]=%3d (exp %3d)", name, addr, rd1, expected);
                errors = errors + 1;
            end
        end
    endtask

    task check_rd2;
        input [2:0] addr;
        input [7:0] expected;
        input [255:0] name;
        begin
            @(negedge clk); ra2 = addr;
            @(posedge clk); #5;
            if (rd2 === expected)
                $display("PASS | %-35s | rd2[%0d]=%3d", name, addr, rd2);
            else begin
                $display("FAIL | %-35s | rd2[%0d]=%3d (exp %3d)", name, addr, rd2, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors   = 0;
        regwrite = 0;
        ra1 = 0; ra2 = 0; wa = 0; wd = 0;
        TEST_PHASE = "INIT";

        // 3 idle cycles at start
        repeat(3) @(posedge clk);

        $display("\n=== RegFile Testbench ===");

        // ----------------------------------------------------------------
        // TC1: Write all registers $s0-$s6 (addr 1-7)
        // ----------------------------------------------------------------
        TEST_PHASE = "TC1_WRITE_ALL_REGS";
        $display("\n-- TC1: Writing $s0-$s6 (addr 1-7) --");
        write_reg(3'd1, 8'd10);
        write_reg(3'd2, 8'd20);
        write_reg(3'd3, 8'd30);
        write_reg(3'd4, 8'd40);
        write_reg(3'd5, 8'd50);
        write_reg(3'd6, 8'd60);
        write_reg(3'd7, 8'd70);

        repeat(2) @(posedge clk);

        // ----------------------------------------------------------------
        // TC2: Read back all registers via ra1
        // ----------------------------------------------------------------
        TEST_PHASE = "TC2_READ_VIA_RA1";
        $display("\n-- TC2: Read via ra1 --");
        check_rd1(3'd1, 8'd10, "rd1 addr=1 expect 10");
        check_rd1(3'd2, 8'd20, "rd1 addr=2 expect 20");
        check_rd1(3'd3, 8'd30, "rd1 addr=3 expect 30");
        check_rd1(3'd4, 8'd40, "rd1 addr=4 expect 40");
        check_rd1(3'd5, 8'd50, "rd1 addr=5 expect 50");
        check_rd1(3'd6, 8'd60, "rd1 addr=6 expect 60");
        check_rd1(3'd7, 8'd70, "rd1 addr=7 expect 70");

        repeat(2) @(posedge clk);

        // ----------------------------------------------------------------
        // TC3: Read back registers via ra2
        // ----------------------------------------------------------------
        TEST_PHASE = "TC3_READ_VIA_RA2";
        $display("\n-- TC3: Read via ra2 --");
        check_rd2(3'd1, 8'd10, "rd2 addr=1 expect 10");
        check_rd2(3'd7, 8'd70, "rd2 addr=7 expect 70");

        repeat(2) @(posedge clk);

        // ----------------------------------------------------------------
        // TC4: Simultaneous dual-port read (ra1 and ra2 at same time)
        // ----------------------------------------------------------------
        TEST_PHASE = "TC4_DUAL_PORT_READ";
        $display("\n-- TC4: Simultaneous dual-port read --");
        @(negedge clk); ra1 = 3'd2; ra2 = 3'd5;
        @(posedge clk); #5;
        if (rd1 === 8'd20 && rd2 === 8'd50)
            $display("PASS | rd1[$2]=%0d rd2[$5]=%0d simultaneously", rd1, rd2);
        else begin
            $display("FAIL | rd1=%0d rd2=%0d (exp 20,50)", rd1, rd2);
            errors = errors + 1;
        end

        repeat(2) @(posedge clk);

        // ----------------------------------------------------------------
        // TC5: $zero hardwired to 0 (write attempt must have no effect)
        // ----------------------------------------------------------------
        TEST_PHASE = "TC5_ZERO_HARDWIRED";
        $display("\n-- TC5: $zero hardwired to 0 --");
        write_reg(3'd0, 8'd99); // attempt write to $zero
        check_rd1(3'd0, 8'd0, "$zero after write attempt");
        check_rd2(3'd0, 8'd0, "$zero via rd2");

        repeat(2) @(posedge clk);

        // ----------------------------------------------------------------
        // TC6: No write when regwrite=0
        // ----------------------------------------------------------------
        TEST_PHASE = "TC6_NO_WRITE_REGWRITE0";
        $display("\n-- TC6: No write when regwrite=0 --");
        @(negedge clk); wa = 3'd3; wd = 8'd99; regwrite = 0;
        @(posedge clk); #5;
        check_rd1(3'd3, 8'd30, "addr=3 unchanged (regwrite=0)");

        repeat(2) @(posedge clk);

        // ----------------------------------------------------------------
        // TC7: Overwrite existing register value
        // ----------------------------------------------------------------
        TEST_PHASE = "TC7_OVERWRITE";
        $display("\n-- TC7: Overwrite --");
        write_reg(3'd3, 8'd77);
        check_rd1(3'd3, 8'd77, "addr=3 overwritten to 77");

        // Final idle — 5 cycles visible in waveform
        TEST_PHASE = "DONE";
        repeat(5) @(posedge clk);

        $display("\n=== RegFile: %0d error(s) ===", errors);
        if (errors == 0) $display("ALL REGFILE TESTS PASSED");
        else             $display("SOME REGFILE TESTS FAILED");
        $finish;
    end

endmodule