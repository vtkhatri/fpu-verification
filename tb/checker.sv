class checkor;

    shortreal final_opA, final_opB, final_opOut;
    shortreal out;
    bit [31:0] bitout;

    bit [31:0] in_opA, in_opB;
    bit [7:0]  in_op;
    bit [31:0] in_fpuout;

    bit wrong;

    bit [31:0] toleratebits, difference;

    transaction transaction0;
    virtual bfm vbfm0;

    task run();
        vbfm0 = common::cbfm0;

        transaction0 = new();
        forever begin
            vbfm0.waittilldoneandflushed();

            common::mon2che.get(transaction0);
            in_opA = transaction0.opA;
            in_opB = transaction0.opB;
            in_op = transaction0.fpuOp;
            in_fpuout = transaction0.fpuOut;
            check();
        end
    endtask : run

    task check();
        if ($test$plusargs("TEST_PRINT")) $display("%0t - check(a=%08h, b=%08h, o=%08h, op=%p)", $time, in_opA, in_opB, in_fpuout, OP_T'(in_op));

        final_opA = $bitstoshortreal(in_opA);
        final_opB = $bitstoshortreal(in_opB);
        final_opOut = $bitstoshortreal(in_fpuout);

        case (in_op)
        ADD: begin
            out = final_opA + final_opB;
        end
        SUB: begin
            out = final_opA - final_opB;
        end
        DIV: begin
            out = final_opA / final_opB;
        end
        MUL: begin
            out = final_opA * final_opB;
        end
        default: begin
            $error("invalid opcode - %b", in_op);
        end
        endcase

        bitout = $shortrealtobits(out);

        if (!$value$plusargs("TOLERATE_BITS=%0d", toleratebits))
            toleratebits = 8;

        if (bitout[30:23]) begin
            wrong = (bitout[30:23] == in_fpuout[30:23]);
        end
        else
            difference = bitout - in_fpuout;
            difference = (difference[31]) ? -difference : difference;
            wrong = (difference > (2**toleratebits));


        if (wrong) begin
            $error("op = %p, A = %08h(%p) , B = %08h(%p)\n\t%08h(%p) - out\n\t%08h(%p) - goldenOut\n\t%08h(%0d) - difference",
                    OP_T'(in_op), in_opA, final_opA, in_opB, final_opB,
                    in_fpuout, final_opOut,
                    bitout, out,
                    difference, difference);
        end
        else if ($test$plusargs("TEST_PRINT")) begin
            $display("op = %p, A = %08h(%p) , B = %08h(%p)\n\t%08h(%p) - out\n\t%08h(%p) - goldenOut\n\t%08h(%0d) - difference",
                    OP_T'(in_op), in_opA, final_opA, in_opB, final_opB,
                    in_fpuout, final_opOut,
                    bitout, out,
                    difference, difference);
        end

    endtask : check

endclass : checkor
