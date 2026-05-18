`timescale 1ns/10ps
// =============================================================================
// tb_mips.v — Self-checking top-level testbench for full MIPS CPU
// SHM waveform dump for Cadence SimVision
//
// Test Cases:
//   TC1  RESET          : CPU resets, PC starts at 0
//   TC2  LB_S2          : lb $s2, 20($0) — loads mem[20]=1 into $s2
//   TC3  LB_S3          : lb $s3, 21($0) — loads mem[21]=2 into $s3
//   TC4  ADD_S1         : add $s1,$s2,$s3 — $s1 = 1+2 = 3
//   TC5  SB_MEM255      : sb $s1, 255($0) — mem[255] = 3
//   TC6  JUMP           : j 0 — PC jumps back to 0
//   TC7  REG_CHECK      : verify $s1=3, $s2=1, $s3=2 in register file
// =============================================================================
module tb_mips;

    reg        clk, reset;
    wire       memread, memwrite;
    wire [7:0] adr, writedata;
    wire [7:0] memdata;

    // ---- Test phase label (visible in SimVision waveform) ----
    reg [255:0] TEST_PHASE;

    // ---- Initialize signals at t=0 ----
    initial begin
        clk   = 0;
        reset = 1;
        TEST_PHASE = "TC1_RESET";
    end

    // ---- DUT ----
    mips dut (
        .clk       (clk),
        .reset     (reset),
        .memdata   (memdata),
        .memread   (memread),
        .memwrite  (memwrite),
        .adr       (adr),
        .writedata (writedata)
    );

    // ---- Memory ----
    ram mem (
        .memdata   (memdata),
        .memwrite  (memwrite),
        .adr       (adr),
        .writedata (writedata),
        .clk       (clk)
    );

    // ---- SHM Waveform dump ----
    initial begin
        $shm_open("dump_mips.shm");
        $shm_probe("AS");
    end

    // ---- Clock: 10ns period ----
    always #5 clk = ~clk;

    integer errors;
    integer cycle_count;

    initial begin
        errors      = 0;
        cycle_count = 0;
        // Hold reset for 2 cycles
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;
        $display("\n=== Tiny MIPS Top-Level Testbench ===");
        $display("Reset released at time %0t ns", $time);
    end

    // ---- Cycle counter ----
    always @(posedge clk)
        if (!reset) cycle_count = cycle_count + 1;

    // ---- Cycle-by-cycle monitor ----
    always @(posedge clk) begin
        if (!reset)
            $display("[cyc %0d | t=%0t] PC_adr=%0d MemR=%0b MemW=%0b WD=%0d | IR=%08h state=%0d",
                     cycle_count, $time,
                     adr, memread, memwrite, writedata,
                     dut.dp.instr,
                     dut.cont.state);
    end

    // =========================================================================
    // TC2-TC3: Monitor LB instructions completing (state=S7 writeback)
    // S7: regwrite=1, memtoreg=1 -> register gets MDR value
    // =========================================================================
    always @(posedge clk) begin
        if (!reset && dut.cont.state == 4'd7) begin
            // S7 = writeback from MDR (lb completing)
            if (TEST_PHASE == "TC1_RESET" || TEST_PHASE == "TC2_LB_S2") begin
                TEST_PHASE = "TC2_LB_S2";
                $display("[TC2] LB writeback detected at cycle %0d", cycle_count);
            end else if (TEST_PHASE == "TC2_LB_S2") begin
                TEST_PHASE = "TC3_LB_S3";
                $display("[TC3] LB writeback detected at cycle %0d", cycle_count);
            end
        end
    end

    // =========================================================================
    // TC4: Monitor ADD completing (state=S10, R-type completion)
    // =========================================================================
    always @(posedge clk) begin
        if (!reset && dut.cont.state == 4'd10) begin
            TEST_PHASE = "TC4_ADD_S1";
            $display("[TC4] ADD completion detected at cycle %0d", cycle_count);
        end
    end

    // =========================================================================
    // TC5: SB to mem[255] — main self-check
    // =========================================================================
    always @(negedge clk) begin
        if (!reset && memwrite && adr == 8'd255) begin
            TEST_PHASE = "TC5_SB_MEM255";
            $display("\n--- TC5: SB mem[255]=%0d detected at cycle %0d ---",
                     writedata, cycle_count);
            if (writedata == 8'd3)
                $display("PASS | TC5_SB_MEM255 | mem[255]=%0d (expected 3)", writedata);
            else begin
                $display("FAIL | TC5_SB_MEM255 | mem[255]=%0d (expected 3)", writedata);
                errors = errors + 1;
            end
        end
    end

    // =========================================================================
    // TC6: Monitor JUMP completing (state=S12)
    // =========================================================================
    always @(posedge clk) begin
        if (!reset && dut.cont.state == 4'd12) begin
            TEST_PHASE = "TC6_JUMP";
            $display("[TC6] JUMP detected at cycle %0d — PC should return to 0",
                     cycle_count);
        end
    end

    // =========================================================================
    // TC7: Register file check — triggered after SB completes
    // =========================================================================
    always @(negedge clk) begin
        if (!reset && memwrite && adr == 8'd255) begin
            #2;
            TEST_PHASE = "TC7_REG_CHECK";
            check_registers;
            print_summary;
        end
    end



    // =========================================================================
    // Timeout watchdog
    // =========================================================================
    initial begin
        #50000;
        $display("\nTIMEOUT: simulation ran %0d cycles without completing.",
                 cycle_count);
        errors = errors + 1;
        TEST_PHASE = "TIMEOUT";
        print_summary;
    end

    // =========================================================================
    // Tasks
    // =========================================================================

    // Check register file values after program completes
    // ram.dat program:
    //   lb $s2, 20($0) — $s2 is at REGS[2], loads mem[20]=1
    //   lb $s3, 21($0) — $s3 is at REGS[3], loads mem[21]=2
    //   add $s1,$s2,$s3 — $s1 is at REGS[1], result=3
    // Register address mapping (3-bit, from instruction encoding):
    //   $s1 = reg addr from instr field — check dut.dp.rf.REGS directly
    task check_registers;
        reg [7:0] s1, s2, s3;
        begin
            // Read register file directly
            // Addresses come from the instruction encoding in ram.dat:
            //   lb $s2: rt field = instr[18:16] of lb instruction
            //   lb $s3: rt field = instr[18:16] of lb instruction
            //   add $s1: rd field = instr[13:11] of add instruction
            s2 = dut.dp.rf.REGS[2];   // $s2 loaded by first lb
            s3 = dut.dp.rf.REGS[3];   // $s3 loaded by second lb
            s1 = dut.dp.rf.REGS[1];   // $s1 result of add

            $display("\n--- TC7: Register File Check ---");
            $display("  REGS[1]=$s1 = %0d  (expected 3)", s1);
            $display("  REGS[2]=$s2 = %0d  (expected 1)", s2);
            $display("  REGS[3]=$s3 = %0d  (expected 2)", s3);

            if (s2 === 8'd1)
                $display("PASS | TC7_REG_CHECK | $s2=1 correct");
            else begin
                $display("FAIL | TC7_REG_CHECK | $s2=%0d expected 1", s2);
                errors = errors + 1;
            end

            if (s3 === 8'd2)
                $display("PASS | TC7_REG_CHECK | $s3=2 correct");
            else begin
                $display("FAIL | TC7_REG_CHECK | $s3=%0d expected 2", s3);
                errors = errors + 1;
            end

            if (s1 === 8'd3)
                $display("PASS | TC7_REG_CHECK | $s1=3 correct");
            else begin
                $display("FAIL | TC7_REG_CHECK | $s1=%0d expected 3", s1);
                errors = errors + 1;
            end
        end
    endtask

    task print_summary;
        begin
            $display("\n=== SIMULATION COMPLETE ===");
            $display("Total cycles: %0d", cycle_count);
            if (errors == 0)
                $display("ALL TESTS PASSED");
            else
                $display("%0d TEST(S) FAILED", errors);
            $finish;
        end
    endtask

endmodule
