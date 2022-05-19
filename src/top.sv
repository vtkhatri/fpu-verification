module test;

    `include "../duv/fpu.v"
    `include "bfm.sv"

    int NUM_TESTS;
    initial
        if (!$value$plusargs("NUM_TESTS=%0d", NUM_TESTS))
            NUM_TESTS = 10;

    logic clk;

    // clock gen
    parameter  CLK_PERIOD = 200;
    localparam CLK_WIDTH = CLK_PERIOD / 2;
    parameter  CLK_IDLE = 2;
    initial begin
        clk = 0;
        forever begin
            #CLK_WIDTH clk = ~clk;
        end
    end

    bfm bfm0(clk);

    // stimulus
    parameter OUT_WAIT = 3;
    initial begin
        bfm0.reset(CLK_IDLE);

        do
        begin
            bfm0.test(OUT_WAIT);
            bfm0.display();
        end
        while (bfm0.continuetesting(NUM_TESTS));

        $stop;
    end

    // instantiation of fpu
    fpu fpu0(
        .clk(clk),
        .A(bfm0.opA),
        .B(bfm0.opB),
        .opcode(bfm0.fpuOp),
        .O(bfm0.fpuOut)
    );

endmodule : test
