################################################################################
# dft_scan.tcl — DFT Scan Insertion for Tiny MIPS CPU
# Tool   : Synopsys Design Compiler (dc_shell) with DFT Compiler
# Usage  : dc_shell -f dft_scan.tcl | tee dft.log
#
# Prerequisites:
#   synthesize.tcl must have been run first.
#   The .ddc file from synthesis is read here.
################################################################################

################################################################################
# 1. SETUP
################################################################################

set DESIGN_NAME  "mips"
set OUTPUT_DIR   "../output"
set REPORT_DIR   "../reports"

file mkdir $OUTPUT_DIR
file mkdir $REPORT_DIR

# ** EDIT: same library as synthesis **
set LIB_DB  "/path/to/your/library/typical.db"

set_app_var target_library  $LIB_DB
set_app_var link_library    "* $LIB_DB"

################################################################################
# 2. READ SYNTHESIZED DESIGN
################################################################################

puts "\n========== Reading synthesized design =========="

# Read the .ddc produced by synthesize.tcl
read_ddc $OUTPUT_DIR/${DESIGN_NAME}.ddc
current_design $DESIGN_NAME
link

# Re-apply SDC constraints (needed for DFT timing checks)
read_sdc $OUTPUT_DIR/${DESIGN_NAME}.sdc

################################################################################
# 3. SCAN CHAIN CONFIGURATION
################################################################################

puts "\n========== Configuring scan =========="

# ---- Test protocol: use a dedicated scan clock on the same clk port ----
# During scan shift, the test clock runs at a slow rate (not at-speed).
# During capture, it runs at functional speed.

# Define the test clock (same pin as functional clock)
set_dft_signal -view spec \
    -type ScanClock \
    -timing [list 45 55] \
    -port clk

# Define reset as an active-high asynchronous test reset
set_dft_signal -view spec \
    -type Reset \
    -active_state 1 \
    -port reset

# ---- Scan I/O ports ----
# We use one scan chain. For a small design like this (~50-100 flip-flops)
# one chain is sufficient. Increase to 2-4 chains for faster ATPG.
set_dft_signal -view spec \
    -type ScanDataIn \
    -port scan_in

set_dft_signal -view spec \
    -type ScanDataOut \
    -port scan_out

set_dft_signal -view spec \
    -type ScanEnable \
    -active_state 1 \
    -port scan_en

# ---- Scan configuration ----
set_scan_configuration \
    -chain_count 1 \
    -style multiplexed_flip_flop \
    -clock_mixing no_mix

# Enable test mode port
set_dft_signal -view spec \
    -type TestMode \
    -active_state 1 \
    -port test_mode

puts "Scan configuration: 1 chain, multiplexed-FF style"

################################################################################
# 4. DFT RULE CHECK (pre-insertion)
################################################################################

puts "\n========== DFT Rule Check (pre-insertion) =========="

# Check the design for DFT rule violations BEFORE inserting scan
dft_drc -verbose > $REPORT_DIR/dft_drc_pre.rpt
puts "Pre-insertion DFT DRC saved to $REPORT_DIR/dft_drc_pre.rpt"

################################################################################
# 5. PREVIEW SCAN CHAINS
################################################################################

puts "\n========== Preview scan chain =========="

# Preview how many flip-flops will be in the scan chain
# This shows chain length BEFORE actual insertion
preview_dft -show [list scan_registers] > $REPORT_DIR/scan_preview.rpt
puts "Scan preview saved."

################################################################################
# 6. INSERT SCAN
################################################################################

puts "\n========== Inserting scan chain =========="

# This rewires all scannable flip-flops into a shift-register chain
insert_dft

puts "Scan insertion complete."

################################################################################
# 7. DFT RULE CHECK (post-insertion)
################################################################################

puts "\n========== DFT Rule Check (post-insertion) =========="

dft_drc -verbose > $REPORT_DIR/dft_drc_post.rpt
puts "Post-insertion DFT DRC saved to $REPORT_DIR/dft_drc_post.rpt"

################################################################################
# 8. POST-DFT INCREMENTAL COMPILE
# Fix any timing violations introduced by scan muxes
################################################################################

puts "\n========== Post-DFT incremental compile =========="

compile -incremental_mapping -scan

################################################################################
# 9. DFT REPORTS
################################################################################

puts "\n========== Generating DFT reports =========="

# Scan chain summary
report_scan_path -chain all -view existing_dft \
    > $REPORT_DIR/scan_chains.rpt

# Full DFT summary
report_dft > $REPORT_DIR/dft_summary.rpt

# Timing after scan insertion
report_timing -path full -delay max -nworst 5 \
    > $REPORT_DIR/timing_post_dft.rpt

# Area after scan insertion
report_area -hierarchy \
    > $REPORT_DIR/area_post_dft.rpt

puts "DFT reports written to $REPORT_DIR/"

################################################################################
# 10. WRITE DFT OUTPUTS
################################################################################

puts "\n========== Writing DFT outputs =========="

# Write scan-inserted netlist
write -format verilog -hierarchy \
    -output $OUTPUT_DIR/${DESIGN_NAME}_scan.v

# Write DFT-modified DDC (for P&R)
write -format ddc -hierarchy \
    -output $OUTPUT_DIR/${DESIGN_NAME}_scan.ddc

# Write updated SDC (scan ports have new timing)
write_sdc $OUTPUT_DIR/${DESIGN_NAME}_scan.sdc

# Write ATPG-ready test protocol file (for TetraMAX or similar)
write_test_protocol -output $OUTPUT_DIR/${DESIGN_NAME}.spf

puts "DFT outputs written to $OUTPUT_DIR/"

################################################################################
# 11. SUMMARY
################################################################################

echo "\n========================================="
echo "  DFT INSERTION COMPLETE"
echo "========================================="
report_dft
echo "========================================="

quit
