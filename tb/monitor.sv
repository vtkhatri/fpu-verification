class monitor;

    virtual bfm vb;

    logic [31:0] A;
    logic [31:0] B;
    logic [31:0] O;

    input: covergroup inputs@(posedge vb.clk);

        input_A: coverpoint A; // 64 bins

        input_B: coverpoint B; // 64 bins

        op_code: coverpoint opcode{
            bins op[4]={[0:3]};
        }

        cross opcode, A;
        cross opcode, B;

    endgroup

    output: covergroup outputs@(posedge vb.clk);

        O_o: coverpoint O; // 64 bins

    endgroup

    function new(virtual bfm b);
        inputs=new();
        outputs=new();
        vb=b;
    endfunction : new

    task execute();
        forever begin : sampling_block
        @(negedge vb.clk);
        @(negedge vb.clk); // stable sampling

        A=vb.A;
        B=vb.B;
        O=vb.O;

        inputs.sample();
        output.sample();
        end : sampling_block
    endtask : execute

endclass : monitor