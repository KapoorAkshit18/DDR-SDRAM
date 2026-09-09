# Questa/ModelSim build for the primary class-based DDR verification testbench.
# Run from Bash on Linux, macOS, WSL, or another POSIX environment.

VLIB ?= vlib
VMAP ?= vmap
VLOG ?= vlog
VSIM ?= vsim
WORK ?= work
TOP ?= top
SIM_TIME ?= 100 us
VCD ?= ddr.vcd

.PHONY: all compile run clean

all: run

compile: filelist.f
	$(VLIB) $(WORK)
	$(VMAP) work $(WORK)
	$(VLOG) -work $(WORK) -sv -f filelist.f

run: compile
	mkdir -p "$(dir $(VCD))"
	$(VSIM) -c -lib $(WORK) $(TOP) -do "vcd file $(VCD); vcd add -r /*; run $(SIM_TIME); vcd flush; quit -f"

clean:
	rm -rf -- "$(WORK)"
	rm -f -- modelsim.ini transcript vsim.wlf "$(VCD)"