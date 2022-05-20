interface bfm(input clk);

`include "defs.sv"
`include "generator.sv"
`include "checker.sv"

generator gen0 = new;
checkor check0 = new;

logic reset_n;
logic [31:0] opA, opB, fpuOut;
logic [1:0]  fpuOp;
logic wrong;

task reset(input int CLK_IDLE);
    reset_n = 0;
    repeat(CLK_IDLE) @(posedge clk);
    reset_n = 1;
endtask

task test(input int wait_for_out);
    getinput();
    if (fpuOp[1]) begin // if it's a mul/div
        repeat(wait_for_out*32) @(posedge clk);
    end
    else begin
        repeat(wait_for_out) @(posedge clk);
    end
    checkoutput();
endtask

task getinput();
    assert (gen0.randomize());
    gen0.get(opA, opB, fpuOp);
endtask

task checkoutput();
    check0.check(opA, opB, fpuOp, fpuOut, wrong);
endtask

task display(input bit print_clk);
    if (wrong) begin
        $error("op = %p, B = %08h(%p) , B = %08h(%p)\n\t%08h(%p) - out\n\t%08h(%p) - goldenOut\n\t%08h(%0d) - difference",
                OP_T'(fpuOp), opA, $bitstoshortreal(opA), opB, $bitstoshortreal(opB),
                fpuOut, check0.final_opOut,
                check0.bitout, check0.out,
                check0.difference, check0.difference);
    end
    else if (print_clk) begin
        $display("%0t - op = %p, B = %08h(%p) , B = %08h(%p)\n\t%08h(%p) - out\n\t%08h(%p) - goldenOut\n\t%08h(%0d) - difference",
                $time, OP_T'(fpuOp), opA, $bitstoshortreal(opA), opB, $bitstoshortreal(opB),
                fpuOut, check0.final_opOut,
                check0.bitout, check0.out,
                check0.difference, check0.difference);
    end
endtask

function bit continuetesting(input int NUM_TESTS);
    return (gen0.getcount() < NUM_TESTS) ? 1 : 0;
endfunction

endinterface : bfm