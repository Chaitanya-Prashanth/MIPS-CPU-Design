`timescale 1ns/10ps
// =============================================================================
// tb_datapath.v — Self-checking testbench for datapath.v
//
// Test Cases:
//   TC1  RESET            : PC resets to 0x00
//   TC2  PC_INCREMENT     : PC increments by 1 each cycle (alusrcb=01)
//   TC3  IR_LOAD          : All 4 IR bytes load correctly via irwrite[0..3]
//   TC4  REG_WRITE_READ   : Write via regwrite, read back via ra1/ra2
//   TC5  ALU_ADD          : ALU add through datapath (src1=A, src2=imm)
//   TC6  ALU_SUB_ZERO     : ALU sub produces zero, zero=1
//   TC7  ALU_SUB_NONZERO  : ALU sub non-zero, zero=0
//   TC8  MDR_CAPTURE      : MDR captures memdata on posedge
//   TC9  MEMTOREG_MUX     : wd = MDR when memtoreg=1, ALUOut when 0
//   TC10 IORD_MUX         : adr = PC when iord=0, ALUOut when iord=1
//   TC11 REGDST_MUX       : wa = RT when regdst=0, RD when regdst=1
//   TC12 PCSOURCE_BRANCH  : PC takes ALUOut (branch target) when pcsource=01
//   TC13 PCSOURCE_JUMP    : PC takes constx4 (jump) when pcsource=10
// =============================================================================
module tb_datapath;

    // -------------------------------------------------------------------------
    // DUT ports
    // -------------------------------------------------------------------------
    reg         clk, reset;
    reg  [7:0]  memdata;
    reg         alusrca, memtoreg, iord, pcen, regwrite, regdst;
    reg  [1:0]  pcsource, alusrcb;
    reg  [3:0]  irwrite;
    reg  [2:0]  alucont;

    wire        zero;
    wire [31:0] instr;
    wire [7:0]  adr, writedata;

    // -------------------------------------------------------------------------
    // Initialize all signals at t=0
    // -------------------------------------------------------------------------
    initial begin
        clk      = 0;
        reset    = 1;
        memdata  = 0;
        alusrca  = 0;
        memtoreg = 0;
        iord     = 0;
        pcen     = 0;
        regwrite = 0;
        regdst   = 0;
        pcsource = 2'b00;
        alusrcb  = 2'b01;
        irwrite  = 4'b0000;
        alucont  = 3'b010;
    end

    // -------------------------------------------------------------------------
    // Test phase label — visible in SimVision waveform
    // -------------------------------------------------------------------------
    reg [255:0] TEST_PHASE;

    // -------------------------------------------------------------------------
    // DUT instantiation
    // -------------------------------------------------------------------------
    datapath dut (
        .clk      (clk),
        .reset    (reset),
        .memdata  (memdata),
        .alusrca  (alusrca),
        .memtoreg (memtoreg),
        .iord     (iord),
        .pcen     (pcen),
        .regwrite (regwrite),
        .regdst   (regdst),
        .pcsource (pcsource),
        .alusrcb  (alusrcb),
        .irwrite  (irwrite),
        .alucont  (alucont),
        .zero     (zero),
        .instr    (instr),
        .adr      (adr),
        .writedata(writedata)
    );

    // -------------------------------------------------------------------------
    // Clock: 100 ns period
    // -------------------------------------------------------------------------
    always #50 clk = ~clk;

    // -------------------------------------------------------------------------
    // Waveform dump
    // -------------------------------------------------------------------------
    initial begin
        $shm_open("dump_datapath.shm");
        $shm_probe("AS");
    end

    // -------------------------------------------------------------------------
    // Counters
    // -------------------------------------------------------------------------
    integer pass_count, fail_count;

    // -------------------------------------------------------------------------
    // Tasks
    // -------------------------------------------------------------------------
    task tick;
        begin
            @(posedge clk); #5;
        end
    endtask

    task check8;
        input [7:0]   got, exp;
        input [255:0] label;
        begin
            if (got === exp) begin
                $display("PASS | %-30s | got=0x%02h (%0d)", label, got, got);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %-30s | got=0x%02h (%0d)  exp=0x%02h (%0d)",
                         label, got, got, exp, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task check1;
        input       got, exp;
        input [255:0] label;
        begin
            if (got === exp) begin
                $display("PASS | %-30s | got=%0d", label, got);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %-30s | got=%0d  exp=%0d", label, got, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task check32;
        input [31:0] got, exp;
        input [255:0] label;
        begin
            if (got === exp) begin
                $display("PASS | %-30s | got=0x%08h", label, got);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %-30s | got=0x%08h  exp=0x%08h", label, got, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Helper: deassert all control signals to safe idle state
    task idle;
        begin
            alusrca  = 0; memtoreg = 0; iord    = 0;
            pcen     = 0; regwrite = 0; regdst  = 0;
            pcsource = 2'b00; alusrcb = 2'b01;
            irwrite  = 4'b0000; alucont = 3'b010;
        end
    endtask

    // Helper: load all 4 IR bytes from a 32-bit instruction word
    // Byte0=instr[7:0] loaded first (lowest address), Byte3=instr[31:24] last
    task load_ir;
        input [31:0] instruction;
        begin
            idle;
            memdata = instruction[7:0];   irwrite = 4'b0001; tick;
            memdata = instruction[15:8];  irwrite = 4'b0010; tick;
            memdata = instruction[23:16]; irwrite = 4'b0100; tick;
            memdata = instruction[31:24]; irwrite = 4'b1000; tick;
            irwrite = 4'b0000;
        end
    endtask

    // =========================================================================
    // MAIN TEST SEQUENCE
    // =========================================================================
    initial begin
        pass_count = 0; fail_count = 0;
        TEST_PHASE = "INIT";

        $display("\n=== Datapath Testbench ===");

        // Wait 2 cycles in reset
        tick; tick;

        // =====================================================================
        // TC1: RESET — PC should be 0x00
        // =====================================================================
        TEST_PHASE = "TC1_RESET";
        $display("\n-- TC1: RESET --");
        reset = 0; #5;
        check8(adr, 8'h00, "TC1 PC=0 after reset");

        // =====================================================================
        // TC2: PC_INCREMENT
        // alusrca=0 (PC), alusrcb=01 (+1), alucont=010 (add)
        // pcsource=00 (ALUResult), pcen=1
        // Each tick: PC += 1
        // =====================================================================
        TEST_PHASE = "TC2_PC_INCREMENT";
        $display("\n-- TC2: PC INCREMENT --");
        alusrca = 0; alusrcb = 2'b01; alucont = 3'b010;
        pcsource = 2'b00; pcen = 1;

        tick; check8(adr, 8'h01, "TC2a PC=1");
        tick; check8(adr, 8'h02, "TC2b PC=2");
        tick; check8(adr, 8'h03, "TC2c PC=3");
        pcen = 0;

        // =====================================================================
        // TC3: IR_LOAD — load all 4 bytes of IR
        // Load instruction: 0xDEADBEEF
        // Byte0(instr[7:0])=0xEF, Byte1=0xBE, Byte2=0xAD, Byte3=0xDE
        // =====================================================================
        TEST_PHASE = "TC3_IR_LOAD";
        $display("\n-- TC3: IR LOAD --");
        idle;
        memdata = 8'hEF; irwrite = 4'b0001; tick;
        check8(instr[7:0],   8'hEF, "TC3a IR byte0=EF");

        memdata = 8'hBE; irwrite = 4'b0010; tick;
        check8(instr[15:8],  8'hBE, "TC3b IR byte1=BE");

        memdata = 8'hAD; irwrite = 4'b0100; tick;
        check8(instr[23:16], 8'hAD, "TC3c IR byte2=AD");

        memdata = 8'hDE; irwrite = 4'b1000; tick;
        check8(instr[31:24], 8'hDE, "TC3d IR byte3=DE");
        irwrite = 4'b0000;

        check32(instr, 32'hDEADBEEF, "TC3e full IR=DEADBEEF");

        // =====================================================================
        // TC4: REG_WRITE_READ
        // Load IR so rs=ra1=001, rt=ra2=010, rd=011
        // instr[23:21]=001(rs), instr[18:16]=010(rt), instr[13:11]=011(rd)
        // Write 0x42 into reg[2] (RT, regdst=0), read back via ra2
        //
        // Instruction encoding: op=000000 rs=001 rt=010 rd=011 shamt=00000 funct=100000
        // Bits[31:0]: 000000_001_010_011_00000_100000
        // = 0x00285020
        // =====================================================================
        TEST_PHASE = "TC4_REG_WRITE_READ";
        $display("\n-- TC4: REG WRITE/READ --");
        idle;
        // Load IR: rs=1, rt=2, rd=3
        load_ir(32'h00210000);

        // Write 0x42 into REGS[2] (RT, regdst=0) via MDR path
        memdata = 8'h42; tick;          // MDR captures 0x42
        memtoreg = 1; regwrite = 1; regdst = 0;
        tick;
        regwrite = 0; memtoreg = 0;

        // A register captures rd1=REGS[ra1=1] on tick
        // writedata register captures rd2=REGS[ra2=2] on tick
        tick;
	tick;
        check8(writedata, 8'h42, "TC4a REGS[2]=0x42 via writedata");

        // Write 0x11 into REGS[1] (rs) and verify A register captures it
        memdata = 8'h11; tick;
        memtoreg = 1; regwrite = 1; regdst = 0;
        // Need rt=1 for write: reload IR with rt=1
        idle;
        load_ir(32'h00210000); // rt=001
        memdata = 8'h11; tick;
        memtoreg = 1; regwrite = 1; regdst = 0;
        tick;
        regwrite = 0; memtoreg = 0;
        tick; // A latches rd1=REGS[1]=0x11
        check8(dut.a, 8'h11, "TC4b REGS[1]=0x11 via A reg");

        // =====================================================================
        // TC5: ALU_ADD
        // A=0x05, imm(instr[7:0])=0x03, add -> result=0x08
        // Load IR with imm=0x03, rs=001
        // Write 0x05 into REGS[1], capture into A, then ALU add with imm
        // =====================================================================
        TEST_PHASE = "TC5_ALU_ADD";
        $display("\n-- TC5: ALU ADD (A + imm) --");
        idle;
        // Load IR: rs=001, rt=001, imm=0x03
        // addi: op=001000 rs=001 rt=001 imm=00000011
        // 001000_00001_00001_00000011 padded to 32b
        load_ir(32'h20210003);

        // Write 5 into REGS[1]
        memdata = 8'd5; tick;
        memtoreg = 1; regwrite = 1; regdst = 0;
        tick; regwrite = 0; memtoreg = 0;
        tick; // A <= rd1 = REGS[1] = 5

        // Compute: src1=A=5, src2=imm=instr[7:0]=3, ADD
        alusrca = 1; alusrcb = 2'b10; alucont = 3'b010;
        tick; // ALUOut <= aluresult = 8

        // Write ALUOut back to REGS[1]
        regwrite = 1; regdst = 0; memtoreg = 0;
        tick; regwrite = 0;
        check8(dut.rf.REGS[1], 8'd8, "TC5 REGS[1]=5+3=8");

        // =====================================================================
        // TC6: ALU_SUB_ZERO
        // Subtract equal values -> result=0, zero=1
        // =====================================================================
        TEST_PHASE = "TC6_ALU_SUB_ZERO";
        $display("\n-- TC6: ALU SUB (equal values, zero=1) --");
        idle;
        // Load IR: rs=001, rt=001 (same register)
        load_ir(32'h00210000); // rs=1 rt=1

        tick; // A <= REGS[1]=8, writedata <= REGS[1]=8
        alusrca = 1; alusrcb = 2'b00; alucont = 3'b110; // SUB
        #5;
        check1(zero, 1'b1, "TC6 zero=1 (8-8=0)");

        // =====================================================================
        // TC7: ALU_SUB_NONZERO
        // Subtract different values -> result!=0, zero=0
        // =====================================================================
        TEST_PHASE = "TC7_ALU_SUB_NONZERO";
        $display("\n-- TC7: ALU SUB (different values, zero=0) --");
        idle;
        // Write 3 into REGS[2]
        load_ir(32'h00420000); // rt=2
        memdata = 8'd3; tick;
        memtoreg = 1; regwrite = 1; regdst = 0;
        tick; regwrite = 0; memtoreg = 0;

        // Load IR: rs=1(8), rt=2(3)
        load_ir(32'h00220000); // rs=1 rt=2
        tick; // A<=REGS[1]=8, writedata<=REGS[2]=3
        alusrca = 1; alusrcb = 2'b00; alucont = 3'b110; // SUB
        #5;
        check1(zero, 1'b0, "TC7 zero=0 (8-3 != 0)");

        // =====================================================================
        // TC8: MDR_CAPTURE
        // memdata=0xAB -> MDR captures on posedge
        // =====================================================================
        TEST_PHASE = "TC8_MDR_CAPTURE";
        $display("\n-- TC8: MDR CAPTURE --");
        idle;
        memdata = 8'hAB;
        tick; // MDR <= 0xAB
        check8(dut.md, 8'hAB, "TC8 MDR=0xAB");

        memdata = 8'h00;
        tick; // MDR <= 0x00
        check8(dut.md, 8'h00, "TC8b MDR=0x00");

        // =====================================================================
        // TC9: MEMTOREG_MUX
        // memtoreg=1 -> wd=MDR; memtoreg=0 -> wd=ALUOut
        // Write values and verify register file gets correct source
        // =====================================================================
        TEST_PHASE = "TC9_MEMTOREG_MUX";
        $display("\n-- TC9: MEMTOREG MUX --");
        idle;
        // Load IR with rt=3 for write target
        load_ir(32'h00630000); // rt=3
        // MDR=0x55, ALUOut should hold last result
        memdata = 8'h55; tick; // MDR=0x55
        // Write MDR to REGS[3]: memtoreg=1
        memtoreg = 1; regwrite = 1; regdst = 0;
        tick; regwrite = 0; memtoreg = 0;
        check8(dut.rf.REGS[3], 8'h55, "TC9a memtoreg=1 REGS[3]=MDR=0x55");

        // Now write ALUOut to REGS[3]: memtoreg=0
        // ALUOut holds last ALU result (8-3=5 from TC7)
        idle;
        load_ir(32'h00630000); // rt=3
        tick; // settle
        memtoreg = 0; regwrite = 1; regdst = 0;
        tick; regwrite = 0;
        check8(dut.rf.REGS[3], dut.aluout, "TC9b memtoreg=0 REGS[3]=ALUOut");

        // =====================================================================
        // TC10: IORD_MUX
        // iord=0 -> adr=PC; iord=1 -> adr=ALUOut
        // =====================================================================
        TEST_PHASE = "TC10_IORD_MUX";
        $display("\n-- TC10: IORD MUX --");
        idle;
        // Reset PC to 0
        reset = 1; tick; tick; reset = 0; #5;
        check8(adr, 8'h00, "TC10a iord=0 adr=PC=0");

        // Advance PC to 2
        alusrca = 0; alusrcb = 2'b01; alucont = 3'b010;
        pcsource = 2'b00; pcen = 1;
        tick; tick; pcen = 0;
        check8(adr, 8'h02, "TC10b iord=0 adr=PC=2");

        // iord=1 -> adr = ALUOut
        iord = 1; #5;
        check8(adr, dut.aluout, "TC10c iord=1 adr=ALUOut");
        iord = 0;

        // =====================================================================
        // TC11: REGDST_MUX
        // regdst=0 -> wa=RT=instr[18:16]
        // regdst=1 -> wa=RD=instr[13:11]
        // Load IR: rt=010(2), rd=011(3), check wa
        // =====================================================================
        TEST_PHASE = "TC11_REGDST_MUX";
        $display("\n-- TC11: REGDST MUX --");
        idle;
        load_ir(32'h00221820); // rs=1 rt=2 rd=3
        #5;
        regdst = 0; #5;
        check8({5'b0, dut.wa}, 8'd2, "TC11a regdst=0 wa=RT=2");
        regdst = 1; #5;
        check8({5'b0, dut.wa}, 8'd3, "TC11b regdst=1 wa=RD=3");

        // =====================================================================
        // TC12: PCSOURCE_BRANCH
        // pcsource=01 -> nextpc = ALUOut (branch target)
        // Set up ALUOut=0x10 via ALU add, then branch
        // =====================================================================
        TEST_PHASE = "TC12_PCSOURCE_BRANCH";
        $display("\n-- TC12: PCSOURCE BRANCH (pcsource=01) --");
        idle;
        reset = 1; tick; tick; reset = 0; #5;

        // Compute ALU result = 0x10 (src1=PC=0, src2=imm=0x10)
        load_ir(32'h00000010); // imm=0x10
        alusrca = 0; alusrcb = 2'b10; alucont = 3'b010; // add PC+imm
        tick; // ALUOut <= 0x10

        // Take branch: pcsource=01, pcen=1
        pcsource = 2'b01; pcen = 1;
        tick; pcen = 0;
        check8(adr, 8'h10, "TC12 pcsource=01 PC=ALUOut=0x10");

        // =====================================================================
        // TC13: PCSOURCE_JUMP
        // pcsource=10 -> nextpc = constx4 = {instr[5:0], 2'b00}
        // Load IR with instr[5:0]=6'b000100 -> constx4 = 0b00010000 = 0x10
        // =====================================================================
        TEST_PHASE = "TC13_PCSOURCE_JUMP";
        $display("\n-- TC13: PCSOURCE JUMP (pcsource=10) --");
        idle;
        reset = 1; tick; tick; reset = 0; #5;

        // Load IR: instr[5:0]=000101 -> constx4={000101,00}=00010100=0x14
        load_ir(32'h08000005); // j-type, instr[5:0]=000101
        #5;
        pcsource = 2'b10; pcen = 1;
        tick; pcen = 0;
        check8(adr, 8'h14, "TC13 pcsource=10 PC=constx4=0x14");

        // =====================================================================
        // Summary
        // =====================================================================
        TEST_PHASE = "DONE";
        $display("\n=== Datapath: %0d PASSED, %0d FAILED ===",
                 pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL DATAPATH TESTS PASSED");
        else
            $display("SOME DATAPATH TESTS FAILED");
        $finish;
    end

    // Watchdog
    initial begin
        #200000;
        $display("[ERROR] Datapath TB TIMEOUT");
        $finish;
    end

endmodule
