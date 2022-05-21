class generator;

    rand bit        signA, signB;
    rand bit [7:0]  expA, expB;
    rand bit [22:0] mantA, mantB;

    rand OP_T  operation;

    protected int randcount = 0;

    task get (
        output logic [31:0] out_opA, out_opB,
        output logic [7:0]  out_op
    );

        out_opA = { >>{signA, expA, mantA}};
        // out_opA = 32'b00111111110000000000000000000000; // 1.5
        out_opB = { >>{signB, expB, mantB}};
        // out_opB = 32'b11000000101000000000000000000000; // -5.0
        out_op  = operation[7:0];
        // out_op  = ADD;

    endtask : get

    function void post_randomize();
        randcount++;
    endfunction

    function int getcount();
        return randcount;
    endfunction

endclass : generator
