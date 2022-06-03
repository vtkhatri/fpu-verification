class environment;

    generator  gen0 = new();
    drivor     dri0 = new();
    monitor    mon0 = new();
    scoreboard sco0 = new();

    task run();
        fork
            gen0.run();
            dri0.run();
            mon0.run();
            sco0.run();
        join
    endtask

endclass : environment