================================================================================
  TINY MIPS CPU — SYNOPSYS DESIGN COMPILER FLOW
  Step-by-step instructions for university lab
================================================================================

DIRECTORY STRUCTURE
-------------------
mips_project/
├── rtl/                  ← All your Verilog source files go here
│   ├── alu.v
│   ├── alucontrol.v
│   ├── controller.v
│   ├── datapath.v
│   ├── flop.v
│   ├── flopen.v
│   ├── flopenr.v
│   ├── mux2.v
│   ├── mux4.v
│   ├── mux23.v
│   ├── zerodetect.v
│   ├── regfile.v
│   ├── mips.v            ← use this for synthesis (no scan ports)
│   └── mips_scan.v       ← use this for DFT (has scan ports)
│
├── sim/                  ← Simulation files
│   ├── ram.v
│   ├── ram.dat
│   ├── tb_mips.v
│   └── Makefile
│
├── scripts/              ← All TCL scripts
│   ├── synthesize.tcl    ← Step 1: Synthesis
│   ├── constraints.tcl   ← Sourced by synthesize.tcl automatically
│   ├── dft_scan.tcl      ← Step 2: DFT scan insertion
│   ├── atpg.tcl          ← Step 3 (optional): ATPG
│   └── tb_gate.v         ← Gate-level simulation testbench
│
├── output/               ← Auto-created — synthesized netlists go here
└── reports/              ← Auto-created — all reports go here


================================================================================
BEFORE YOU START — ASK YOUR TA FOR:
================================================================================

  1. The full path to your .db library file
     e.g.  /usr/local/synopsys/lib/saed32/typical.db
           /eda/libraries/nangate45/NangateOpenCellLibrary_typical.db

  2. The full path to the Verilog cell models (.v) for gate-level sim
     e.g.  /usr/local/synopsys/lib/saed32/saed32.v

  3. The module name of a basic D flip-flop in that library
     (for set_driving_cell — optional but good practice)

  Then edit the two lines marked "** EDIT THIS LINE **" in:
     scripts/synthesize.tcl  (line ~25)
     scripts/dft_scan.tcl    (line ~21)

  Replace:  set LIB_DB  "/path/to/your/library/typical.db"
  With:     set LIB_DB  "/actual/path/from/your/TA"


================================================================================
STEP 1 — RTL SIMULATION (do this first, on your laptop)
================================================================================

  cd sim/
  make sim          # compiles + runs with Icarus Verilog
  make waves        # opens GTKWave to view waveforms

  Expected output:
    PASS: mem[255] = 3
    PASS: $s2 = 1
    PASS: $s3 = 2
    PASS: $s1 = 3
    ALL TESTS PASSED

  Do NOT proceed to synthesis until RTL simulation passes completely.


================================================================================
STEP 2 — SYNTHESIS (on university server with DC license)
================================================================================

  # Log into the university server, load Synopsys tools
  module load synopsys          # or however your school loads tools
  # OR: source /etc/profile.d/synopsys.sh

  # Navigate to scripts directory
  cd scripts/

  # Run Design Compiler in batch mode
  dc_shell -f synthesize.tcl | tee synth.log

  # The script runs automatically — when it finishes check:
  #   reports/timing.rpt     → look for "slack (MET)" — means timing passed
  #   reports/area.rpt       → note total cell area number for your report
  #   reports/violations.rpt → should say "No violated constraints"
  #   output/mips_netlist.v  → your synthesized gate-level netlist

  Reading the timing report:
    Look for this pattern:
      slack (MET) :   X.XX   ← GOOD: timing constraint met
      slack (VIOLATED) : -X.XX  ← BAD: need to relax clock or fix RTL

    If you get VIOLATED:
      → Open constraints.tcl and increase CLK_PERIOD (e.g. 10 → 15 ns)
      → Re-run synthesis

  Reading the area report:
    Look for:
      Total cell area: XXXX  ← record this for your report


================================================================================
STEP 3 — DFT SCAN INSERTION (on university server)
================================================================================

  # Make sure synthesis ran successfully first (output/mips.ddc must exist)
  cd scripts/

  dc_shell -f dft_scan.tcl | tee dft.log

  Check these reports:
    reports/dft_drc_pre.rpt    → pre-insertion DRC (note any violations)
    reports/dft_drc_post.rpt   → post-insertion DRC (should be clean)
    reports/scan_chains.rpt    → shows flip-flop count in scan chain
    reports/dft_summary.rpt    → overall DFT summary

  In your report, note:
    - Number of flip-flops in scan chain (from scan_chains.rpt)
    - Any DFT rule violations and how you resolved them
    - Screenshot of dft_summary.rpt


================================================================================
STEP 4 — GATE-LEVEL SIMULATION (verify netlist matches RTL)
================================================================================

  # Run on your laptop or the server — needs the library .v cell models
  iverilog -o sim_gate \
      ../output/mips_netlist.v \
      /path/to/library/cells.v \
      ../sim/ram.v \
      tb_gate.v
  vvp sim_gate

  Expected: same PASS results as RTL simulation.
  If results differ: the synthesis introduced a bug — check timing reports
  for violations and re-synthesize with a relaxed clock period.


================================================================================
STEP 5 — ATPG (OPTIONAL — extra credit for solo student)
================================================================================

  # Requires TetraMAX license
  tmax -tcl atpg.tcl | tee atpg.log

  Target: > 90% stuck-at fault coverage
  Check: reports/atpg_summary.rpt


================================================================================
STEP 6 — PLACE AND ROUTE (Cadence Innovus or Synopsys ICC2)
================================================================================

  For Innovus (Cadence):
    innovus -batch -files innovus_flow.tcl

  For ICC2 (Synopsys):
    icc2_shell -f icc2_flow.tcl

  You will need from synthesis:
    output/mips_scan.v       ← gate-level netlist (with scan)
    output/mips_scan.sdc     ← timing constraints
    A .lef file for the cell library  ← ask your TA

  Minimum screenshots for your report:
    1. Floorplan view
    2. Placement view (filled with cells)
    3. Final routing view (all wires connected)
    4. Post-route timing summary (slack values)


================================================================================
COMMON ERRORS AND FIXES
================================================================================

ERROR: "Cannot find library file"
  FIX: The LIB_DB path is wrong. Run: ls /path/you/typed  to verify it exists.

ERROR: "Unresolved references" during link
  FIX: Make sure all .v files are listed in the analyze commands in order
  (leaf modules before top module). Check module names match file names.

ERROR: "slack VIOLATED" in timing report
  FIX: Increase CLK_PERIOD in constraints.tcl (e.g., 10→15→20 ns)
  and re-run synthesis. This design easily meets 20 ns (50 MHz).

ERROR: "DFT DRC violation: clock not defined"
  FIX: Make sure set_dft_signal for ScanClock uses the exact port name "clk"
  as it appears in your Verilog.

ERROR: dc_shell not found
  FIX: Run:  module avail  to see available tools, then load the correct one.
  Ask your TA for the exact module load command.

ERROR: $readmemb fails to load ram.dat
  FIX: The ram.dat file must be in the same directory where you run the
  simulation, OR provide a full path in ram.v:
     $readmemb("/full/path/to/ram.dat", mips_ram);


================================================================================
WHAT TO INCLUDE IN YOUR REPORT FROM EACH STEP
================================================================================

  Synthesis:
    □ Clock constraint value used (period, frequency)
    □ Screenshot or copy of timing report showing slack (MET)
    □ Total cell area number from area report
    □ Power estimate if available

  DFT:
    □ Number of flip-flops in scan chain
    □ Screenshot of DFT DRC post-insertion (should show 0 violations)
    □ Scan chain summary (chain length, clock used)

  P&R:
    □ Three screenshots: floorplan, placement, routing
    □ Post-route worst negative slack (WNS) value
    □ Post-route total negative slack (TNS) if available

================================================================================
