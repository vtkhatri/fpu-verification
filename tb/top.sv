module test;

    import defs::*;

    bfm bfm0();
    common      common0;
    environment env0;

    // instantiation of fpu
    pfpu32_top fpu0(
        .clk(bfm0.clk),
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

    initial begin
        $dumpfile("dump.vcd");

        common0 = new();
        env0 = new();
        common0.cbfm0 = bfm0;

        fork
            bfm0.clkgen();
            bfm0.reset();
        join_any

        env0.run();

        $stop;
    end


endmodule : test
