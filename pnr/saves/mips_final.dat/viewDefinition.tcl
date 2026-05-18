if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name LIB_typ\
   -timing\
    [list ${::IMEX::libVar}/mmmc/osu05_stdcells.lib]
create_rc_corner -name RC_typ\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0
create_delay_corner -name CORNER_typ\
   -library_set LIB_typ\
   -rc_corner RC_typ
create_constraint_mode -name syn_constraints\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/mips_scan.sdc]
create_constraint_mode -name postCTS_constraints\
   -sdc_files\
    [list ${::IMEX::libVar}/mmmc/mips_scan.sdc]
create_analysis_view -name VIEW_typ -constraint_mode syn_constraints -delay_corner CORNER_typ
create_analysis_view -name VIEW_typ_postCTS -constraint_mode postCTS_constraints -delay_corner CORNER_typ
set_analysis_view -setup [list VIEW_typ] -hold [list VIEW_typ]
