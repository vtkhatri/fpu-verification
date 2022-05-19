module generator(
    input  logic clk, reset_n,
    output logic [31:0] out_opA, out_opB,
    output logic [2:0]  out_op
);


    class operandsgen;

        rand bit        signA, signB;
        rand bit [7:0]  expA, expB;
        rand bit [22:0] mantA, mantB;

        rand bit [2:0]  operation;

    endclass : operandsgen

    operandsgen opgen = new;

    // generate @negedge clk, so posedge sampling works
    always @(negedge clk) begin
        if (reset_n) begin
            opgen.randomize();
            out_opA <= { >>{opgen.signA, opgen.expA, opgen.mantA}};
            out_opB <= { >>{opgen.signB, opgen.expB, opgen.mantB}};
            out_op  <= 3'h0;
        end
    end

endmodule : generator
