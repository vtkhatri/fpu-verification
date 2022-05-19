.PHONY: all sim build clean

all: build sim

clean:
	rm -fr duv work

SV_TARGET := src/top.sv

top_module := test
vsim_args  := -do "run -all ; q"

build:
	vlog -lint $(SV_TARGET)

sim:
	vsim -c work.$(top_module) $(vsim_args)
