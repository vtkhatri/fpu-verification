.PHONY: all sim build clean

all: build sim

NUM_TESTS := 100
TOLERATE_BITS := 3
PER_CLK := 0
FPU_SRC := duv/fpu.v

clean:
	rm -fr duv work

SV_TARGET := $(FPU_SRC) src/defs.sv src/bfm.sv src/top.sv

top_module := test
vsim_args  := -do "run -all ; q" +NUM_TESTS=$(NUM_TESTS) +TOLERATE_BITS=$(TOLERATE_BITS) +PER_CLK=$(PER_CLK)

build:
	vlog -lint $(SV_TARGET)

sim:
	vsim -c work.$(top_module) $(vsim_args)
