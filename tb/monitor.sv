class monitor;

    transaction transaction0;
    virtual bfm vbfm0;

    task run();
        vbfm0 = common::cbfm0;

        transaction0 = new();
        forever begin
            vbfm0.waittilldone();

            transaction0.opA = vbfm0.opA;
            transaction0.opB = vbfm0.opB;
            transaction0.fpuOp = vbfm0.fpuOp;

            @(posedge vbfm0.clk);
            transaction0.fpuOut = vbfm0.fpuOut;

            common::mon2che.put(transaction0); // for verification against reference model
            common::mon2cov.put(transaction0); // for collecting coverage

        end
    endtask : run

endclass : monitor