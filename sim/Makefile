################################################################################
# Makefile — Individual module testbenches for Tiny MIPS CPU
# Usage:
#   make tb_alu          — compile and run ALU testbench
#   make tb_alucontrol   — compile and run ALU control testbench
#   make tb_flops        — compile and run flop testbenches
#   make tb_muxes        — compile and run mux testbenches
#   make tb_zerodetect   — compile and run zero detect testbench
#   make tb_regfile      — compile and run register file testbench
#   make tb_controller   — compile and run controller FSM testbench
#   make all             — run ALL individual testbenches in sequence
#   make clean           — remove compiled files and logs
#
# Set RTL to the directory containing your .v source files
################################################################################

RTL = ../rtl

# ---- Individual module testbenches ----

tb_alu:
	@echo "\n=============================="
	@echo "  Running: ALU"
	@echo "=============================="
	iverilog -o _sim_alu $(RTL)/alu.v tb_alu.v
	vvp _sim_alu | tee log_alu.txt

tb_alucontrol:
	@echo "\n=============================="
	@echo "  Running: ALU Control"
	@echo "=============================="
	iverilog -o _sim_alucontrol $(RTL)/alucontrol.v tb_alucontrol.v
	vvp _sim_alucontrol | tee log_alucontrol.txt

tb_flops:
	@echo "\n=============================="
	@echo "  Running: Flops (flop/flopen/flopenr)"
	@echo "=============================="
	iverilog -o _sim_flops $(RTL)/flop.v $(RTL)/flopen.v $(RTL)/flopenr.v tb_flops.v
	vvp _sim_flops | tee log_flops.txt

tb_muxes:
	@echo "\n=============================="
	@echo "  Running: Muxes (mux2/mux4/mux23)"
	@echo "=============================="
	iverilog -o _sim_muxes $(RTL)/mux2.v $(RTL)/mux4.v $(RTL)/mux23.v tb_muxes.v
	vvp _sim_muxes | tee log_muxes.txt

tb_zerodetect:
	@echo "\n=============================="
	@echo "  Running: Zero Detect"
	@echo "=============================="
	iverilog -o _sim_zerodetect $(RTL)/zerodetect.v tb_zerodetect.v
	vvp _sim_zerodetect | tee log_zerodetect.txt

tb_regfile:
	@echo "\n=============================="
	@echo "  Running: Register File"
	@echo "=============================="
	iverilog -o _sim_regfile $(RTL)/regfile.v tb_regfile.v
	vvp _sim_regfile | tee log_regfile.txt

tb_controller:
	@echo "\n=============================="
	@echo "  Running: Controller FSM"
	@echo "=============================="
	iverilog -o _sim_controller $(RTL)/controller.v tb_controller.v
	vvp _sim_controller | tee log_controller.txt

# ---- Run all testbenches ----
all: tb_alu tb_alucontrol tb_flops tb_muxes tb_zerodetect tb_regfile tb_controller
	@echo "\n=============================="
	@echo "  ALL UNIT TESTS COMPLETE"
	@echo "  Check log_*.txt for details"
	@echo "=============================="
	@echo "\nPASS/FAIL summary:"
	@grep -h "PASSED\|FAILED\|error(s)" log_*.txt

# ---- Waveforms (per module) ----
waves_alu: _sim_alu
	vvp _sim_alu -vcd alu_waves.vcd
	gtkwave alu_waves.vcd &

waves_controller: _sim_controller
	vvp _sim_controller -vcd ctrl_waves.vcd
	gtkwave ctrl_waves.vcd &

# ---- Clean ----
clean:
	rm -f _sim_* log_*.txt *.vcd

.PHONY: tb_alu tb_alucontrol tb_flops tb_muxes tb_zerodetect \
        tb_regfile tb_controller all clean waves_alu waves_controller
