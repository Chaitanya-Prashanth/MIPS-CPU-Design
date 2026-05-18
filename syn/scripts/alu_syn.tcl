##################################################################
#### Design Compiler Synthesis Script
#### Module: alu
#### Combinational design — virtual clock
#### Process: AMI 0.5um (osu05_stdcells.db)
#### Run from: syn/scripts/
#### RTL source: ../../src/
#### Reports:    ../reports/
#### Netlists:   ../netlists/
##################################################################

####################################
# MODULE-SPECIFIC SETTINGS
####################################
set myFiles      [list ../../src/alu.v]
set basename     alu
set myClk        clk
set virtual      1                 ;# combinational — no real clock port
set myPeriod_ns  10              ;# 100 MHz timing budget

####################################
# Runtime options
####################################
set runname        syn
set exit_dc        0
set target_library [list osu05_stdcells.db]

####################################
# Timing and loading
####################################
set myClkLatency_ns  0.3
set myInDelay_ns     2.0
set myOutDelay_ns    1.65
set myInputBuf       INVX1
set myLoadLibrary    [file rootname $target_library]
set myLoadPin        A
set myMaxFanout      1
set myOutputLoad     0.1

####################################
# Compiler switches
####################################
set optimizeArea  1
set useUltra      1
set useUngroup    0

set link_library [concat [concat "*" $target_library] $synthetic_library]
set verbose      0
set fileFormat   verilog

##################################################################
### DO NOT CHANGE BELOW THIS LINE
##################################################################

remove_design -all

echo IMPORTING DESIGN
analyze -format $fileFormat -lib WORK $myFiles
elaborate $basename -lib WORK -update
current_design $basename
link
uniquify

echo SETTING CONSTRAINTS
if { $virtual == 0 } {
    create_clock -period $myPeriod_ns $myClk
} else {
    create_clock -period $myPeriod_ns -name $myClk
}
set_clock_latency $myClkLatency_ns $myClk

if { $virtual == 0 } {
    set_input_delay $myInDelay_ns -clock $myClk [all_inputs]
} else {
    set_input_delay $myInDelay_ns -clock $myClk [remove_from_collection [all_inputs] $myClk]
}
set_output_delay $myOutDelay_ns -clock $myClk [all_outputs]

if { $virtual == 0 } {
    set_driving_cell -library $myLoadLibrary -lib_cell $myInputBuf [all_inputs]
} else {
    set_driving_cell -library $myLoadLibrary -lib_cell $myInputBuf [remove_from_collection [all_inputs] $myClk]
}

set_load        $myOutputLoad [all_outputs]
set_max_fanout  $myMaxFanout  [all_inputs]
set_fanout_load 8             [all_outputs]

echo DONE SETTING CONSTRAINTS
set_fix_multiple_port_nets -all -buffer_constants

echo BEGIN COMPILING DESIGN
if { $optimizeArea == 1 } { set_max_area 0 }
if { $useUltra == 1 } {
    compile_ultra
} else {
    if { $useUngroup == 1 } {
        compile -ungroup_all -map_effort medium
    } else {
        compile -map_effort medium -exact_map
    }
}
check_design
echo VIOLATIONS
report_constraint -all_violators

echo OUTPUT FILES AND REPORTS
set filebase [format "%s%s" [format "%s%s" $basename "_"] $runname]

# Synthesized netlist
set filename [format "%s%s%s" ../netlists/ $filebase ".v"]
redirect change_names { change_names -rules verilog -hierarchy -verbose }
write -format verilog -hierarchy -output $filename

# SDF for back-annotation
set filename [format "%s%s%s" ../netlists/ $filebase ".sdf"]
write_sdf -version 1.0 $filename

# SDC for P&R
set filename [format "%s%s%s" ../netlists/ $filebase ".sdc"]
write_sdc $filename

# Reports
set filename [format "%s%s%s" ../reports/ $filebase ".design"]
redirect $filename { report_design }
redirect -append $filename { report_hierarchy }

set filename [format "%s%s%s" ../reports/ $filebase ".timing"]
redirect $filename { report_timing -path full -delay max -nworst 5 -significant_digits 2 -sort_by group }
redirect -append $filename { report_timing -path full -delay min -nworst 5 -significant_digits 2 -sort_by group }

set filename [format "%s%s%s" ../reports/ $filebase ".area"]
redirect $filename { report_area }
redirect -append $filename { report_cell }

set filename [format "%s%s%s" ../reports/ $filebase ".ports"]
redirect $filename { report_port -v }

set filename [format "%s%s%s" ../reports/ $filebase ".net"]
redirect $filename { report_net }

set filename [format "%s%s%s" ../reports/ $filebase ".pow"]
redirect $filename { report_power -analysis_effort low }

if { $exit_dc == 1 } { exit }
