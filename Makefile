.PHONY: all sim build clean

all: conf build sim

clean:
	rm -fr duv work

conf:
	mkdir duv &&\
	cd duv &&\
	git clone https://github.com/monajalal/fpga_mc.git &&\
	mv fpga_mc/fpu/* . &&\
	rm -fr fpga_mc &&\
	rm -fr fpu &&\
	find . -name '*~' -exec rm {} \;

SV_TARGET := src/top.sv

top_module := test
vsim_args  := -do "run 1000 ; q"

build:
	vlog -lint $(SV_TARGET)

sim:
	vsim -c work.$(top_module) $(vsim_args)
