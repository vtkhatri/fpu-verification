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
        int RAND_CONS = 7;
        if (!$value$plusargs("RAND_CONS=%0d", RAND_CONS))
        begin
            $display("Constraints chosen with RAND_CONS = %d", RAND_CONS);
            RAND_CONS = RAND_CONS + 1;
        end
        t.constraint_mode(0);
        case( (t.getcount())%RAND_CONS )
            0 : begin
                t.normonlyA.constraint_mode(1);
            end
            1 : begin
                t.denormonlyA.constraint_mode(1);
            end
            2 : begin
                t.zeroonlyA.constraint_mode(1);
            end
            3 : begin
                t.normonlyB.constraint_mode(1);
            end
            4 : begin
                t.denormonlyB.constraint_mode(1);
            end
            5 : begin
                t.zeroonlyB.constraint_mode(1);
            end
            6: begin
                t.bothnormdenormAB.constraint_mode(1);
            end
            default: begin
                t.normonlyA.constraint_mode(1);
                t.normonlyB.constraint_mode(1);
            end
        endcase
    endtask

endclass : generator
