class checkor;

shortreal final_opA, final_opB, final_opOut;
shortreal out;
bit [31:0] bitout;

bit [31:0] toleratebits, difference;

task check(
    input  bit [31:0] in_opA, in_opB,
    input  bit [2:0]  in_op,
    input  bit [31:0] in_fpuout,
    output logic wrong
);

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
        $error("invalid opcode");
    end
    endcase

    bitout = $shortrealtobits(out);

    if (!$value$plusargs("TOLERATE_BITS=%0d", toleratebits))
        toleratebits = 8;

    difference = bitout - in_fpuout;
    difference = (difference[31]) ? -difference : difference;
    wrong = (difference > (2**toleratebits));

endtask : check

endclass : checkor
