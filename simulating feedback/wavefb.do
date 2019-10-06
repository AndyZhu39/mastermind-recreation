# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns feedback.v

# Load simulation using mux as the top level simulation module.
vsim feedback

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
force {resetn} 0

run 1ns

force {clk} 0 0 ns, 1 5 ns -repeat 10 ns

force {c_place[0]} 0
force {c_place[1]} 1
force {c_place[2]} 0


force {c_color[0]} 0
force {c_color[1]} 1
force {c_color[2]} 0

run 200ns