###############################################################################
# Makefile — Cadence Xcelium Simulation
# Usage:
#   make mips          — run top-level CPU testbench
#   make alu           — run ALU unit testbench
#   make alucontrol    — run ALUControl unit testbench
#   make regfile       — run RegFile unit testbench
#   make ram           — run RAM unit testbench
#   make controller    — run Controller unit testbench
#   make datapath      — run Datapath unit testbench
#   make all           — run all testbenches
#   make clean         — remove generated files
###############################################################################

XRUN    = xrun
XFLAGS  = -timescale 1ns/10ps -access +rwc

# Source directory (change if your .v files are elsewhere)
SRC     = .

# All RTL submodule files (shared across targets)
SUBMOD  = $(SRC)/flop.v        \
          $(SRC)/flopen.v      \
          $(SRC)/flopenr.v     \
          $(SRC)/mux2.v        \
          $(SRC)/mux4.v        \
          $(SRC)/mux23.v       \
          $(SRC)/zerodetect.v  \
          $(SRC)/alu.v         \
          $(SRC)/alucontrol.v  \
          $(SRC)/regfile.v     \
          $(SRC)/datapath.v    \
          $(SRC)/controller.v  \
          $(SRC)/mips.v        \
          $(SRC)/ram.v

.PHONY: all mips alu alucontrol regfile ram controller datapath clean

# --------------------------------------------------------------------------
# Run all testbenches
# --------------------------------------------------------------------------
all: alu alucontrol regfile ram controller datapath mips
	@echo ""
	@echo "========================================="
	@echo " All simulations complete."
	@echo " grep -i fail *.log to check for errors."
	@echo "========================================="

# --------------------------------------------------------------------------
# Top-level MIPS CPU
# --------------------------------------------------------------------------
mips: $(SUBMOD) $(SRC)/tb_mips.v
	@echo "--- Running MIPS top-level TB ---"
	$(XRUN) $(XFLAGS) \
	    $(SUBMOD) \
	    $(SRC)/tb_mips.v \
	    -top tb_mips \
	    -log mips.log
	@echo "Log: mips.log"

# --------------------------------------------------------------------------
# ALU
# --------------------------------------------------------------------------
alu: $(SRC)/alu.v $(SRC)/tb_alu.v
	@echo "--- Running ALU TB ---"
	$(XRUN) $(XFLAGS) \
	    $(SRC)/alu.v \
	    $(SRC)/tb_alu.v \
	    -top tb_alu \
	    -log alu.log
	@echo "Log: alu.log"

# --------------------------------------------------------------------------
# ALU Control
# --------------------------------------------------------------------------
alucontrol: $(SRC)/alucontrol.v $(SRC)/tb_alucontrol.v
	@echo "--- Running ALUControl TB ---"
	$(XRUN) $(XFLAGS) \
	    $(SRC)/alucontrol.v \
	    $(SRC)/tb_alucontrol.v \
	    -top tb_alucontrol \
	    -log alucontrol.log
	@echo "Log: alucontrol.log"

# --------------------------------------------------------------------------
# Register File
# --------------------------------------------------------------------------
regfile: $(SRC)/regfile.v $(SRC)/tb_regfile.v
	@echo "--- Running RegFile TB ---"
	$(XRUN) $(XFLAGS) \
	    $(SRC)/regfile.v \
	    $(SRC)/tb_regfile.v \
	    -top tb_regfile \
	    -log regfile.log
	@echo "Log: regfile.log"

# --------------------------------------------------------------------------
# RAM (ram.dat must be in current directory)
# --------------------------------------------------------------------------
ram: $(SRC)/ram.v $(SRC)/tb_ram.v
	@echo "--- Running RAM TB ---"
	@if [ ! -f ram.dat ]; then \
	    echo "WARNING: ram.dat not found in current directory"; \
	fi
	$(XRUN) $(XFLAGS) \
	    $(SRC)/ram.v \
	    $(SRC)/tb_ram.v \
	    -top tb_ram \
	    -log ram.log
	@echo "Log: ram.log"

# --------------------------------------------------------------------------
# Controller FSM
# --------------------------------------------------------------------------
controller: $(SRC)/controller.v $(SRC)/tb_controller.v
	@echo "--- Running Controller TB ---"
	$(XRUN) $(XFLAGS) \
	    $(SRC)/controller.v \
	    $(SRC)/tb_controller.v \
	    -top tb_controller \
	    -log controller.log
	@echo "Log: controller.log"

# --------------------------------------------------------------------------
# Datapath
# --------------------------------------------------------------------------
datapath: $(SUBMOD) $(SRC)/tb_datapath.v
	@echo "--- Running Datapath TB ---"
	$(XRUN) $(XFLAGS) \
	    $(SRC)/flop.v        \
	    $(SRC)/flopen.v      \
	    $(SRC)/flopenr.v     \
	    $(SRC)/mux2.v        \
	    $(SRC)/mux4.v        \
	    $(SRC)/mux23.v       \
	    $(SRC)/zerodetect.v  \
	    $(SRC)/alu.v         \
	    $(SRC)/regfile.v     \
	    $(SRC)/datapath.v    \
	    $(SRC)/tb_datapath.v \
	    -top tb_datapath \
	    -log datapath.log
	@echo "Log: datapath.log"

# --------------------------------------------------------------------------
# Clean generated files
# --------------------------------------------------------------------------
clean:
	rm -f *.log *.shm *.diag ram.after.dat
	rm -rf xcelium.d INCA_libs .simvision
	@echo "Clean complete."