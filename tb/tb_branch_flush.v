`timescale 1ns/1ps
`include "../rtl/branch_flush.v"

module tb_branch_flush;

    reg  ex_pc_src;

    wire if_id_flush;
    wire id_ex_flush;

    branch_flush dut (
        .ex_pc_src   (ex_pc_src),
        .if_id_flush (if_id_flush),
        .id_ex_flush (id_ex_flush)
    );

    initial begin
        $dumpfile("../sim/branch_flush_wave.vcd");
        $dumpvars(0, tb_branch_flush);

        ex_pc_src = 1'b0;
        #20;
        $display("NO BRANCH/JUMP : ex_pc_src=%b if_id_flush=%b id_ex_flush=%b",
                 ex_pc_src, if_id_flush, id_ex_flush);

        ex_pc_src = 1'b1;
        #20;
        $display("BRANCH/JUMP TAKEN : ex_pc_src=%b if_id_flush=%b id_ex_flush=%b",
                 ex_pc_src, if_id_flush, id_ex_flush);

        ex_pc_src = 1'b0;
        #20;
        $display("BACK TO NORMAL : ex_pc_src=%b if_id_flush=%b id_ex_flush=%b",
                 ex_pc_src, if_id_flush, id_ex_flush);

        ex_pc_src = 1'b1;
        #20;
        $display("ONE MORE FLUSH : ex_pc_src=%b if_id_flush=%b id_ex_flush=%b",
                 ex_pc_src, if_id_flush, id_ex_flush);

        ex_pc_src = 1'b0;
        #20;
        $display("NORMAL AGAIN : ex_pc_src=%b if_id_flush=%b id_ex_flush=%b",
                 ex_pc_src, if_id_flush, id_ex_flush);

        #20;
        $finish;
    end

endmodule
