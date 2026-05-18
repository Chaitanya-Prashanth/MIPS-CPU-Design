###################################################################

# Created by write_sdc on Thu Apr 23 17:42:33 2026

###################################################################
set sdc_version 2.1

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
set_max_area 0
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {aluop[1]}]
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {aluop[0]}]
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {funct[5]}]
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {funct[4]}]
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {funct[3]}]
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {funct[2]}]
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {funct[1]}]
set_driving_cell -lib_cell INVX1 -library osu05_stdcells [get_ports {funct[0]}]
set_fanout_load 8 [get_ports {alucont[2]}]
set_fanout_load 8 [get_ports {alucont[1]}]
set_fanout_load 8 [get_ports {alucont[0]}]
set_load -pin_load 0.1 [get_ports {alucont[2]}]
set_load -pin_load 0.1 [get_ports {alucont[1]}]
set_load -pin_load 0.1 [get_ports {alucont[0]}]
set_max_fanout 1 [get_ports {aluop[1]}]
set_max_fanout 1 [get_ports {aluop[0]}]
set_max_fanout 1 [get_ports {funct[5]}]
set_max_fanout 1 [get_ports {funct[4]}]
set_max_fanout 1 [get_ports {funct[3]}]
set_max_fanout 1 [get_ports {funct[2]}]
set_max_fanout 1 [get_ports {funct[1]}]
set_max_fanout 1 [get_ports {funct[0]}]
create_clock -name clk  -period 10  -waveform {0 5}
set_clock_latency 0.3  [get_clocks clk]
set_input_delay -clock clk  2  [get_ports {aluop[1]}]
set_input_delay -clock clk  2  [get_ports {aluop[0]}]
set_input_delay -clock clk  2  [get_ports {funct[5]}]
set_input_delay -clock clk  2  [get_ports {funct[4]}]
set_input_delay -clock clk  2  [get_ports {funct[3]}]
set_input_delay -clock clk  2  [get_ports {funct[2]}]
set_input_delay -clock clk  2  [get_ports {funct[1]}]
set_input_delay -clock clk  2  [get_ports {funct[0]}]
set_output_delay -clock clk  1.65  [get_ports {alucont[2]}]
set_output_delay -clock clk  1.65  [get_ports {alucont[1]}]
set_output_delay -clock clk  1.65  [get_ports {alucont[0]}]
