.PHONY: all sim build clean

all: build sim

NUM_TESTS := 100
TOLERATE_BITS := 3
FPU_SRC := duv/pfpu32_top.v

clean:
	rm -fr work

SV_TARGET := $(FPU_SRC) tb/defs.sv tb/bfm.sv tb/top.sv

top_module := test
ucdb_file  := coverage.ucdb
cover_repo := coverage.txt
do_command := coverage save -onexit $(ucdb_file) ; run -all ; q
vsim_args  := \
	-do "$(do_command)" \
	+NUM_TESTS=$(NUM_TESTS) \
	+TOLERATE_BITS=$(TOLERATE_BITS)

ifdef TEST_PRINT
	vsim_args += +TEST_PRINT
endif

build:
	vlog -lint $(SV_TARGET)

sim: simulate cover

simulate:
	vsim -c work.$(top_module) $(vsim_args)

cover:
	vcover report -verbose $(ucdb_file) > $(cover_repo)
