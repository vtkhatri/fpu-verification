class transaction;

    rand bit        signA, signB;
    rand bit [7:0]  expA, expB;
    rand bit [22:0] mantA, mantB;

    bit [31:0] fpuOut, opA, opB, fpuOp; // bit values
                                        // useful for sending data from monitor to checker

    rand OP_T  operation;

    constraint normonlyA		{expA != '0 || mantA == 0;};
    constraint denormonlyA		{expA == '0 && mantA != '0;};
    constraint zeroonlyA        {expA == '0 && mantA == '0;};
    constraint normonlyB		{expB != '0 || mantB == 0;};
    constraint denormonlyB		{expB == '0 && mantB != '0;};
    constraint zeroonlyB		{expB == '0 && mantB == '0;};
    constraint bothnormdenormAB	{};

    protected int randcount = 0;

    task get (
        output logic [31:0] out_opA, out_opB,
        output logic [7:0]  out_op
    );

        out_opA = { >>{signA, expA, mantA}};
        out_opB = { >>{signB, expB, mantB}};
        out_op  = operation[7:0];

    endtask : get

    function void post_randomize();
        randcount++;
    endfunction

    function int getcount();
        return randcount;
    endfunction

endclass : transaction