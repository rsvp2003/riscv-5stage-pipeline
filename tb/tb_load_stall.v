`timescale 1ns/1ps
`include "../rtl/load_stall.v"

module tb_load_stall;

    reg  [4:0] if_id_rs1;
    reg  [4:0] if_id_rs2;
    reg  [4:0] id_ex_rd;
    reg        id_ex_mem_read;

    wire       pc_write;
    wire       if_id_write;
    wire       control_mux_sel;

    load_stall dut (
        .if_id_rs1       (if_id_rs1),
        .if_id_rs2       (if_id_rs2),
        .id_ex_rd        (id_ex_rd),
        .id_ex_mem_read  (id_ex_mem_read),
        .pc_write        (pc_write),
        .if_id_write     (if_id_write),
        .control_mux_sel (control_mux_sel)
    );

    initial begin
        $dumpfile("../sim/load_stall_wave.vcd");
        $dumpvars(0, tb_load_stall);

        if_id_rs1 = 5'd1;
        if_id_rs2 = 5'd2;
        id_ex_rd = 5'd3;
        id_ex_mem_read = 1'b0;
        #20;
        $display("NO LOAD        : pc_write=%b if_id_write=%b control_mux_sel=%b",
                 pc_write, if_id_write, control_mux_sel);

        if_id_rs1 = 5'd1;
        if_id_rs2 = 5'd2;
        id_ex_rd = 5'd3;
        id_ex_mem_read = 1'b1;
        #20;
        $display("LOAD NO MATCH  : pc_write=%b if_id_write=%b control_mux_sel=%b",
                 pc_write, if_id_write, control_mux_sel);

        if_id_rs1 = 5'd1;
        if_id_rs2 = 5'd2;
        id_ex_rd = 5'd1;
        id_ex_mem_read = 1'b1;
        #20;
        $display("LOAD MATCH RS1 : pc_write=%b if_id_write=%b control_mux_sel=%b",
                 pc_write, if_id_write, control_mux_sel);

        if_id_rs1 = 5'd1;
        if_id_rs2 = 5'd2;
        id_ex_rd = 5'd2;
        id_ex_mem_read = 1'b1;
        #20;
        $display("LOAD MATCH RS2 : pc_write=%b if_id_write=%b control_mux_sel=%b",
                 pc_write, if_id_write, control_mux_sel);

        if_id_rs1 = 5'd5;
        if_id_rs2 = 5'd5;
        id_ex_rd = 5'd5;
        id_ex_mem_read = 1'b1;
        #20;
        $display("LOAD BOTH MATCH: pc_write=%b if_id_write=%b control_mux_sel=%b",
                 pc_write, if_id_write, control_mux_sel);

        if_id_rs1 = 5'd0;
        if_id_rs2 = 5'd1;
        id_ex_rd = 5'd0;
        id_ex_mem_read = 1'b1;
        #20;
        $display("LOAD x0 CHECK  : pc_write=%b if_id_write=%b control_mux_sel=%b",
                 pc_write, if_id_write, control_mux_sel);

        #20;
        $finish;
    end

endmodule
