all: sim

sim: osc.spice
	# run the simulation
	echo '.include $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice' > includes.spice
	ngspice $^
