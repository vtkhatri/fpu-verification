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

    generator gen0 = new;

    // checker
    logic [31:0] fpuOut;
    logic [31:0] goldenOut;

    checkor check0 = new;

    // stimulus
    initial begin
        reset_n = 0;
        repeat(CLK_IDLE) @(negedge clk);
        reset_n = 1;

        fpu_rmode = 2'b00;
    end

    // sampling
    always @(posedge clk) begin

        assert (gen0.randomize());

        gen0.get(opA, opB, fpuOp);
        check0.check(opA, opB, fpuOp, fpuOut, goldenOut);

        $display("%0t - op = %b, opa = %08h , opb = %08h, out = %08h, goldenOut = %p",
                  $time, fpuOp, opA, opB, fpuOut, check0.out);
        $display("\t - a - mant = %p, bitmant = %b, exp = %p, unsigned = %p, final = %p",
                            check0.mantA, check0.bitmantA, check0.expA, check0.unsigned_opA, check0.final_opA);
        $display("\t - b - mant = %p, bitmant = %b, exp = %p, unsigned = %p, final = %p",
                            check0.mantB, check0.bitmantB, check0.expB, check0.unsigned_opB, check0.final_opB);
    end

    // instantiation of fpu
    fpu u0(clk, fpu_rmode, fpuOp, opA, opB, fpuOut, inf, snan, qnan, ine, overflow, underflow, zero, div_by_zero);

endmodule : test
