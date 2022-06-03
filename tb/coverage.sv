class coverage;


    bit [31:0] out_A;
    bit [31:0] out_B;
    bit [7:0]  out_op;
    bit [31:0] out_O;

    transaction transaction0;
    virtual bfm vbfm0;


    covergroup inputs;

        input_A: coverpoint out_A; // 64 bins

        input_B: coverpoint out_B; // 64 bins

        op_code: coverpoint out_op{
            bins op_add = {32'b10000000};
            bins op_sub = {32'b10000001};
            bins op_mul = {32'b10000010};
            bins op_div = {32'b10000011};
        }

    endgroup

    covergroup outputs;

        output_duv: coverpoint out_O; // 64 bins

    endgroup


    task run();
        // pre forever setup
        vbfm0 = common::cbfm0;

        // taking from mailbox and sampling
        forever begin
            vbfm0.waittilldone();
            common::mon2cov.get(transaction0);
            out_A = transaction0.opA;
            out_A = transaction0.opA;
            out_op = transaction0.fpuOp;
            out_O = transaction0.fpuOut;

            inputs.sample();
            outputs.sample();
        end

    endtask : run

    function new();
        inputs = new();
        outputs = new();
    endfunction : new


endclass : coverage