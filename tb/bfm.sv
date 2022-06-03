interface bfm;

    import defs::*;
    `include "../duv/mor1kx-defines.v"

    logic clk, reset_n;
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

    logic wrong;

    task clkgen();
        static int CLK_PERIOD = 10;
        static int CLK_WIDTH = CLK_PERIOD / 2;
        clk = 0;

        forever begin
            #CLK_WIDTH clk = ~clk;
        end
    endtask : clkgen

    task reset();
        static int CLK_IDLE = 2;
        reset_n = 0;
        repeat(CLK_IDLE) @(posedge clk);
        reset_n = 1;
    endtask

    task rounding_mode(input transaction transaction0);
        rounding = 0; // standard rounding for now, get from transaction class later
    endtask : rounding_mode

    task test(input transaction transaction0);
        rounding_mode(transaction0);

        transaction0.get(opA, opB, fpuOp);

        drive();
        waittilldone();

    endtask

    task drive();
        { flush, decode, execute } = '0;

        // duv will latch the operands
        decode = 1;
        @(posedge clk);
        @(negedge clk);

        // duv will now start execution on the latched operands
        decode = 0;
        execute = 1;
        @(negedge clk);

        // resetting all signals before exit
        { flush, decode, execute } = '0;

    endtask

    task doflush();
        flush = 1;
        @(posedge clk);
        flush = 0;
        do @(posedge clk);
        while (fpuOut != '0); // wait for flush to reflect in output
    endtask

    task waittilldone();
        // wait for valid output for duv
        do @(negedge clk);
        while (validarithmetic === 0);
    endtask : waittilldone

    task waittilldoneandflushed();
        // wait for valid output for duv
        do @(negedge clk);
        while (validarithmetic === 0);

        // wait for flush to take effect
        do @(posedge clk);
        while (fpuOut != '0);
    endtask : waittilldoneandflushed

endinterface : bfm