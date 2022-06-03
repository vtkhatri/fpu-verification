package defs;

typedef enum {
    ADD = 32'b10000000,
    SUB = 32'b10000001,
    MUL = 32'b10000010,
    DIV = 32'b10000011
} OP_T;

typedef enum {
    rm_nearest,
    rm_to_zero,
    rm_to_infp,
    rm_to_infm
} RMODE_T;

`include "common.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "checker.sv"
`include "monitor.sv"
`include "coverage.sv"
`include "environment.sv"
`include "../duv/mor1kx-defines.v"

endpackage : defs
