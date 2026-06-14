`timescale 1ns/1ps
`include "../rtl/imem.v"
`include "../rtl/if_stage.v"

module tb_if_stage;

    reg         clk;
    reg         rst_n;

    reg         pc_write;
    reg         if_id_write;
    reg         if_id_flush;

    reg         ex_pc_src;
    reg  [31:0] ex_pc_target;

    wire [31:0] if_id_pc;
    wire [31:0] if_id_pc4;
    wire [31:0] if_id_instr;

    if_stage dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .pc_write     (pc_write),
        .if_id_write  (if_id_write),
        .if_id_flush  (if_id_flush),
        .ex_pc_src    (ex_pc_src),
        .ex_pc_target (ex_pc_target),
        .if_id_pc     (if_id_pc),
        .if_id_pc4    (if_id_pc4),
        .if_id_instr  (if_id_instr)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../sim/if_stage_wave.vcd");
        $dumpvars(0, tb_if_stage);

        clk = 0;
        rst_n = 0;

        pc_write = 1;
        if_id_write = 1;
        if_id_flush = 0;

        ex_pc_src = 0;
        ex_pc_target = 0;

        #20;
        rst_n = 1;

        dut.IMEM.mem[0] = 32'h00500093;
        dut.IMEM.mem[1] = 32'h00A00113;
        dut.IMEM.mem[2] = 32'h002081B3;
        dut.IMEM.mem[3] = 32'h00320233;
        dut.IMEM.mem[4] = 32'h004282B3;
        dut.IMEM.mem[8] = 32'h11111111;

        #10;
        $display("NORMAL 1 : pc=%0d pc4=%0d instr=%h",
                 if_id_pc, if_id_pc4, if_id_instr);

        #10;
        $display("NORMAL 2 : pc=%0d pc4=%0d instr=%h",
                 if_id_pc, if_id_pc4, if_id_instr);

        #10;
        $display("NORMAL 3 : pc=%0d pc4=%0d instr=%h",
                 if_id_pc, if_id_pc4, if_id_instr);

        pc_write = 0;
        if_id_write = 0;
        #10;
        $display("STALL    : pc=%0d pc4=%0d instr=%h",
                 if_id_pc, if_id_pc4, if_id_instr);

        pc_write = 1;
        if_id_write = 1;
        #10;
        $display("AFTER STALL : pc=%0d pc4=%0d instr=%h",
                 if_id_pc, if_id_pc4, if_id_instr);

        ex_pc_src = 1;
        ex_pc_target = 32'd32;
        if_id_flush = 1;
        #10;
        $display("FLUSH    : pc=%0d pc4=%0d instr=%h",
                 if_id_pc, if_id_pc4, if_id_instr);

        ex_pc_src = 0;
        if_id_flush = 0;
        #10;
        $display("BRANCH TARGET : pc=%0d pc4=%0d instr=%h",
                 if_id_pc, if_id_pc4, if_id_instr);

        #20;
        $finish;
    end

endmodule
