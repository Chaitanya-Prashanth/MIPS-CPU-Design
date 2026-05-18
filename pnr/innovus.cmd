#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Tue Apr 28 17:00:45 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v25.10-p002_1 (64bit) 04/23/2025 12:43 (Linux 4.18.0-305.el8.x86_64)
#@(#)CDS: NanoRoute 25.10-p002_1 NR250317-0405/25_10-UB (database version 18.20.663) {superthreading v2.20}
#@(#)CDS: AAE 25.10-b008 (64bit) 04/23/2025 (Linux 4.18.0-305.el8.x86_64)
#@(#)CDS: CTE 25.10-b014_1 () Mar 28 2025 03:11:49 ( )
#@(#)CDS: SYNTECH 25.10-b006_1 () Mar 13 2025 03:32:26 ( )
#@(#)CDS: CPE v25.10-b011
#@(#)CDS: IQuantus/TQuantus 24.1.0-s201 (64bit) Thu Mar 20 10:21:58 PDT 2025 (Linux 4.18.0-305.el8.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
win
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net VDD
set init_gnd_net GND
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../../dft/netlists/${DESIGN}_scan.sdc
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net VDD
set init_gnd_net GND
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../../dft/netlists/${DESIGN}_scan.sdc
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net VDD
set init_gnd_net GND
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
create_constraint_mode \
    -name postCTS_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
set init_mmmc_file ../scripts/mmmc.tcl
set init_lef_file { /apps/design_kits/osu_stdcells_v2p7/cadence/lib/ami05/lef/osu05_stdcells.lef  }
init_design -setup VIEW_typ -hold VIEW_typ
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net VDD
set init_gnd_net GND
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
create_constraint_mode \
    -name postCTS_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
set init_mmmc_file /scripts/mmmc.tcl
set init_lef_file { /apps/design_kits/osu_stdcells_v2p7/cadence/lib/ami05/lef/osu05_stdcells.lef  }
init_design -setup VIEW_typ -hold VIEW_typ
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net VDD
set init_gnd_net GND
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
create_constraint_mode \
    -name postCTS_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
set init_mmmc_file scripts/mmmc.tcl
set init_lef_file { /apps/design_kits/osu_stdcells_v2p7/cadence/lib/ami05/lef/osu05_stdcells.lef  }
init_design -setup VIEW_typ -hold VIEW_typ
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net VDD
set init_gnd_net GND
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
create_constraint_mode \
    -name postCTS_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
set init_mmmc_file scripts/mmmc.tcl
set init_lef_file { /apps/design_kits/osu_stdcells_v2p7/cadence/lib/ami05/lib/osu05_stdcells.lef  }
init_design -setup VIEW_typ -hold VIEW_typ
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net vdd!
set init_gnd_net gnd!
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../../dft/netlists/${DESIGN}_scan.sdc
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net vdd!
set init_gnd_net gnd!
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
create_constraint_mode \
    -name postCTS_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
set init_mmmc_file scripts/mmmc.tcl
set init_lef_file {/home/ead/G44010997/cadence/innovus/ami05_techlib_oa.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells_oa.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells_expanded.lef}
init_design -setup VIEW_typ -hold VIEW_typ
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net vdd!
set init_gnd_net gnd!
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
create_constraint_mode \
    -name postCTS_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
set init_mmmc_file scripts/mmmc.tcl
set init_lef_file {/home/ead/G44010997/cadence/innovus/ami05_techlib_oa.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells_oa.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells_expanded.lef}
init_design -setup VIEW_typ -hold VIEW_typ
set init_verilog ../../dft/netlists/mips_scan.v
set init_top_cell mips
set init_pwr_net vdd!
set init_gnd_net gnd!
create_constraint_mode \
    -name syn_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
create_constraint_mode \
    -name postCTS_constraints \
    -sdc_files ../dft/netlists/${DESIGN}_scan.sdc
set init_mmmc_file scripts/mmmc.tcl
set init_lef_file {/home/ead/G44010997/cadence/innovus/ami05_techlib_oa.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells_oa.lef /home/ead/G44010997/cadence/innovus/osu05_stdcells_expanded.lef}
init_design -setup VIEW_typ -hold VIEW_typ
