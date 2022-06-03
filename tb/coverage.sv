class coverage;


    bit [31:0] out_A;
    bit [31:0] out_B;
    bit [7:0]  out_op;
    bit [31:0] out_O;

    bit        o_signA, o_signB;
    bit [7:0]  o_expA, o_expB;
    bit [22:0] o_mantA, o_mantB;

    bit o_fpu_out;

    transaction transaction0;
    virtual bfm vbfm0;


    covergroup inputs;

        input_A: coverpoint out_A; // 64 bins

        input_B: coverpoint out_B; // 64 bins

        op_code: coverpoint out_op{
            bins op_add = {ADD};
            bins op_sub = {SUB};
            bins op_mul = {MUL};
            bins op_div = {DIV};
            bins all_follow_div_op[] = ([ADD:DIV] => DIV);
            bins all_follow_mul_op[] = ([ADD:DIV] => MUL);
            bins all_follow_sub_op[] = ([ADD:DIV] => SUB);
            bins all_follow_add_op[] = ([ADD:DIV] => ADD);
        }

        sign_num_A: coverpoint o_signA{
            bins negative_operand_A = {1};
            bins positive_operand_A = {0};
        }

        sign_num_B: coverpoint o_signB{
            bins negative_operand_B = {1};
            bins positive_operand_B = {0};
        }

        exponent_A: coverpoint o_expA{
            bins exponent_A_zero={0};
            bins exponent_A={[2:$]};
            bins exponent_A_one={1};
        }

        exponent_B: coverpoint o_expB{
            bins exponent_B_zero={0};
            bins exponent_B={[2:$]};
            bins exponent_B_one={1};
        }

        fraction_A: coverpoint o_mantA{
            bins fraction_A_zero={0};
            bins fraction_A={[2:$]};
            bins fraction_A_one={1};
        }

        fraction_B: coverpoint o_mantB{
            bins fraction_B_zero={0};
            bins fraction_B={[2:$]};
            bins fraction_B_one={1};
        }

        // ignoring mantasa and exponent when the number is negative for A
        cross o_signA,o_expA,o_mantA{
            ignore_bins negative = binsof(o_signA) intersect{1}; 
        }

        // ignoring mantasa and exponent when the number is negative for B
        cross o_signB,o_expB,o_mantB{
            ignore_bins negative = binsof(o_signB) intersect{1};
        }

    endgroup

    covergroup outputs;

        output_duv: coverpoint out_O; // 64 bins

        negative_out: coverpoint o_fpu_out{
            bins negative_output = {1};      // covering if output is negative
        }

    endgroup

    task run();
        // pre forever setup
        vbfm0 = common::cbfm0;

        // taking from mailbox and sampling
        forever begin
            vbfm0.waittilldone();
            common::mon2cov.get(transaction0);
            out_A = transaction0.opA;
            out_B = transaction0.opA;
            out_op = transaction0.fpuOp;
            out_O = transaction0.fpuOut;

            o_signA=out_A[31];
            o_expA= out_A[30:23]; 
            o_mantA=out_A[22:0];

            o_signB=out_A[31];
            o_expB= out_B[30:23]; 
            o_mantB=out_B[22:0];
            
            out_O = out_O[31];

            inputs.sample();
            outputs.sample();
        end

    endtask : run

    function new();
        inputs = new();
        outputs = new();
    endfunction : new


endclass : coverage