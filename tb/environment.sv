class environment;

    generator  gen0     = new();
    drivor     drivor0  = new();
    monitor    monitor0 = new();
    checkor    checkor0 = new();
    coverage   cover0   = new();

    task run();
        fork
            gen0.run();     // will return control when done
            drivor0.run();  // forever
            monitor0.run(); // forever
            checkor0.run(); // forever
            cover0.run();   // forever
        join_any
    endtask

endclass : environment