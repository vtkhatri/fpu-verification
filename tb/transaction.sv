class transaction;

    rand bit        signA, signB;
    rand bit [7:0]  expA, expB;
    rand bit [22:0] mantA, mantB;

    rand OP_T  operation;
    // currently only one constraint is kept active in bfm
    // combination of different constraints needs to be active with more options of operation as well
    // example, extra number can be generated randomly and then constraint conditions can be chosen here
    // based on value's if else condition
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

endclass : transaction