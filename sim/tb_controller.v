`timescale 1ns/10ps
// =============================================================================
// Testbench: controller_tb  (v2 - fixed state sampling and fetch sequencing)
//
// Root cause of original failures:
//   1. After run_fetch completed, code assumed state==S4 but the NEXT tick
//      had already moved FSM out of S4 (nextstate is combinational).
//   2. "tick" advanced the clock AND checked — meaning checks were one
//      state ahead of where they thought they were.
//
// Fix:
//   - Set op BEFORE the clock edge that leaves S3 (so S4's nextstate is
//     computed correctly on the SAME cycle S4 is entered).
//   - Check state AFTER posedge + #1 settle — state reg holds new value.
//   - fetch helper: 4 ticks (S0->S1->S2->S3->S4), then return.
//     Caller checks S4 first, THEN ticks once more to reach next state.
// =============================================================================
module tb_controller;

    reg         clk, reset, zero;
    reg  [5:0]  op;

    wire        memread, memwrite, alusrca, memtoreg, iord, pcen;
    wire        regwrite, regdst;
    wire [1:0]  pcsource, alusrcb, aluop;
    wire [3:0]  irwrite;

    integer     pass_count, fail_count;
    reg [127:0] TEST_PHASE;

    wire [3:0]  state = dut.state;

    controller dut (
        .clk(clk), .reset(reset), .op(op), .zero(zero),
        .memread(memread), .memwrite(memwrite),
        .alusrca(alusrca), .memtoreg(memtoreg),
        .iord(iord), .pcen(pcen),
        .regwrite(regwrite), .regdst(regdst),
        .pcsource(pcsource), .alusrcb(alusrcb),
        .aluop(aluop), .irwrite(irwrite)
    );

    initial clk = 0;
    always  #5 clk = ~clk;

    localparam OP_RTYPE = 6'b000000;
    localparam OP_J     = 6'b000010;
    localparam OP_BEQ   = 6'b000100;
    localparam OP_ADDI  = 6'b001000;
    localparam OP_LB    = 6'b100000;
    localparam OP_SB    = 6'b110000;

    localparam S0=4'd0,  S1=4'd1,  S2=4'd2,  S3=4'd3,
               S4=4'd4,  S5=4'd5,  S6=4'd6,  S7=4'd7,
               S8=4'd8,  S9=4'd9,  S10=4'd10,S11=4'd11,
               S12=4'd12;

    // Advance one clock, allow outputs to settle
    task tick;
        @(posedge clk); 
    endtask

    // Run fetch: go from S0 to S4.
    // Precondition: state == S0 when called.
    // Postcondition: state == S4.
    // op must be set BEFORE calling this so nextstate in S4 is correct.
    task run_fetch;
        begin
            tick; // S0->S1
            tick; // S1->S2
            tick; // S2->S3
            tick; // S3->S4
        end
    endtask

    task chk_state;
        input [3:0]    exp;
        input [127:0]  lbl;
        begin
            if (state === exp) begin
                $display("[PASS] %-22s state=%0d", lbl, state);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %-22s state=%0d  EXP=%0d", lbl, state, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task chk1;
        input         got, exp;
        input [127:0] lbl;
        begin
            if (got === exp) begin
                $display("[PASS] %-22s val=%0d", lbl, got);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %-22s val=%0d  EXP=%0d", lbl, got, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task chk2;
        input [1:0]   got, exp;
        input [127:0] lbl;
        begin
            if (got === exp) begin
                $display("[PASS] %-22s val=%0b", lbl, got);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %-22s val=%0b  EXP=%0b", lbl, got, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    task chk4;
        input [3:0]   got, exp;
        input [127:0] lbl;
        begin
            if (got === exp) begin
                $display("[PASS] %-22s val=%0b", lbl, got);
                pass_count = pass_count + 1;
            end else begin
                $display("[FAIL] %-22s val=%0b  EXP=%0b", lbl, got, exp);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // =========================================================================
    // MAIN
    // =========================================================================
    initial begin
        $shm_open("controller_waves.shm");
        $shm_probe("AS");

        pass_count = 0; fail_count = 0;
        op = OP_RTYPE; zero = 0; reset = 1;

        $display("===================================================");
        $display(" Controller FSM Testbench (v2)");
        $display("===================================================");

        // =============================================================
        // RESET
        // =============================================================
        TEST_PHASE = "RESET";
        //tick; tick; 
        #1;
        reset = 0; #1;
        $display("\n--- Reset -> S0 ---");
        chk_state(S0, "reset->S0");

        // =============================================================
        // S0 outputs
        // =============================================================
        TEST_PHASE = "S0";
	tick;
        $display("\n--- S0 (fetch byte 0) ---");
        chk4(irwrite,  4'b0001, "S0 irwrite");
        chk2(alusrcb,  2'b01,   "S0 alusrcb=01");
        chk1(alusrca,  1'b0,    "S0 alusrca=0");
        chk1(pcen,     1'b1,    "S0 pcen=1");
        chk2(pcsource, 2'b00,   "S0 pcsource=00");
        chk1(memread,  1'b1,    "S0 memread=1");
        chk1(memwrite, 1'b0,    "S0 memwrite=0");
        chk1(regwrite, 1'b0,    "S0 regwrite=0");

        // =============================================================
        // S1 outputs
        // =============================================================
        TEST_PHASE = "S1";
        tick;
        $display("\n--- S1 (fetch byte 1) ---");
        chk_state(S1,           "S0->S1");
        chk4(irwrite,  4'b0010, "S1 irwrite");
        chk1(pcen,     1'b1,    "S1 pcen=1");
        chk1(memread,  1'b1,    "S1 memread=1");
        chk1(memwrite, 1'b0,    "S1 memwrite=0");

        // =============================================================
        // S2 outputs
        // =============================================================
        TEST_PHASE = "S2";
        tick;
        $display("\n--- S2 (fetch byte 2) ---");
        chk_state(S2,           "S1->S2");
        chk4(irwrite,  4'b0100, "S2 irwrite");
        chk1(pcen,     1'b1,    "S2 pcen=1");

        // =============================================================
        // S3 outputs
        // =============================================================
        TEST_PHASE = "S3";
        tick;
        $display("\n--- S3 (fetch byte 3) ---");
        chk_state(S3,           "S2->S3");
        chk4(irwrite,  4'b1000, "S3 irwrite");
        chk1(pcen,     1'b1,    "S3 pcen=1");

        // =============================================================
        // S4 outputs (op must be set now, before the tick that
        // ENTERS S4, so nextstate is correct from the moment we arrive)
        // =============================================================
        TEST_PHASE = "S4_RTYPE";
        op = OP_RTYPE;   // set BEFORE tick into S4
        tick;            // S3 -> S4
        $display("\n--- S4 Decode (op=RTYPE) ---");
        chk_state(S4,           "S3->S4");
        chk1(alusrca,  1'b0,    "S4 alusrca=0");
        chk2(alusrcb,  2'b11,   "S4 alusrcb=11");
        chk1(regwrite, 1'b0,    "S4 regwrite=0");
        chk1(pcen,     1'b0,    "S4 pcen=0");
        chk1(memwrite, 1'b0,    "S4 memwrite=0");

        // =============================================================
        // RTYPE: S4->S9->S10->S0
        // =============================================================
        TEST_PHASE = "RTYPE_S9";
        tick;   // S4->S9
        $display("\n--- S9 Execute (R-type) ---");
        chk_state(S9,           "S4->S9");
        chk1(alusrca,  1'b1,    "S9 alusrca=1");
        chk2(alusrcb,  2'b00,   "S9 alusrcb=00");
        chk2(aluop,    2'b10,   "S9 aluop=10");
        chk1(regwrite, 1'b0,    "S9 regwrite=0");
        chk1(memwrite, 1'b0,    "S9 memwrite=0");

        TEST_PHASE = "RTYPE_S10";
        tick;   // S9->S10
        $display("\n--- S10 R-type completion ---");
        chk_state(S10,          "S9->S10");
        chk1(regdst,   1'b1,    "S10 regdst=1 RD");
        chk1(regwrite, 1'b1,    "S10 regwrite=1");
        chk1(memtoreg, 1'b0,    "S10 memtoreg=0");
        chk1(memwrite, 1'b0,    "S10 memwrite=0");

        tick;   // S10->S0
        chk_state(S0, "S10->S0");

        // =============================================================
        // LB path: S0->S4->S5->S6->S7->S0
        // Set op before run_fetch so S4->S5 nextstate is ready
        // =============================================================
        TEST_PHASE = "LB_PATH";
        $display("\n--- LB path: S4->S5->S6->S7 ---");
        op = OP_LB;
        run_fetch;        // lands at S4
        chk_state(S4, "lb: at S4");

        tick;   // S4->S5
        chk_state(S5,           "S4->S5 lb");
        chk1(alusrca,  1'b1,    "S5 alusrca=1");
        chk2(alusrcb,  2'b10,   "S5 alusrcb=10 imm");
        chk2(aluop,    2'b00,   "S5 aluop=00 add");
        chk1(memwrite, 1'b0,    "S5 memwrite=0");

        tick;   // S5->S6
        chk_state(S6,           "S5->S6");
        chk1(iord,     1'b1,    "S6 iord=1");
        chk1(memread,  1'b1,    "S6 memread=1");
        chk1(regwrite, 1'b0,    "S6 regwrite=0");

        tick;   // S6->S7
        chk_state(S7,           "S6->S7");
        chk1(regdst,   1'b0,    "S7 regdst=0 RT");
        chk1(regwrite, 1'b1,    "S7 regwrite=1");
        chk1(memtoreg, 1'b1,    "S7 memtoreg=1 MDR");
        chk1(memwrite, 1'b0,    "S7 memwrite=0");

        tick;   // S7->S0
        chk_state(S0, "S7->S0");

        // =============================================================
        // SB path: S0->S4->S5->S8->S0
        // =============================================================
        TEST_PHASE = "SB_PATH";
        $display("\n--- SB path: S4->S5->S8 ---");
        run_fetch;        // S0->S4
        chk_state(S4, "sb: at S4");
        op = OP_SB;
	$display("DEBUG: state=%d op=%b OP_SUB=%b", state, op, 6'b110000);
        tick;   // S4->S5
        chk_state(S5,           "S4->S5 sb");
        chk1(alusrca,  1'b1,    "S5 sb alusrca=1");
        chk2(alusrcb,  2'b10,   "S5 sb alusrcb=10");
        chk2(aluop,    2'b00,   "S5 sb aluop=00");

        tick;   // S5->S8
        chk_state(S8,           "S5->S8 sb");
        chk1(iord,     1'b1,    "S8 iord=1");
        chk1(memwrite, 1'b1,    "S8 memwrite=1");
        chk1(regwrite, 1'b0,    "S8 regwrite=0");
        chk1(memread,  1'b0,    "S8 memread=0");

        tick;   // S8->S0
        chk_state(S0, "S8->S0");

        // =============================================================
        // BEQ TAKEN: zero=1, branch taken
        // =============================================================
        TEST_PHASE = "BEQ_TAKEN";
        $display("\n--- BEQ taken (zero=1) ---");
        op = OP_BEQ; zero = 1;
        run_fetch;        // S0->S4
        chk_state(S4, "beq taken: at S4");

        tick;   // S4->S11
        chk_state(S11,          "S4->S11 beq");
        chk1(alusrca,  1'b1,    "S11 alusrca=1");
        chk2(alusrcb,  2'b00,   "S11 alusrcb=00");
        chk2(aluop,    2'b01,   "S11 aluop=01 sub");
        chk1(pcen,     1'b1,    "S11 pcen=1 taken");
        chk2(pcsource, 2'b01,   "S11 pcsource=01");
        chk1(regwrite, 1'b0,    "S11 regwrite=0");
        chk1(memwrite, 1'b0,    "S11 memwrite=0");

        tick;   // S11->S0
        chk_state(S0, "S11->S0 taken");

        // =============================================================
        // BEQ NOT TAKEN: zero=0, pcen should be 0
        // =============================================================
        TEST_PHASE = "BEQ_NOTTAKEN";
        $display("\n--- BEQ not taken (zero=0) ---");
        op = OP_BEQ; zero = 0;
        run_fetch;        // S0->S4
        chk_state(S4, "beq ntaken: at S4");

        tick;   // S4->S11
        chk_state(S11,          "S4->S11 ntaken");
        chk1(pcen,     1'b0,    "S11 pcen=0 not taken");
        chk2(pcsource, 2'b01,   "S11 pcsource=01");

        tick;   // S11->S0
        chk_state(S0, "S11->S0 ntaken");

        // =============================================================
        // JUMP path: S4->S12->S0
        // =============================================================
        TEST_PHASE = "JUMP_PATH";
        $display("\n--- JUMP path: S4->S12 ---");
        op = OP_J; zero = 0;
        run_fetch;        // S0->S4
        chk_state(S4, "jump: at S4");

        tick;   // S4->S12
        chk_state(S12,          "S4->S12 j");
        chk1(pcen,     1'b1,    "S12 pcen=1");
        chk2(pcsource, 2'b10,   "S12 pcsource=10");
        chk1(regwrite, 1'b0,    "S12 regwrite=0");
        chk1(memwrite, 1'b0,    "S12 memwrite=0");

        tick;   // S12->S0
        chk_state(S0, "S12->S0");

        // =============================================================
        // ADDI path: S4->S9->S10 (regdst=0, alusrcb=10)
        // =============================================================
        TEST_PHASE = "ADDI_PATH";
        $display("\n--- ADDI path: S4->S9->S10 ---");
        op = OP_ADDI;
        run_fetch;        // S0->S4
        chk_state(S4, "addi: at S4");

        tick;   // S4->S9
        chk_state(S9,           "S4->S9 addi");
        chk2(alusrcb,  2'b10,   "S9 addi alusrcb=10 imm");
        chk2(aluop,    2'b00,   "S9 addi aluop=00 add");
        chk1(alusrca,  1'b1,    "S9 addi alusrca=1");
        chk1(regwrite, 1'b0,    "S9 addi regwrite=0");

        tick;   // S9->S10
        chk_state(S10,          "S9->S10 addi");
        chk1(regdst,   1'b0,    "S10 addi regdst=0 RT");
        chk1(regwrite, 1'b1,    "S10 addi regwrite=1");
        chk1(memtoreg, 1'b0,    "S10 addi memtoreg=0");

        tick;   // S10->S0
        chk_state(S0, "S10->S0 addi");

        // =============================================================
        // Summary
        // =============================================================
        $display("\n===================================================");
        $display(" Controller: %0d PASSED, %0d FAILED",
                 pass_count, fail_count);
        if (fail_count == 0)
            $display(" *** ALL TESTS PASSED ***");
        else
            $display(" *** %0d FAILURE(S) ***", fail_count);
        $display("===================================================");

        $finish;
    end

    initial begin
        #100000;
        $display("[ERROR] Watchdog timeout");
   $finish;
    end

endmodule
