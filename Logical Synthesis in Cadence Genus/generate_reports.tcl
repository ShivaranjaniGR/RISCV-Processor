# Create a reports directory if it doesn't exist
file mkdir reports

# Generate Timing Reports

report_timing > reports/timing.rpt


# Generate Area Reports
report_area > reports/area.rpt


# Generate Power Reports
report_power > reports/power.rpt


# QoR Reports
report_qor > reports/qor.rpt

# Clock and Port Reports
report_clocks > reports/clocks.rpt
report_port -verbose > reports/ports.rpt

# Save Synthesized Netlist and Constraints
write_hdl > reports/synth_netlist.v
write_sdc > reports/synth_constraints.sdc

