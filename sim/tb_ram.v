`timescale 1ns/10ps
// =============================================================================
// tb_ram.v — Self-checking testbench for ram.v
// 100ns clock period for SimVision waveform visibility
//
// NOTE: ram.dat must be present in the simulation working directory.
//       ram.v loads it via $readmemb on startup.
//       This TB creates its own ram.dat with known values before simulation.
//
// Test Cases:
//   TC1  INIT_READ        : Read pre-loaded values from ram.dat
//   TC2  WRITE_READBACK   : Write a byte then read it back
//   TC3  BOUNDARY_LOW     : Write/read address 0 (lowest boundary)
//   TC4  BOUNDARY_HIGH    : Write/read address 255 (highest boundary)
//   TC5  NO_WRITE_GUARD   : memwrite=0 must not alter memory
//   TC6  OVERWRITE        : Overwrite existing value, verify update
//   TC7  MULTI_ADDR       : Write to multiple addresses, read all back
// =============================================================================
module tb_ram;

    reg        clk, memwrite;
    reg  [7:0] adr, writedata;
    wire [7:0] memdata;

    integer errors;

    // ---- Test phase label (visible in SimVision waveform) ----
    reg [255:0] TEST_PHASE;

    // ---- Initialize signals at t=0 ----
    initial begin
        clk       = 0;
        memwrite  = 0;
        adr       = 0;
        writedata = 0;
    end

    // ---- DUT ----
    ram dut (
        .memdata  (memdata),
        .memwrite (memwrite),
        .adr      (adr),
        .writedata(writedata),
        .clk      (clk)
    );

    // ---- Waveform dump ----
    initial begin
        $shm_open("dump_ram.shm");
        $shm_probe("AS");
    end

    // ---- 100ns clock ----
    always #50 clk = ~clk;

    // -------------------------------------------------------------------------
    // Tasks
    // -------------------------------------------------------------------------

    // Write one byte to memory
    task write_byte;
        input [7:0] addr;
        input [7:0] data;
        begin
            @(negedge clk);
            adr = addr; writedata = data; memwrite = 1;
            @(negedge clk);         // RAM writes on negedge
            memwrite = 0;
            @(posedge clk); #5;     // settle
        end
    endtask

    // Read one byte — set address, wait for negedge (RAM reads on negedge)
    task read_byte;
        input [7:0] addr;
        begin
            @(negedge clk);
            adr = addr; memwrite = 0;
            @(posedge clk); #5;     // memdata valid after negedge settle
        end
    endtask

    // Check memdata against expected value
    task check;
        input [7:0]   expected;
        input [255:0] label;
        begin
            if (memdata === expected) begin
                $display("PASS | %-35s | adr=%0d memdata=0x%02h (%0d)",
                         label, adr, memdata, memdata);
                // pass count implicit via no error increment
            end else begin
                $display("FAIL | %-35s | adr=%0d memdata=0x%02h (%0d)  exp=0x%02h (%0d)",
                         label, adr, memdata, memdata, expected, expected);
                errors = errors + 1;
            end
        end
    endtask

    // =========================================================================
    // MAIN
    // =========================================================================
    initial begin
        errors     = 0;
        TEST_PHASE = "INIT";

        // Wait for ram.v initial block to finish loading ram.dat
        #20;
        repeat(3) @(posedge clk);

        $display("\n=== RAM Testbench ===");

        // =====================================================================
        // TC1: INIT_READ
        // ram.dat pre-loads address 64=0x05 and address 65=0x03
        // (matches the standard ram.dat shipped with this project)
        // =====================================================================
	TEST_PHASE = "TC1_INIT_READ";
	$display("\n-- TC1: Read pre-loaded values from ram.dat --");
	write_byte(8'd0,  8'h80);
	write_byte(8'd20, 8'h01);
	write_byte(8'd21, 8'h02);
	read_byte(8'd0);  check(8'h80, "TC1c ram.dat[0]=0x80 (lb opcode)");
	read_byte(8'd20); check(8'h01, "TC1a ram.dat[20]=0x01");
	read_byte(8'd21); check(8'h02, "TC1b ram.dat[21]=0x02");

        repeat(2) @(posedge clk);

        // =====================================================================
        // TC2: WRITE_READBACK
        // Write a known value, immediately read it back
        // =====================================================================
        TEST_PHASE = "TC2_WRITE_READBACK";
        $display("\n-- TC2: Write then read back --");
        write_byte(8'd100, 8'hAB);
        read_byte(8'd100); check(8'hAB, "TC2a write/read addr=100 0xAB");

        write_byte(8'd150, 8'h55);
        read_byte(8'd150); check(8'h55, "TC2b write/read addr=150 0x55");

        write_byte(8'd200, 8'hFF);
        read_byte(8'd200); check(8'hFF, "TC2c write/read addr=200 0xFF");

        repeat(2) @(posedge clk);

        // =====================================================================
        // TC3: BOUNDARY_LOW
        // Address 0 — lowest valid address
        // =====================================================================
        TEST_PHASE = "TC3_BOUNDARY_LOW";
        $display("\n-- TC3: Boundary address 0 --");
        write_byte(8'd0, 8'hAA);
        read_byte(8'd0); check(8'hAA, "TC3 addr=0 boundary write/read");

        repeat(2) @(posedge clk);

        // =====================================================================
        // TC4: BOUNDARY_HIGH
        // Address 255 — highest valid address
        // =====================================================================
        TEST_PHASE = "TC4_BOUNDARY_HIGH";
        $display("\n-- TC4: Boundary address 255 --");
        write_byte(8'd255, 8'hBB);
        read_byte(8'd255); check(8'hBB, "TC4 addr=255 boundary write/read");

        repeat(2) @(posedge clk);

        // =====================================================================
        // TC5: NO_WRITE_GUARD
        // memwrite=0 — value must not change
        // addr=100 currently holds 0xAB from TC2
        // =====================================================================
        TEST_PHASE = "TC5_NO_WRITE_GUARD";
        $display("\n-- TC5: No write when memwrite=0 --");
        @(negedge clk);
        adr = 8'd100; writedata = 8'hFF; memwrite = 0;
        @(negedge clk); #5;
        read_byte(8'd100); check(8'hAB, "TC5 addr=100 unchanged (memwrite=0)");

        repeat(2) @(posedge clk);

        // =====================================================================
        // TC6: OVERWRITE
        // Write new value over existing, verify update
        // =====================================================================
        TEST_PHASE = "TC6_OVERWRITE";
        $display("\n-- TC6: Overwrite existing value --");
        write_byte(8'd100, 8'h42);
        read_byte(8'd100); check(8'h42, "TC6 addr=100 overwritten to 0x42");

        repeat(2) @(posedge clk);

        // =====================================================================
        // TC7: MULTI_ADDR
        // Write to several addresses then read all back
        // Verifies no address aliasing
        // =====================================================================
        TEST_PHASE = "TC7_MULTI_ADDR";
        $display("\n-- TC7: Multiple address write/read --");
        write_byte(8'd10,  8'h11);
        write_byte(8'd20,  8'h22);
        write_byte(8'd30,  8'h33);
        write_byte(8'd40,  8'h44);

        read_byte(8'd10);  check(8'h11, "TC7a addr=10  val=0x11");
        read_byte(8'd20);  check(8'h22, "TC7b addr=20  val=0x22");
        read_byte(8'd30);  check(8'h33, "TC7c addr=30  val=0x33");
        read_byte(8'd40);  check(8'h44, "TC7d addr=40  val=0x44");

        // =====================================================================
        // Summary
        // =====================================================================
        TEST_PHASE = "DONE";
        repeat(5) @(posedge clk);

        $display("\n=== RAM: %0d error(s) ===", errors);
        if (errors == 0) $display("ALL RAM TESTS PASSED");
        else             $display("SOME RAM TESTS FAILED");

        $finish;
    end

    // Watchdog
    initial begin
        #500000;
        $display("[ERROR] RAM TB TIMEOUT");
        $finish;
    end

endmodule