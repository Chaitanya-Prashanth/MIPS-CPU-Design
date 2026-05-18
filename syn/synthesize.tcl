################################################################################
# synthesize.tcl — Synopsys Design Compiler synthesis script
# Project : Tiny MIPS CPU
# Tool    : Synopsys Design Compiler (dc_shell)
# Usage   : dc_shell -f synthesize.tcl | tee synth.log
################################################################################

################################################################################
# 1. SETUP — paths and design name
################################################################################

set DESIGN_NAME   "mips"
set RTL_DIR       "../rtl"
set OUTPUT_DIR    "../output"
set REPORT_DIR    "../reports"
set SCRIPTS_DIR   "."

# ---- Create output directories if they don't exist ----
file mkdir $OUTPUT_DIR
file mkdir $REPORT_DIR

################################################################################
# 2. LIBRARY SETUP
# Replace the lib name below with whatever your university provides.
# Common university libraries:
#   typical corner : "typical.db"  or  "slow.db"  or  "fast.db"
#   saed32 (Stanford) : "saed32lvt_tt1p05v25c.db"
#   nangate45       : "NangateOpenCellLibrary_typical.db"
#   gscl45nm        : "gscl45nm.db"
# Ask your TA for the exact .db filename and its full path.
################################################################################

# ** EDIT THIS LINE — set to your library .db file path **
set LIB_DB  "/path/to/your/library/typical.db"

# Set search paths so DC can find the library
set_app_var search_path      ". $RTL_DIR $SCRIPTS_DIR"
set_app_var target_library   $LIB_DB
set_app_var link_library     "* $LIB_DB"
set_app_var symbol_library   ""

################################################################################
# 3. READ RTL SOURCES
################################################################################

puts "\n========== Reading RTL =========="

# Read all leaf modules first, then top-level
analyze -format verilog $RTL_DIR/alu.v
analyze -format verilog $RTL_DIR/alucontrol.v
analyze -format verilog $RTL_DIR/flop.v
analyze -format verilog $RTL_DIR/flopen.v
analyze -format verilog $RTL_DIR/flopenr.v
analyze -format verilog $RTL_DIR/mux2.v
analyze -format verilog $RTL_DIR/mux4.v
analyze -format verilog $RTL_DIR/mux23.v
analyze -format verilog $RTL_DIR/zerodetect.v
analyze -format verilog $RTL_DIR/regfile.v
analyze -format verilog $RTL_DIR/datapath.v
analyze -format verilog $RTL_DIR/controller.v
analyze -format verilog $RTL_DIR/mips.v

# Elaborate the top-level design
elaborate $DESIGN_NAME

# Confirm the current design is the top
current_design $DESIGN_NAME
link

puts "\n========== Design Elaborated =========="

################################################################################
# 4. DESIGN CONSTRAINTS
# Source the separate constraints file (keeps this script clean)
################################################################################

puts "\n========== Applying Constraints =========="
source $SCRIPTS_DIR/constraints.tcl

################################################################################
# 5. COMPILE OPTIONS
################################################################################

puts "\n========== Starting Compilation =========="

# Check design for issues before compiling
check_design > $REPORT_DIR/check_design.rpt
puts "check_design report saved."

# Compile with high effort
# -map_effort high    : best quality mapping
# -area_effort high   : minimize area after timing is met
compile_ultra -no_autoungroup

# Second-pass incremental compile to clean up any remaining violations
compile -incremental_mapping -map_effort medium

puts "\n========== Compilation Done =========="

################################################################################
# 6. POST-COMPILE REPORTS
################################################################################

puts "\n========== Generating Reports =========="

# Timing report — critical path
report_timing -path full -delay max -nworst 5 -max_paths 10 \
    > $REPORT_DIR/timing.rpt

# Setup timing (hold is less critical for this design)
report_timing -path full -delay min -nworst 3 \
    > $REPORT_DIR/timing_hold.rpt

# Area report
report_area -hierarchy \
    > $REPORT_DIR/area.rpt

# Power report (switching activity estimated)
report_power -analysis_effort high \
    > $REPORT_DIR/power.rpt

# Cell/reference report
report_cell  > $REPORT_DIR/cells.rpt
report_reference > $REPORT_DIR/references.rpt

# Constraint violations summary
report_constraint -all_violators \
    > $REPORT_DIR/violations.rpt

# QOR (quality of results) summary
report_qor > $REPORT_DIR/qor.rpt

puts "All reports written to $REPORT_DIR/"

################################################################################
# 7. WRITE OUTPUTS
################################################################################

puts "\n========== Writing Outputs =========="

# Write synthesized gate-level netlist
write -format verilog -hierarchy \
    -output $OUTPUT_DIR/${DESIGN_NAME}_netlist.v

# Write synthesized design in DC internal format (for DFT next step)
write -format ddc -hierarchy \
    -output $OUTPUT_DIR/${DESIGN_NAME}.ddc

# Write SDF (Standard Delay Format) for gate-level simulation
write_sdf $OUTPUT_DIR/${DESIGN_NAME}.sdf

# Write SDC constraints (for use in DFT and P&R)
write_sdc $OUTPUT_DIR/${DESIGN_NAME}.sdc

puts "Outputs written to $OUTPUT_DIR/"

################################################################################
# 8. FINAL SUMMARY
################################################################################

echo "\n========================================="
echo "  SYNTHESIS COMPLETE — SUMMARY"
echo "========================================="
report_timing -nworst 1
report_area
echo "========================================="

quit
