class coverage;


    bit [31:0] out_A;
    bit [31:0] out_B;
    bit [7:0]  out_op;
    bit [31:0] out_O;

    bit        o_signA, o_signB;
    bit [7:0]  o_expA, o_expB;
    bit [22:0] o_mantA, o_mantB;

    bit o_fpu_out;
    bit [7:0] o_expO;
    bit [22:0] o_mantO;

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
            bins exponent_A_r={['h1:'hfe]};
            bins exponent_A_ones={'hff};
        }

        exponent_B: coverpoint o_expB{
            bins exponent_B_zero={0};
            bins exponent_B_r={['h1:'hfe]};
            bins exponent_B_ones={'hff};
        }

        fraction_A: coverpoint o_mantA{
            bins fraction_A_zero={0};
            bins fraction_A_r={['h1:'h7ffffe]};
            bins fraction_A_ones={'h7fffff};
        }

        fraction_B: coverpoint o_mantB{
            bins fraction_B_zero={0};
            bins fraction_B_r={['h1:'h7ffffe]};
            bins fraction_B_ones={'hfffff};
        }

        opA_0_and_inf: cross op_code,exponent_A,fraction_A{
            bins add_A0 = binsof(op_code) intersect{ADD} &&
							(binsof (exponent_A.exponent_A_zero) && binsof (fraction_A.fraction_A_zero));
			bins sub_A0 = binsof(op_code) intersect{SUB} &&
							(binsof (exponent_A.exponent_A_zero) && binsof (fraction_A.fraction_A_zero));
			bins mul_A0 = binsof(op_code) intersect{MUL} &&
							(binsof (exponent_A.exponent_A_zero) && binsof (fraction_A.fraction_A_zero));
			bins div_A0 = binsof(op_code) intersect{DIV} &&
							(binsof (exponent_A.exponent_A_zero) && binsof (fraction_A.fraction_A_zero));
			bins add_Ainf = binsof(op_code) intersect{ADD} &&
							(binsof (exponent_A.exponent_A_ones) && binsof (fraction_A.fraction_A_zero));
			bins sub_Ainf = binsof(op_code) intersect{SUB} &&
							(binsof (exponent_A.exponent_A_ones) && binsof (fraction_A.fraction_A_zero));
			bins mul_Ainf = binsof(op_code) intersect{MUL} &&
							(binsof (exponent_A.exponent_A_ones) && binsof (fraction_A.fraction_A_zero));
			bins div_Ainf = binsof(op_code) intersect{DIV} &&
							(binsof (exponent_A.exponent_A_ones) && binsof (fraction_A.fraction_A_zero));
			ignore_bins others_all =	binsof(op_code.all_follow_div_op) || binsof(op_code.all_follow_mul_op) ||
										binsof(op_code.all_follow_sub_op) || binsof(op_code.all_follow_add_op) ||
										binsof(fraction_A.fraction_A_r) || binsof(exponent_A.exponent_A_r) ||
										binsof(fraction_A.fraction_A_ones) || binsof(fraction_A.fraction_A_r);
        }

        opB_0_and_inf: cross op_code,exponent_B,fraction_B{
            bins add_B0 = binsof(op_code) intersect{ADD} &&
							(binsof (exponent_B.exponent_B_zero) && binsof (fraction_B.fraction_B_zero));
			bins sub_B0 = binsof(op_code) intersect{SUB} &&
							(binsof (exponent_B.exponent_B_zero) && binsof (fraction_B.fraction_B_zero));
			bins mul_B0 = binsof(op_code) intersect{MUL} &&
							(binsof (exponent_B.exponent_B_zero) && binsof (fraction_B.fraction_B_zero));
			bins div_B0 = binsof(op_code) intersect{DIV} &&
							(binsof (exponent_B.exponent_B_zero) && binsof (fraction_B.fraction_B_zero));
			bins add_Binf = binsof(op_code) intersect{ADD} &&
							(binsof (exponent_B.exponent_B_ones) && binsof (fraction_B.fraction_B_zero));
			bins sub_Binf = binsof(op_code) intersect{SUB} &&
							(binsof (exponent_B.exponent_B_ones) && binsof (fraction_B.fraction_B_zero));
			bins mul_Binf = binsof(op_code) intersect{MUL} &&
							(binsof (exponent_B.exponent_B_ones) && binsof (fraction_B.fraction_B_zero));
			bins div_Binf = binsof(op_code) intersect{DIV} &&
							(binsof (exponent_B.exponent_B_ones) && binsof (fraction_B.fraction_B_zero));
			ignore_bins others_all =	binsof(op_code.all_follow_div_op) || binsof(op_code.all_follow_mul_op) ||
										binsof(op_code.all_follow_sub_op) || binsof(op_code.all_follow_add_op) ||
										binsof(fraction_B.fraction_B_r) || binsof(exponent_B.exponent_B_r) ||
										binsof(fraction_B.fraction_B_ones) || binsof(fraction_B.fraction_B_r);
        }

    endgroup

    covergroup outputs;

        output_duv: coverpoint out_O; // 64 bins

        negative_out: coverpoint o_fpu_out{
            bins negative_output = {1};      // covering if output is negative
			bins positive_output = {0};
        }

        exponent_out: coverpoint o_expO{
            bins exponent_O_zero	={0};
            bins exponent_O_r		={['h1:'hfe]};
            bins exponent_O_ones	={'hff};
        }

        fraction_out: coverpoint o_mantO{
            bins fraction_O_zero	={0};
            bins fraction_O_r		={['h1:'h7ffffe]};
            bins fraction_O_ones	={'hfffff};
        }

		output_special: cross exponent_out, fraction_out{
			bins op_zero	= binsof (exponent_out.exponent_O_zero) && binsof (fraction_out.fraction_O_zero);
			bins op_inf		= binsof (exponent_out.exponent_O_ones) && binsof (fraction_out.fraction_O_zero);
			bins op_normal	= binsof (exponent_out.exponent_O_r);
			bins op_subnorm	= binsof (exponent_out.exponent_O_zero) && 
								(binsof (fraction_out.fraction_O_r) || binsof (fraction_out.fraction_O_ones));
			bins op_NaN		= binsof (exponent_out.exponent_O_ones) && 
								(binsof (fraction_out.fraction_O_r) || binsof (fraction_out.fraction_O_ones));

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
            out_B = transaction0.opB;
            out_op = transaction0.fpuOp;
            out_O = transaction0.fpuOut;

            o_signA	= out_A[31];
            o_expA	= out_A[30:23]; 
            o_mantA	= out_A[22:0];

            o_signB	= out_B[31];
            o_expB	= out_B[30:23]; 
            o_mantB	= out_B[22:0];
            
            o_fpu_out = out_O[31];
            o_expO  = out_O[30:23];
            o_mantO = out_O[22:0];

            inputs.sample();
            outputs.sample();
        end

    endtask : run

    function new();
        inputs = new();
        outputs = new();
    endfunction : new


endclass : coverage