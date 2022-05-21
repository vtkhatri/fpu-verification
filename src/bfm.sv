interface bfm(input clk);

import defs::*;
`include "../duv/mor1kx-defines.v"

logic reset_n;
logic flush;
logic decode;
logic execute;
logic [`OR1K_FPUOP_WIDTH-1:0] fpuOp;
logic [`OR1K_FPCSR_RM_SIZE-1:0] rounding;
logic [31:0] opA;
logic [31:0] opB;
logic [31:0] fpuOut;
logic validarithmetic;
logic compare;
logic validcompare;
logic [`OR1K_FPCSR_WIDTH-1:0] fpcsr;

generator gen0 = new;
checkor check0 = new;
drivor driver0 = new;

logic wrong;

task reset(input int CLK_IDLE);
    reset_n = 0;
    repeat(CLK_IDLE) @(posedge clk);
    reset_n = 1;
endtask

task test(input int wait_for_out);
    assert (gen0.randomize());
    gen0.get(opA, opB, fpuOp);

    drive();

    check0.check(opA, opB, fpuOp, fpuOut, wrong);

    doflush();
endtask

task drive();
    driver0.roundmode(rounding);
    driver0.done(flush);
    driver0.decode(decode, execute);
    @(posedge clk);
    @(negedge clk);
    driver0.execute(decode, execute);
    @(negedge clk);
    driver0.done(decode);
    driver0.done(execute);
    do @(negedge clk);
    while (validarithmetic === 0);
    // @(posedge validarithmetic); // signals if output is valid
endtask

task doflush();
    flush = 1;
    @(posedge clk);
    driver0.done(flush);
    do @(posedge clk);
    while (fpuOut != '0); // wait for flush to reflect in output
endtask

task display();
    $display("op = %p, A = %08h(%p) , B = %08h(%p)\n\t%08h(%p) - out\n\t%08h(%p) - goldenOut\n\t%08h(%0d) - difference",
            OP_T'(fpuOp), opA, $bitstoshortreal(opA), opB, $bitstoshortreal(opB),
            fpuOut, check0.final_opOut,
            check0.bitout, check0.out,
            check0.difference, check0.difference);
endtask

function bit continuetesting(input int NUM_TESTS);
    return (gen0.getcount() < NUM_TESTS) ? 1 : 0;
endfunction

endinterface : bfm