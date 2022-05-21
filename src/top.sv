module test;

    import defs::*;

    int NUM_TESTS;
    bit PER_CLK;
    initial begin
        if (!$value$plusargs("NUM_TESTS=%0d", NUM_TESTS)) NUM_TESTS = 10;
        if (!$value$plusargs("PER_CLK=%0d", PER_CLK)) PER_CLK = 0;
    end

    logic clk;
    bfm bfm0(clk);

    // clock gen
    parameter  CLK_PERIOD = 10;
    localparam CLK_WIDTH = CLK_PERIOD / 2;
    parameter  CLK_IDLE = 2;
    initial begin
        clk = 0;
        forever begin
            #CLK_WIDTH clk = ~clk;
        end
    end

    // stimulus
    parameter OUT_WAIT = 3;
    initial begin
        bfm0.reset(CLK_IDLE);

        do
        begin
            bfm0.test(OUT_WAIT);
            if ($test$plusargs("PER_CLK")) bfm0.display();
        end
        while (bfm0.continuetesting(NUM_TESTS));

        $stop;
    end

    // instantiation of fpu
    pfpu32_top fpu0(
        .clk(clk),
        .rst(~bfm0.reset_n),
        .flush_i(bfm0.flush),
        .padv_decode_i(bfm0.decode),
        .padv_execute_i(bfm0.execute),
        .op_fpu_i(bfm0.fpuOp),
        .rfa_i(bfm0.opA),
        .rfb_i(bfm0.opB),
        .round_mode_i(bfm0.rounding),
        .fpu_result_o(bfm0.fpuOut),
        .fpu_arith_valid_o(bfm0.validarithmetic),
        .fpu_cmp_flag_o(bfm0.compare),
        .fpu_cmp_valid_o(bfm0.validcompare),
        .fpcsr_o(bfm0.fpcsr)
    );

endmodule : test
