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

`include "driver.sv"
`include "checker.sv"
`include "generator.sv"
// `include "monitor.sv"  // todo : amogh fix the virtual instantiation of bfm
                          // look at how values are passed to checker and try to emulate that
`include "../duv/mor1kx-defines.v"

endpackage : defs
