================================================================================
  TINY MIPS CPU — SYNOPSYS DESIGN COMPILER FLOW
================================================================================

DIRECTORY STRUCTURE
-------------------
mips_project/
├── rtl/                  
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
│   ├── mips.v            ← use this for synthesis 
│   └── mips_scan.v       ← use this for DFT 
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
│   ├── atpg.tcl          ← Step 3: ATPG
│   └── tb_gate.v         ← Gate-level simulation testbench
│
├── output/               ← Auto-created — synthesized netlists 
└── reports/              ← Auto-created — all reports 

