################################################################################
# constraints.tcl — Timing & design constraints for Tiny MIPS CPU
# Tool   : Synopsys Design Compiler
# Sourced by synthesize.tcl
#
# Clock period guidance:
#   This is an 8-bit multicycle processor — it is NOT performance-critical.
#   A 100 MHz (10 ns) clock is realistic and safe for a university standard cell
#   library (saed32, nangate45, gscl45nm).
#   If your library is slow (older 180 nm or 130 nm), use 20 ns (50 MHz).
#   Adjust CLK_PERIOD below based on your library's speed grade.
################################################################################

################################################################################
# 1. CLOCK DEFINITION
################################################################################

set CLK_PERIOD    10.0        ;# nanoseconds — 100 MHz target
set CLK_SKEW       0.5        ;# estimated clock network skew
set CLK_JITTER     0.1        ;# clock source jitter
set CLK_TRAN       0.1        ;# clock transition time

# Create the main clock on the clk port
create_clock -name "clk" \
             -period $CLK_PERIOD \
             -waveform [list 0 [expr $CLK_PERIOD / 2.0]] \
             [get_ports clk]

# Set clock uncertainty (skew + jitter)
set_clock_uncertainty -setup [expr $CLK_SKEW + $CLK_JITTER] [get_clocks clk]
set_clock_uncertainty -hold  0.2                              [get_clocks clk]

# Clock transition (slew)
set_clock_transition $CLK_TRAN [get_clocks clk]

# Mark clock network — DC should not optimize through it
set_dont_touch_network [get_clocks clk]

puts "Clock: clk @ $CLK_PERIOD ns period ([expr 1000.0/$CLK_PERIOD] MHz)"

################################################################################
# 2. INPUT / OUTPUT DELAYS
# These model the external logic that drives/receives the CPU ports.
# Using 20% of clock period for inputs, 20% for outputs — conservative.
################################################################################

set INPUT_DELAY  [expr $CLK_PERIOD * 0.20]
set OUTPUT_DELAY [expr $CLK_PERIOD * 0.20]

# All inputs except clk and reset
set_input_delay $INPUT_DELAY -clock clk \
    [remove_from_collection [get_ports {memdata[*]}] [get_ports {clk reset}]]

# Reset: give it a full cycle (it's a static signal relative to clock)
set_input_delay [expr $CLK_PERIOD * 0.05] -clock clk [get_ports reset]

# All outputs
set_output_delay $OUTPUT_DELAY -clock clk \
    [get_ports {memread memwrite adr[*] writedata[*]}]

puts "Input delay:  $INPUT_DELAY ns"
puts "Output delay: $OUTPUT_DELAY ns"

################################################################################
# 3. INPUT DRIVE STRENGTH
# Model that inputs are driven by a medium-strength flip-flop output.
# If your library doesn't have DFFX1, use whatever your TA specifies
# or simply use set_driving_cell with a basic buffer/inverter.
################################################################################

# Generic approach — works with most libraries
set_input_transition 0.1 [get_ports {memdata[*]}]
set_input_transition 0.1 [get_ports reset]

# If your library supports set_driving_cell, replace lines above with:
# set_driving_cell -lib_cell DFFX1 -pin Q [get_ports {memdata[*]}]

################################################################################
# 4. OUTPUT LOAD
# Model that outputs drive a small capacitive load (e.g., one gate input).
################################################################################

set_load 0.05 [get_ports {memread memwrite adr[*] writedata[*]}]

################################################################################
# 5. TIMING EXCEPTIONS
#
# The multicycle controller FSM has some paths that are intentionally
# multi-cycle because the datapath takes multiple clock cycles to produce
# a result. The critical paths are:
#   - Controller next-state logic (single cycle — no exception needed)
#   - ALU path from src1/src2 to aluresult (single cycle)
#   - PC register through mux to next PC (single cycle)
#
# NO multicycle path constraints are needed here because in the RTL,
# each register (flop, flopenr, etc.) is clocked every cycle — the
# "multicycle" behavior is achieved by the enable signals, not by
# relaxing timing. So all paths are single-cycle.
#
# If you add pipelining later, add set_multicycle_path constraints here.
################################################################################

# False path on reset (static signal, no timing analysis needed on async path)
# Uncomment if DC flags reset paths as critical:
# set_false_path -from [get_ports reset]

################################################################################
# 6. AREA & POWER CONSTRAINTS
################################################################################

# Set a max area target — 0 means "minimize area as much as possible
# after meeting timing". Increase this number if compile takes too long.
set_max_area 0

# Leakage power optimization (requires -power option in compile_ultra)
# set_leakage_optimization true

################################################################################
# 7. DESIGN RULE CONSTRAINTS
# These override library defaults to be safe for a small educational design.
################################################################################

set_max_transition 0.5  [current_design]
set_max_fanout     20   [current_design]
set_max_capacitance 0.5 [current_design]

################################################################################
# 8. DONT-TOUCH / DONT-USE
# Prevent DC from replacing the RAM behavioral model (it won't synthesize)
# The ram module is excluded from the synthesized design — only mips is
# synthesized. If DC somehow picks it up, add:
# set_dont_touch [get_cells -hierarchical -filter "ref_name == ram"]
################################################################################

# Keep module hierarchy readable in reports
set_app_var compile_preserve_subdesign_interfaces true

puts "\n=== Constraints applied successfully ==="
puts "Target: $CLK_PERIOD ns clock, area minimization ON"
