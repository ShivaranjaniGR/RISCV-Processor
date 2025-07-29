# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Tue Jul 29 09:32:24 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design PROCESSOR

create_clock -name "clk_100MHz" -period 10.0 -waveform {0.0 5.0} [get_ports clock]
set_clock_gating_check -setup 0.0 
set_wire_load_mode "enclosed"
