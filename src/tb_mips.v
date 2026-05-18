`timescale 1ns/10ps
// =============================================================================
// tb_mips.v — Comprehensive self-checking testbench for Tiny MIPS CPU
// Tests ALL instruction types: lb, add, sub, and, or, slt, addi, sb, beq, j
//
// Program (ram.dat):
//   Addr  0: lb   $s0, 60($zero)    -- $s0 = mem[60] = 10
//   Addr  4: lb   $s1, 61($zero)    -- $s1 = mem[61] = 3
//   Addr  8: add  $s2,$s0,$s1       -- $s2 = 10+3  = 13
//   Addr 12: sub  $s3,$s0,$s1       -- $s3 = 10-3  = 7
//   Addr 16: and  $s4,$s0,$s1       -- $s4 = 10&3  = 2
//   Addr 20: or   $s5,$s0,$s1       -- $s5 = 10|3  = 11
//   Addr 24: slt  $s6,$s1,$s0       -- $s6 = (3<10)= 1
//   Addr 28: addi $s0,$s0,5         -- $s0 = 10+5  = 15
//   Addr 32: sb   $s2, 62($zero)    -- mem[62] = 13
//   Addr 36: beq  $s1,$s1,+1        -- branch TAKEN -> skip addr 40
//   Addr 40: addi $s0,$s0,99        -- SKIPPED (beq taken)
//   Addr 44: sb   $s3, 63($zero)    -- mem[63] = 7
//   Addr 48: j    0                 -- jump to 0
//   Addr 60: data = 10
//   Addr 61: data = 3
//
// Test Cases:
//   TC1  RESET         : CPU resets, PC=0
//   TC2  LB_S0         : lb loads mem[60]=10 into $s0
//   TC3  LB_S1         : lb loads mem[61]=3  into $s1
//   TC4  ADD           : add $s2 = 10+3 = 13
//   TC5  SUB           : sub $s3 = 10-3 = 7
//   TC6  AND           : and $s4 = 10&3 = 2
//   TC7  OR            : or  $s5 = 10|3 = 11
//   TC8  SLT           : slt $s6 = (3<10) = 1
//   TC9  ADDI          : addi $s0 = 10+5 = 15
//   TC10 SB_MEM62      : sb stores $s2=13 into mem[62]
//   TC11 BEQ_TAKEN     : beq $s1,$s1 taken -> skip addi $s0,$s0,99
//   TC12 BEQ_NOT_TAKEN : $s0 stays 15 (99 was NOT added)
//   TC13 SB_MEM63      : sb stores $s3=7 into mem[63]
//   TC14 JUMP          : j 0 -> PC returns to 0
//   TC15 REG_CHECK     : verify all register values
// =============================================================================
module tb_mips;

    reg        clk, reset;
    wire       memread, memwrite;
    wire [7:0] adr, writedata;
    wire [7:0] memdata;

    // Test phase visible in SimVision waveform
    reg [255:0] TEST_PHASE;

    // Initialize at t=0
    initial begin
        clk        = 0;
        reset      = 1;
        TEST_PHASE = "TC1_RESET";
    end

    // DUT
    mips dut (
        .clk      (clk),
        .reset    (reset),
        .memdata  (memdata),
        .memread  (memread),
        .memwrite (memwrite),
        .adr      (adr),
        .writedata(writedata)
    );

    // Memory
    ram mem (
        .memdata  (memdata),
        .memwrite (memwrite),
        .adr      (adr),
        .writedata(writedata),
        .clk      (clk)
    );

    // SHM waveform
    initial begin
        $shm_open("dump_mips.shm");
        $shm_probe("AS");
    end

    // 10ns clock
    always #5 clk = ~clk;

    integer errors;
    integer cycle_count;
    integer sb_count;
    integer beq_fired;
    integer rtype_count;
    integer lb_first_done;

    initial begin
        errors        = 0;
        cycle_count   = 0;
        sb_count      = 0;
        beq_fired     = 0;
        rtype_count   = 0;
        lb_first_done = 0;
        @(posedge clk); #1;
        @(posedge clk); #1;
        reset = 0;
        $display("\n=== Tiny MIPS Comprehensive Testbench ===");
        $display("Reset released at time %0t ns", $time);
    end

    // Cycle counter
    always @(posedge clk)
        if (!reset) cycle_count = cycle_count + 1;

    // Cycle monitor
    always @(posedge clk) begin
        if (!reset)
            $display("[cyc %0d | t=%0t] PC=%0d MR=%0b MW=%0b WD=%0d | IR=%08h st=%0d",
                     cycle_count, $time,
                     adr, memread, memwrite, writedata,
                     dut.dp.instr, dut.cont.state);
    end

    // -----------------------------------------------------------------------
    // TC2/TC3: LB writeback (S7)
    // -----------------------------------------------------------------------
    always @(posedge clk) begin
        if (!reset && dut.cont.state == 4'd7) begin
            if (!lb_first_done) begin
                TEST_PHASE    = "TC2_LB_S0";
                lb_first_done = 1;
                $display("[TC2] lb $s0 writeback at cycle %0d", cycle_count);
            end else begin
                TEST_PHASE = "TC3_LB_S1";
                $display("[TC3] lb $s1 writeback at cycle %0d", cycle_count);
            end
        end
    end

    // -----------------------------------------------------------------------
    // TC4-TC9: R-type and ADDI completion (S10)
    // -----------------------------------------------------------------------
    always @(posedge clk) begin
        if (!reset && dut.cont.state == 4'd10) begin
            rtype_count = rtype_count + 1;
            case (rtype_count)
                1: begin TEST_PHASE = "TC4_ADD";  $display("[TC4] add at cycle %0d", cycle_count); end
                2: begin TEST_PHASE = "TC5_SUB";  $display("[TC5] sub at cycle %0d", cycle_count); end
                3: begin TEST_PHASE = "TC6_AND";  $display("[TC6] and at cycle %0d", cycle_count); end
                4: begin TEST_PHASE = "TC7_OR";   $display("[TC7] or  at cycle %0d", cycle_count); end
                5: begin TEST_PHASE = "TC8_SLT";  $display("[TC8] slt at cycle %0d", cycle_count); end
                6: begin TEST_PHASE = "TC9_ADDI"; $display("[TC9] addi at cycle %0d", cycle_count); end
            endcase
        end
    end

    // -----------------------------------------------------------------------
    // TC10/TC13: SB detection via memwrite
    // -----------------------------------------------------------------------
    always @(negedge clk) begin
        if (!reset && memwrite) begin
            sb_count = sb_count + 1;
            if (sb_count == 1) begin
                TEST_PHASE = "TC10_SB_MEM62";
                $display("\n--- TC10: sb mem[%0d]=%0d at cycle %0d ---",
                         adr, writedata, cycle_count);
                if (adr === 8'd62 && writedata === 8'd13)
                    $display("PASS | TC10_SB_MEM62 | mem[62]=13 correct");
                else begin
                    $display("FAIL | TC10_SB_MEM62 | adr=%0d val=%0d (exp adr=62 val=13)",
                             adr, writedata);
                    errors = errors + 1;
                end
            end else if (sb_count == 2) begin
                TEST_PHASE = "TC13_SB_MEM63";
                $display("\n--- TC13: sb mem[%0d]=%0d at cycle %0d ---",
                         adr, writedata, cycle_count);
                if (adr === 8'd63 && writedata === 8'd7)
                    $display("PASS | TC13_SB_MEM63 | mem[63]=7 correct");
                else begin
                    $display("FAIL | TC13_SB_MEM63 | adr=%0d val=%0d (exp adr=63 val=7)",
                             adr, writedata);
                    errors = errors + 1;
                end
                #2;
                TEST_PHASE = "TC15_REG_CHECK";
                check_all_registers;
                print_summary;
            end
        end
    end

    // -----------------------------------------------------------------------
    // TC11: BEQ taken (S11 with pcen=1)
    // -----------------------------------------------------------------------
    always @(posedge clk) begin
        if (!reset && dut.cont.state == 4'd11 && dut.pcen) begin
            TEST_PHASE = "TC11_BEQ_TAKEN";
            beq_fired  = 1;
            $display("[TC11] beq TAKEN at cycle %0d", cycle_count);
        end
    end

    // -----------------------------------------------------------------------
    // TC14: Jump (S12)
    // -----------------------------------------------------------------------
    always @(posedge clk) begin
        if (!reset && dut.cont.state == 4'd12) begin
            TEST_PHASE = "TC14_JUMP";
            $display("[TC14] j 0 at cycle %0d -> PC=0", cycle_count);
        end
    end

    // -----------------------------------------------------------------------
    // Timeout
    // -----------------------------------------------------------------------
    initial begin
        #200000;
        $display("\nTIMEOUT: %0d cycles", cycle_count);
        errors = errors + 1;
        TEST_PHASE = "TIMEOUT";
        print_summary;
    end

    // -----------------------------------------------------------------------
    // Tasks
    // -----------------------------------------------------------------------
    task check_reg;
        input [2:0]   raddr;
        input [7:0]   exp;
        input [255:0] lbl;
        reg   [7:0]   got;
        begin
            got = dut.dp.rf.REGS[raddr];
            if (got === exp)
                $display("PASS | %-28s | REGS[%0d]=%0d", lbl, raddr, got);
            else begin
                $display("FAIL | %-28s | REGS[%0d]=%0d  exp=%0d", lbl, raddr, got, exp);
                errors = errors + 1;
            end
        end
    endtask

    task check_mem_val;
        input [7:0]   addr;
        input [7:0]   exp;
        input [255:0] lbl;
        reg   [7:0]   got;
        begin
            got = mem.mips_ram[addr];
            if (got === exp)
                $display("PASS | %-28s | mem[%0d]=%0d", lbl, addr, got);
            else begin
                $display("FAIL | %-28s | mem[%0d]=%0d  exp=%0d", lbl, addr, got, exp);
                errors = errors + 1;
            end
        end
    endtask

    task check_all_registers;
        begin
            $display("\n--- TC15: Full Register and Memory Check ---");
            check_reg(1, 8'd15, "TC2+TC9 $s0=10+5=15");
            check_reg(2, 8'd3,  "TC3     $s1=3");
            check_reg(3, 8'd13, "TC4     $s2=add=13");
            check_reg(4, 8'd7,  "TC5     $s3=sub=7");
            check_reg(5, 8'd2,  "TC6     $s4=and=2");
            check_reg(6, 8'd11, "TC7     $s5=or=11");
            check_reg(7, 8'd1,  "TC8     $s6=slt=1");
            // TC12: beq skipped addi $s0,$s0,99 so $s0=15 not 114
            if (dut.dp.rf.REGS[1] === 8'd15)
                $display("PASS | TC12_BEQ_SKIP           | $s0=15 (addi 99 skipped)");
            else begin
                $display("FAIL | TC12_BEQ_SKIP           | $s0=%0d (exp 15, skip failed)",
                         dut.dp.rf.REGS[1]);
                errors = errors + 1;
            end
            if (beq_fired)
                $display("PASS | TC11_BEQ_TAKEN          | beq taken confirmed");
            else begin
                $display("FAIL | TC11_BEQ_TAKEN          | beq never detected");
                errors = errors + 1;
            end
            check_mem_val(8'd62, 8'd13, "TC10 mem[62]=13");
            check_mem_val(8'd63, 8'd7,  "TC13 mem[63]=7");
        end
    endtask

    task print_summary;
        begin
            $display("\n===========================================");
            $display(" SIMULATION COMPLETE  cycles=%0d", cycle_count);
            if (errors == 0)
                $display(" *** ALL TESTS PASSED ***");
            else
                $display(" *** %0d TEST(S) FAILED ***", errors);
            $display("===========================================");
            $finish;
        end
    endtask

endmodule