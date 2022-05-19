module test;

    `include "top.svh"

    int NUM_TESTS;
    initial begin
        if (!$value$plusargs("NUM_TESTS=%0d", NUM_TESTS)) begin
            NUM_TESTS = 10;
        end
    end

    logic clk, reset_n;

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

    // generator
    logic [31:0] opA, opB;
    logic [1:0]  fpuOp;

    generator gen0 = new;

    // checker
    logic [31:0] fpuOut;
    logic [31:0] goldenOut;
    logic wrong;

    checkor check0 = new;

    // stimulus
    parameter OUT_WAIT = 3;
    initial begin
        reset_n = 0;
        repeat(CLK_IDLE) @(negedge clk);
        reset_n = 1;

        // sampling
        do
        begin
            assert (gen0.randomize());

            gen0.get(opA, opB, fpuOp);
            repeat (OUT_WAIT) @(posedge clk);

            check0.check(opA, opB, fpuOp, fpuOut, wrong);

            if (wrong) begin
            $error("op = %p, opa = %08h(%p) , opb = %08h(%p)\n\t%08h(%p) - out\n\t%08h(%p) - goldenOut",
                    OP_T'(fpuOp), opA, $bitstoshortreal(opA), opB, $bitstoshortreal(opB), fpuOut, check0.final_opOut, check0.bitout, check0.out);
            end
        end
        while (gen0.getcount() < NUM_TESTS);

        $stop;
    end

    // instantiation of fpu
    fpu fpu0(
        .clk(clk),
        .A(opA),
        .B(opB),
        .opcode(fpuOp),
        .O(fpuOut)
    );

endmodule : test
