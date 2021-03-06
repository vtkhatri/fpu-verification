.PHONY: all sim build clean

all: build sim

NUM_TESTS := 10000
TOLERATE_BITS := 3
RAND_CONS := 61
FPU_SRC := duv/pfpu32_top.v

clean:
	rm -fr work

SV_TARGET := $(FPU_SRC) tb/defs.sv tb/bfm.sv tb/top.sv

top_module := test
ucdb_file  := coverage.ucdb
cover_repo := coverage.report
do_command := coverage save -onexit $(ucdb_file) ; run -all ; q
vlog_args  := \
	-lint \
	-suppress 8604 \
	-warning error

vsim_args  := \
	-do "$(do_command)" \
	+NUM_TESTS=$(NUM_TESTS) \
	+TOLERATE_BITS=$(TOLERATE_BITS) \
	+RAND_CONS=$(RAND_CONS) \
	-suppress 8604 \
	-suppress 8630

ifdef TEST_PRINT
	vsim_args += +TEST_PRINT
endif

ifeq ($(BUG), 1)
	vlog_args += +define+BUG_ADDSUB
else
ifeq ($(BUG), 2)
	vlog_args += +define+BUG_MULDIV
else
ifeq ($(BUG), 3)
	vlog_args += +define+BUG_ADDSUB +define+BUG_MULDIV
endif
endif
endif

build:
	vlog $(vlog_args) $(SV_TARGET)

sim: simulate cover

simulate:
	vsim -c work.$(top_module) $(vsim_args)

cover:
	vcover report -verbose $(ucdb_file) > $(cover_repo)
