class checkor;

bit [23:0] bitmantA, bitmantB;
int expA, expB;
real mantA, unsigned_opA, final_opA, mantB, unsigned_opB, final_opB;
real out;

task check(
    input  bit [31:0] in_opA, in_opB,
    input  bit [2:0]  in_op,
    input  bit [31:0] in_fpuout,
    output logic [31:0] fpuout
);

    // mantissa by right-shifting 23 bits with an implied one as 24th bit
    bitmantA = {1'b1, in_opA[22:0]};
    bitmantB = {1'b1, in_opB[22:0]};

    mantA = bitmantA / (2.0**23);
    mantB = bitmantB / (2.0**23);

    // simple exp extraction
    expA = in_opA[30:23] - 127;
    expB = in_opB[30:23] - 127;

    unsigned_opA = mantA * (2.0 ** expA);
    unsigned_opB = mantB * (2.0 ** expB);

    final_opA = in_opA[31] ? -unsigned_opA : unsigned_opA;
    final_opB = in_opB[31] ? -unsigned_opB : unsigned_opB;

    case (in_op)
    ADD: begin
        out = final_opA + final_opB;
    end
    SUB: begin
        out = final_opA - final_opB;
    end
    MUL: begin
        out = final_opA * final_opB;
    end
    DIV: begin
        out = final_opA / final_opB;
    end
    default: begin
        $error("invalid opcode");
    end
    endcase

endtask : check

endclass : checkor
