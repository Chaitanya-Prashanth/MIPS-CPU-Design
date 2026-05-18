    // ---- Waveform dump ----
 `timescale 1ns/10ps
// tb_alu.v — Self-checking testbench for alu.v
// Includes VCD dump for Xcelium SimVision
module tb_alu;
    reg  [7:0] a, b;
    reg  [2:0] alucont;
    wire [7:0] result;
    integer errors;

    // visible in SimVision waveform — shows current operation group
    reg [255:0] test_name;

    alu dut (.a(a), .b(b), .alucont(alucont), .result(result));
    // ---- Waveform dump ----
    initial begin
        $shm_open("dump_alu.shm");
        $shm_probe("AS");   // 0 = dump ALL levels under tb_alu
    end
    task check;
        input [7:0] in_a, in_b;
        input [2:0] ctrl;
        input [7:0] expected;
        input [63:0] tname;
        begin
            a = in_a; b = in_b; alucont = ctrl;
            #10;
            if (result === expected)
                $display("PASS | a=%0d b=%0d ctrl=%03b | result=%0d (expected %0d)",
                         in_a, in_b, ctrl, result, expected);
            else begin
                $display("FAIL | a=%0d b=%0d ctrl=%03b | result=%0d (expected %0d)",
                         in_a, in_b, ctrl, result, expected);
                errors = errors + 1;
            end
        end
    endtask
    initial begin
        errors = 0;
        a = 0; b = 0; alucont = 0;
        test_name = "IDLE";
        #5; // small initial settle
        $display("\n=== ALU Testbench ===");
        // ---- AND (alucont = 000) ----
        $display("\n-- AND --");
        test_name = "AND_TEST";
        check(8'hFF, 8'h0F, 3'b000, 8'h0F, "AND_1");
        check(8'hAA, 8'h55, 3'b000, 8'h00, "AND_2");
        check(8'hFF, 8'hFF, 3'b000, 8'hFF, "AND_3");
        check(8'h00, 8'hFF, 3'b000, 8'h00, "AND_4");
        // ---- OR (alucont = 001) ----
        $display("\n-- OR --");
        test_name = "OR_TEST";
        check(8'hAA, 8'h55, 3'b001, 8'hFF, "OR_1");
        check(8'h00, 8'h00, 3'b001, 8'h00, "OR_2");
        check(8'hF0, 8'h0F, 3'b001, 8'hFF, "OR_3");
        check(8'hFF, 8'h00, 3'b001, 8'hFF, "OR_4");
        // ---- ADD (alucont = 010) ----
        $display("\n-- ADD --");
        test_name = "ADD_TEST";
        check(8'd1,   8'd2,   3'b010, 8'd3,   "ADD_1");
        check(8'd100, 8'd27,  3'b010, 8'd127, "ADD_2");
        check(8'd0,   8'd0,   3'b010, 8'd0,   "ADD_3");
        check(8'd255, 8'd1,   3'b010, 8'd0,   "ADD_overflow");
        // ---- SUB (alucont = 110) ----
        $display("\n-- SUB --");
        test_name = "SUB_TEST";
        check(8'd5,  8'd3,  3'b110, 8'd2,   "SUB_1");
        check(8'd10, 8'd10, 3'b110, 8'd0,   "SUB_zero");
        check(8'd3,  8'd5,  3'b110, 8'd254, "SUB_neg_wrap");
        check(8'd0,  8'd1,  3'b110, 8'd255, "SUB_underflow");
        // ---- SLT (alucont = 111) ----
        $display("\n-- SLT --");
        test_name = "SLT_TEST";
        check(8'd3,  8'd5,  3'b111, 8'd1, "SLT_less");
        check(8'd5,  8'd3,  3'b111, 8'd0, "SLT_greater");
        check(8'd5,  8'd5,  3'b111, 8'd0, "SLT_equal");
        check(8'd0,  8'd1,  3'b111, 8'd1, "SLT_zero_less_one");
        check(8'hFF, 8'h00, 3'b111, 8'd1, "SLT_signed_neg");
        test_name = "DONE";
        #10; // hold final state visible in waveform
        $display("\n=== ALU: %0d error(s) ===", errors);
        if (errors == 0) $display("ALL ALU TESTS PASSED");
        else             $display("SOME ALU TESTS FAILED");
        $finish;
    end
endmodule 
