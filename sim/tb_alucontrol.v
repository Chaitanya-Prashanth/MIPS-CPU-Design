`timescale 1ns/10ps
// tb_alucontrol.v — Self-checking testbench for alucontrol.v
// Delays scaled for SimVision waveform visibility
module tb_alucontrol;
    reg  [1:0] aluop;
    reg  [5:0] funct;
    wire [2:0] alucont;
    integer errors;
    alucontrol dut (.aluop(aluop), .funct(funct), .alucont(alucont));
    // ---- Waveform dump ----
    initial begin
        $shm_open("dump_alucontrol.shm");
        $shm_probe("AS");
    end
    // ---- Clock: 100ns period ----
    reg clk;
    initial clk = 0;
    always #50 clk = ~clk;

    // ---- Test phase label (visible in waveform) ----
    reg [255:0] TEST_PHASE;

    task check;
        input [1:0] op;
        input [5:0] fn;
        input [2:0] expected;
        input [255:0] name;
        begin
            @(negedge clk);
            aluop = op; funct = fn;
            @(posedge clk); #5;
            if (alucont === expected)
                $display("PASS | %-20s | aluop=%02b funct=%06b | alucont=%03b",
                         name, op, fn, alucont);
            else begin
                $display("FAIL | %-20s | aluop=%02b funct=%06b | alucont=%03b (exp %03b)",
                         name, op, fn, alucont, expected);
                errors = errors + 1;
            end
        end
    endtask
    initial begin
        errors = 0;
        aluop  = 0;
        funct  = 0;
        TEST_PHASE = "INIT";
        @(posedge clk);
        @(posedge clk);
        $display("\n=== ALUControl Testbench ===");

        $display("\n-- aluop=00 ADD (memory/PC) --");
        TEST_PHASE = "TC1_ALUOP00_ADD";
        check(2'b00, 6'b000000, 3'b010, "LB_SB_addr");

        $display("\n-- aluop=01 SUB (BEQ) --");
        TEST_PHASE = "TC2_ALUOP01_SUB";
        check(2'b01, 6'b000000, 3'b110, "BEQ_sub");

        $display("\n-- aluop=11 ADD (ADDI) --");
        TEST_PHASE = "TC3_ALUOP11_ADD";
        check(2'b11, 6'b000000, 3'b010, "ADDI_add");

        $display("\n-- aluop=10 R-type funct --");
        TEST_PHASE = "TC4_RTYPE_ADD";
        check(2'b10, 6'b100000, 3'b010, "R_ADD");

        TEST_PHASE = "TC5_RTYPE_SUB";
        check(2'b10, 6'b100010, 3'b110, "R_SUB");

        TEST_PHASE = "TC6_RTYPE_AND";
        check(2'b10, 6'b100100, 3'b000, "R_AND");

        TEST_PHASE = "TC7_RTYPE_OR";
        check(2'b10, 6'b100101, 3'b001, "R_OR");

        TEST_PHASE = "TC8_RTYPE_SLT";
        check(2'b10, 6'b101010, 3'b111, "R_SLT");

        TEST_PHASE = "DONE";
        repeat(5) @(posedge clk);
        $display("\n=== ALUControl: %0d error(s) ===", errors);
        if (errors == 0) $display("ALL ALUCONTROL TESTS PASSED");
        else             $display("SOME ALUCONTROL TESTS FAILED");
        $finish;
    end
endmodule