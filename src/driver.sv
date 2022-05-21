class drivor;

task decode(output bit decode, execute);
    decode = 1;
    execute = 0;
endtask : decode

task execute(output bit decode, execute);
    decode = 0;
    execute = 1;
endtask : execute

task done(output bit done);
    done = 0;
endtask

task roundmode(output bit[1:0] rmode);
    rmode = rm_nearest;
endtask

endclass : drivor