class drivor;

    transaction transaction0;
    virtual bfm vbfm0;

    task run();
        vbfm0 = common::cbfm0;

        forever begin
            common::gen2drv.get(transaction0);
            vbfm0.test(transaction0);
            common::drv2mon.put(transaction0);
            vbfm0.doflush();
        end
    endtask : run

endclass : drivor