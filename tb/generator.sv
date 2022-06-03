class generator;

    transaction t;

    task run();
        int NUM_TESTS;
        if (!$value$plusargs("NUM_TESTS=%0d", NUM_TESTS)) NUM_TESTS = 10;

        setconstraints();

        do
        begin
            assert (t.randomize());
            common::gen2drv.put(t);
        end while (t.getcount() < NUM_TESTS)
    endtask

    task setconstraints();
        // put the constraints on transaction here chirag
    endtask

endclass : generator
