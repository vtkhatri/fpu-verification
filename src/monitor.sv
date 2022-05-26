class monitor;

    bit [31:0] out_A;
    bit [31:0] out_B;
    bit [7:0]  out_op;
    bit [31:0] out_O;
    
    task execute(
    input  bit [31:0] out_opA, out_opB,
    input  bit [7:0]  out_op,
    input  bit [31:0] out_fpuout
    );

    out_A=out_opA;
    out_B=out_opB;
    out_op=out_op;
    out_O=out_fpuout;

    inputs.sample();
    outputs.sample();

    endtask : execute

    covergroup inputs;

        input_A: coverpoint out_A; // 64 bins

        input_B: coverpoint out_B; // 64 bins

        op_code: coverpoint out_op{
            bins op[4]={[0:3]};
        }
        
    endgroup

    covergroup outputs;

        output_duv: coverpoint out_O; // 64 bins

    endgroup

     function new();
        inputs = new();
        outputs = new();
     endfunction : new

endclass : monitor