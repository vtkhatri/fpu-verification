module test;

    `include "top.svh"

    logic clk, reset_n;

    // old signals, to be fixed
    logic		inf, snan, qnan;
    logic		div_by_zero;
    logic [31:0] 	exp;

    logic		ine;
    logic		overflow, underflow;
    logic		zero;
    logic [1:0] 	fpu_rmode;

    // clock gen
    parameter  CLK_PERIOD = 100;
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
    logic [2:0]  fpuOp;

    generator gen0(
        .clk(clk),
        .reset_n(reset_n),
        .out_opA(opA),
        .out_opB(opB),
        .out_op(fpuOp)
    );

    // checker
    logic [31:0] fpuOut;
    logic [31:0] goldenOut;
    logic correct;

    checkor check0(
        .in_opA(opA),
        .in_opB(opB),
        .in_op(fpuOp),
        .in_fpuout(fpuOut),
        .fpuout(goldenOut),
        .correct(correct)
    );


    initial begin
        reset_n = 0;
        repeat(CLK_IDLE) @(negedge clk);
        reset_n = 1;

        fpu_rmode = 2'b00;
    end

    always @(posedge clk) begin
        $display("%0t - op = %b, opa = %08h , opb = %08h, out = %08h, goldenOut = %p, opA = %p, bitmantA = %b, mantA = %p, expA = %p\n",
                  $time, fpuOp, opA, opB, fpuOut, check0.out, check0.final_opA, check0.bitmantA, check0.mantA, check0.expA);
    end

    // instantiation of fpu

endmodule : test
