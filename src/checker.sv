class checkor;

shortreal final_opA, final_opB, final_opOut;
shortreal out;
bit [31:0] bitout;

bit [31:0] toleratebits, difference;

task check(
    input  bit [31:0] in_opA, in_opB,
    input  bit [7:0]  in_op,
    input  bit [31:0] in_fpuout,
    output bit wrong
);
    if ($test$plusargs("PER_CLK")) $display("%0t - check(a=%08h, b=%08h, o=%08h, op=%p)", $time, in_opA, in_opB, in_fpuout, OP_T'(in_op));

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

endtask : check

endclass : checkor
