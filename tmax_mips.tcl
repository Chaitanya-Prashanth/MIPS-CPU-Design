##################################################################
#### TetraMax Script for ECE 6250
#### Performs ATPG Pattern Generation for Tiny MIPS CPU
#### Based on format by tjf/wgibb
#### note: this script will only run in TMAX TCL mode
#### start tmax like this:   tmax -tcl
####
#### Run from: project root directory
#### Inputs:
####   dft/netlists/mips_scan.v    scan-inserted netlist
####   dft/netlists/mips_scan.spf  test protocol from DFT compiler
####   src/osu05_stdcells.v        standard cell verilog library
####   src/osu_scan.v              scan cell verilog library
#### Outputs:
####   src/mips_scan_tb_patterns.v  ATPG test patterns
####   reports/mips.tmax.patterns   pattern report
####   reports/mips.tmax.violations violation report
####   reports/mips.tmax.coverage   fault coverage report
##################################################################


############################################################
#### local variables — update these for your design     ####
############################################################

set top_module       mips
set synthesized_files [list ./dft/netlists/mips_scan.v]
set cell_lib         ./src/osu05_stdcells.v
set scan_lib         ./src/osu_scan.v
set stil_file        [list ./dft/netlists/mips_scan.spf]


#################################################
#### read in standard cells and user's design ###
#################################################

# remove any other designs from memory
read_netlist -delete

# read in standard cell library
read_netlist $cell_lib -library

# read in scan cell library
read_netlist $scan_lib -library

# read in scan-inserted synthesized netlist
read_netlist $synthesized_files


#################################################
#### BUILD and DRC test model
#################################################

run_build_model $top_module
# ignoring warnings like N20 or B10

# Set STIL file from DFT Compiler
set_drc $stil_file

# run DRC to check for testing rule violations
run_drc


#################################################
#### Generate ATPG (patterns) - full sequential
#################################################

# capture all faults, 9 capture cycles
set_atpg -capture_cycles 9 -full_seq_atpg
remove_faults -all
add_faults -all

# run atpg in full sequential mode
run_atpg full_sequential_only

# write out patterns (overwrite old files)
write_patterns ./src/${top_module}_scan_tb_patterns.v \
    -replace \
    -internal \
    -format verilog_single_file \
    -parallel 0


#################################################
#### Output reports
#################################################

report_patterns   -all >> ./reports/${top_module}.tmax.patterns
report_violations -all >> ./reports/${top_module}.tmax.violations
report_faults -summary -collapsed >> ./reports/${top_module}.tmax.coverage


#################################################
#### Analyze Faults
#### Uncomment to inspect specific fault classes
#################################################

# Show untestable faults (AU) — understand why they cannot be tested
#analyze_faults -class au
#analyze_faults -class au -verbose -max 10

# Show not-detected faults (ND)
#analyze_faults -class nd
#analyze_faults -class nd -verbose -max 5

# Inspect specific cell fault (example — uncomment and modify as needed)
# analyze_faults cont_state_reg_0_/p_dregscan0/q -stuck 1
# analyze_faults dp_pcreg_q_reg_0_/p_dregscan0/q -stuck 0