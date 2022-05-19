class checkor;

shortreal final_opA, final_opB, final_opOut;
shortreal out;
bit [31:0] bitout;

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

    wrong = ((bitout ^ in_fpuout) > 32'd512);

endtask : check

endclass : checkor
