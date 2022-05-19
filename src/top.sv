module test;

    `include "top.svh"

    logic clk, reset_n;

    // old signals, to be fixed
    logic [31:0] 	sum;
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

    // instantiation


    initial begin
        clk = 0;
        reset_n = 0;
        repeat(CLK_IDLE) @(negedge clk);
        reset_n = 1;

        fpu_rmode = 2'b00;
    end

    always @(posedge clk) begin
        $display("%0t - op = %b, opa = %b , opb = %b, out = %b\n", $time, fpuOp, opA, opB, sum);
    end

    // instantiation of fpu
    fpu u0(clk, fpu_rmode, fpuOp, opA, opB, sum, inf, snan, qnan, ine, overflow, underflow, zero, div_by_zero);

endmodule : test
