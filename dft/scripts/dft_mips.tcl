##################################################################
#### Design Compiler DFT/Scan Insertion Script
#### Module: mips (top-level CPU)
#### Tool:   Synopsys Design Compiler O-2018.06-SP1
#### Process: AMI 0.5um (osu05_stdcells.db + osu_scan.db)
####
#### Reads synthesized netlist from syn/netlists/
#### Writes scan-inserted netlist to dft/netlists/
#### Writes reports to dft/reports/
####
#### Run from: dft/scripts/
##################################################################

####################################
# SETTINGS — update as needed
####################################
set basename        mips
set myClk           clk
set myPeriod_ns     10             ;# must match synthesis period

set dft_runname     scan
set scan_library    [list osu_scan.db]
set scancell        DFFPOSX1_SCAN

# Timing variables for dft_drc
set test_default_delay        0
set test_default_bidir_delay  0
set test_default_strobe       40
set test_default_period       100
set test_default_scan_style   multiplexed_flip_flop

set exit_dc         0
set verbose_dft     1             ;# 1 = print reports to screen

####################################
# Libraries
####################################
set target_library  [list osu05_stdcells.db]
set link_library    [concat [concat "*" $target_library] $synthetic_library]

##################################################################
### DO NOT CHANGE BELOW THIS LINE
##################################################################

####################################
# Step 1: Read synthesized netlist
####################################
remove_design -all

echo "=== Reading synthesized netlist ==="
read_file -format verilog ../../syn/netlists/${basename}_syn.v
current_design $basename
link

####################################
# Step 2: Re-apply timing constraints
####################################
echo "=== Applying timing constraints ==="
source ../../syn/netlists/${basename}_syn.sdc

####################################
# Step 3: Add scan library to target
####################################
echo "=== Adding scan library ==="
set target_library [list osu05_stdcells.db]
# $scan_library
set link_library   [concat [concat "*" $target_library] $synthetic_library]

####################################
# Step 4: Set scan cell type
####################################
set_scan_register_type -type ${scancell}

####################################
# Step 5: Scan configuration
####################################
set_scan_configuration -create_dedicated_scan_out_ports true

####################################
# Step 6: Infer clock and reset
####################################
echo "=== Creating test protocol ==="
create_test_protocol -infer_async -infer_clock

####################################
# Step 7: DFT DRC (pre-insertion check)
####################################
echo "=== Running DFT DRC ==="
dft_drc -verbose

####################################
# Step 8: compile -scan
# Replaces normal FFs with scan-capable FFs
####################################
echo "=== Compiling with scan ==="
compile -scan

####################################
# Step 9: Check timing after compile -scan
####################################
report_constraint -all_violators

####################################
# Step 10: Insert scan chain
####################################
echo "=== Inserting scan chain ==="
insert_dft

####################################
# Step 11: Set drive strength on scan ports
####################################
set_drive 2 test_si
set_drive 2 test_se

####################################
# Step 12: Disable scan replacement
# (prevents double insertion if insert_dft runs again)
####################################
set_scan_configuration -replace false

####################################
# Step 13: Re-run insert_dft for
# drive strength constraints
####################################
insert_dft

####################################
# Step 14: Write reports
####################################
echo "=== Writing DFT reports ==="
set filebase [format "%s_%s" $basename $dft_runname]

# Timing violations
set filename [format "%s%s%s" ../../dft/reports/ $filebase ".violators"]
redirect $filename { report_constraint -all_violators }

# DFT DRC with coverage estimate
set filename [format "%s%s%s" ../../dft/reports/ $filebase ".dft_drc"]
redirect $filename { dft_drc -verbose -coverage_estimate }

# Scan path report
set filename [format "%s%s%s" ../../dft/reports/ $filebase ".scan_path"]
redirect $filename { report_scan_path -view existing -chain all }

# Cell report
set filename [format "%s%s%s" ../../dft/reports/ $filebase ".cell"]
redirect $filename { report_cell }

# Timing after DFT
set filename [format "%s%s%s" ../../dft/reports/ $filebase ".timing"]
redirect $filename {
    report_timing -path full -delay max -nworst 5 \
        -significant_digits 2 -sort_by group
}

# Area after DFT
set filename [format "%s%s%s" ../../dft/reports/ $filebase ".area"]
redirect $filename { report_area }

# Power after DFT
set filename [format "%s%s%s" ../../dft/reports/ $filebase ".pow"]
redirect $filename { report_power -analysis_effort low }

####################################
# Step 15: Write test protocol
####################################
set filename [format "%s%s%s" ../../dft/netlists/ $filebase ".spf"]
write_test_protocol -output $filename
echo "Test protocol: $filename"

####################################
# Step 16: Write scan-inserted netlist
####################################
echo "=== Writing scan netlist ==="
set filename [format "%s%s%s" ../../dft/netlists/ $filebase ".v"]
redirect change_names { change_names -rules verilog -hierarchy -verbose }
write -format verilog -hierarchy -output $filename
echo "Scan netlist: $filename"

# SDC for P&R
set filename [format "%s%s%s" ../../dft/netlists/ $filebase ".sdc"]
write_sdc $filename
echo "SDC: $filename"

# SDF
set filename [format "%s%s%s" ../../dft/netlists/ $filebase ".sdf"]
write_sdf -version 1.0 $filename

echo ""
echo "============================================"
echo " DFT INSERTION COMPLETE"
echo " Key reports in ../../dft/reports/:"
echo "   ${filebase}.dft_drc    <- DRC violations"
echo "   ${filebase}.scan_path  <- scan chain info"
echo "   ${filebase}.timing     <- timing after DFT"
echo "   ${filebase}.violators  <- timing violations"
echo " Netlist: ../../dft/netlists/${filebase}.v"
echo "============================================"

if { $exit_dc == 1 } { exit }
