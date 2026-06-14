`timescale 1ns/1ps
`include "../rtl/forwarding_unit.v"

module tb_forwarding_unit;

    reg  [4:0] id_ex_rs1;
    reg  [4:0] id_ex_rs2;

    reg  [4:0] ex_mem_rd;
    reg        ex_mem_reg_write;

    reg  [4:0] mem_wb_rd;
    reg        mem_wb_reg_write;

    wire [1:0] forward_a;
    wire [1:0] forward_b;

    forwarding_unit dut (
        .id_ex_rs1        (id_ex_rs1),
        .id_ex_rs2        (id_ex_rs2),
        .ex_mem_rd        (ex_mem_rd),
        .ex_mem_reg_write (ex_mem_reg_write),
        .mem_wb_rd        (mem_wb_rd),
        .mem_wb_reg_write (mem_wb_reg_write),
        .forward_a        (forward_a),
        .forward_b        (forward_b)
    );

    initial begin
        $dumpfile("../sim/forwarding_unit_wave.vcd");
        $dumpvars(0, tb_forwarding_unit);

        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd2;
        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b0;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b0;
        #20;
        $display("NO HAZARD        : forward_a=%b forward_b=%b", forward_a, forward_b);

        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd2;
        ex_mem_rd = 5'd1;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b0;
        #20;
        $display("EX/MEM -> RS1    : forward_a=%b forward_b=%b", forward_a, forward_b);

        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd2;
        ex_mem_rd = 5'd2;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b0;
        #20;
        $display("EX/MEM -> RS2    : forward_a=%b forward_b=%b", forward_a, forward_b);

        id_ex_rs1 = 5'd3;
        id_ex_rs2 = 5'd4;
        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b0;
        mem_wb_rd = 5'd3;
        mem_wb_reg_write = 1'b1;
        #20;
        $display("MEM/WB -> RS1    : forward_a=%b forward_b=%b", forward_a, forward_b);

        id_ex_rs1 = 5'd3;
        id_ex_rs2 = 5'd4;
        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b0;
        mem_wb_rd = 5'd4;
        mem_wb_reg_write = 1'b1;
        #20;
        $display("MEM/WB -> RS2    : forward_a=%b forward_b=%b", forward_a, forward_b);

        id_ex_rs1 = 5'd5;
        id_ex_rs2 = 5'd5;
        ex_mem_rd = 5'd5;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b0;
        #20;
        $display("EX/MEM -> BOTH   : forward_a=%b forward_b=%b", forward_a, forward_b);

        id_ex_rs1 = 5'd6;
        id_ex_rs2 = 5'd7;
        ex_mem_rd = 5'd6;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd6;
        mem_wb_reg_write = 1'b1;
        #20;
        $display("PRIORITY CHECK   : forward_a=%b forward_b=%b", forward_a, forward_b);

        id_ex_rs1 = 5'd8;
        id_ex_rs2 = 5'd9;
        ex_mem_rd = 5'd0;
        ex_mem_reg_write = 1'b1;
        mem_wb_rd = 5'd0;
        mem_wb_reg_write = 1'b1;
        #20;
        $display("x0 IGNORE CHECK  : forward_a=%b forward_b=%b", forward_a, forward_b);

        #20;
        $finish;
    end

endmodule
