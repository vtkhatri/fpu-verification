.PHONY: all sim build clean

all: build sim

NUM_TESTS := 100
TOLERATE_BITS := 3
PER_CLK := 0
FPU_SRC := duv/pfpu32_top.v

clean:
	rm -fr duv work

SV_TARGET := $(FPU_SRC) src/defs.sv src/bfm.sv src/top.sv

top_module := test
do_command := run -all ; q  # change to coverage commands afterwards
vsim_args  := \
	-do "$(do_command)" \
	+NUM_TESTS=$(NUM_TESTS) \
	+TOLERATE_BITS=$(TOLERATE_BITS)

ifdef PER_CLK
	vsim_args += +PER_CLK
endif

build:
	vlog -lint $(SV_TARGET)

sim:
	vsim -c work.$(top_module) $(vsim_args)
