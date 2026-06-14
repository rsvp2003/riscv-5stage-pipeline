`timescale 1ns/1ps

`include "../rtl/dmem.v"
`include "../rtl/mem_stage.v"

module tb_mem_stage;

    reg         clk;
    reg         rst_n;

    reg  [31:0] ex_mem_alu_result;
    reg  [31:0] ex_mem_rdata2;
    reg  [1:0]  ex_mem_write_back_source;
    reg         ex_mem_mem_write;
    reg         ex_mem_reg_write;
    reg  [4:0]  ex_mem_rd;
    reg  [31:0] ex_mem_pc4;

    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_mem_data;
    wire [1:0]  mem_wb_write_back_source;
    wire        mem_wb_reg_write;
    wire [4:0]  mem_wb_rd;
    wire [31:0] mem_wb_pc4;

    mem_stage dut (
        .clk                      (clk),
        .rst_n                    (rst_n),

        .ex_mem_alu_result        (ex_mem_alu_result),
        .ex_mem_rdata2            (ex_mem_rdata2),
        .ex_mem_write_back_source (ex_mem_write_back_source),
        .ex_mem_mem_write         (ex_mem_mem_write),
        .ex_mem_reg_write         (ex_mem_reg_write),
        .ex_mem_rd                (ex_mem_rd),
        .ex_mem_pc4               (ex_mem_pc4),

        .mem_wb_alu_result        (mem_wb_alu_result),
        .mem_wb_mem_data          (mem_wb_mem_data),
        .mem_wb_write_back_source (mem_wb_write_back_source),
        .mem_wb_reg_write         (mem_wb_reg_write),
        .mem_wb_rd                (mem_wb_rd),
        .mem_wb_pc4               (mem_wb_pc4)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../sim/mem_stage_wave.vcd");
        $dumpvars(0, tb_mem_stage);

        clk = 0;
        rst_n = 0;

        ex_mem_alu_result = 0;
        ex_mem_rdata2 = 0;
        ex_mem_write_back_source = 0;
        ex_mem_mem_write = 0;
        ex_mem_reg_write = 0;
        ex_mem_rd = 0;
        ex_mem_pc4 = 0;

        #20;
        rst_n = 1;

        ex_mem_alu_result = 32'd0;
        ex_mem_rdata2 = 32'hAAAA_1111;
        ex_mem_write_back_source = 2'b00;
        ex_mem_mem_write = 1'b1;
        ex_mem_reg_write = 1'b0;
        ex_mem_rd = 5'd0;
        ex_mem_pc4 = 32'd4;
        #10;
        $display("STORE addr=0  write_data=%h mem_data=%h",
                 ex_mem_rdata2, dut.DMEM.mem[0]);

        ex_mem_mem_write = 1'b0;
        ex_mem_alu_result = 32'd0;
        ex_mem_write_back_source = 2'b01;
        ex_mem_reg_write = 1'b1;
        ex_mem_rd = 5'd5;
        ex_mem_pc4 = 32'd8;
        #10;
        $display("LOAD  addr=0  mem_wb_mem_data=%h rd=%0d wb_src=%b reg_write=%b",
                 mem_wb_mem_data, mem_wb_rd,
                 mem_wb_write_back_source, mem_wb_reg_write);

        ex_mem_alu_result = 32'd4;
        ex_mem_rdata2 = 32'hBBBB_2222;
        ex_mem_write_back_source = 2'b00;
        ex_mem_mem_write = 1'b1;
        ex_mem_reg_write = 1'b0;
        ex_mem_rd = 5'd0;
        ex_mem_pc4 = 32'd12;
        #10;
        $display("STORE addr=4  write_data=%h mem_data=%h",
                 ex_mem_rdata2, dut.DMEM.mem[1]);

        ex_mem_mem_write = 1'b0;
        ex_mem_alu_result = 32'd4;
        ex_mem_write_back_source = 2'b01;
        ex_mem_reg_write = 1'b1;
        ex_mem_rd = 5'd6;
        ex_mem_pc4 = 32'd16;
        #10;
        $display("LOAD  addr=4  mem_wb_mem_data=%h rd=%0d wb_src=%b reg_write=%b",
                 mem_wb_mem_data, mem_wb_rd,
                 mem_wb_write_back_source, mem_wb_reg_write);

        ex_mem_alu_result = 32'd100;
        ex_mem_rdata2 = 32'd0;
        ex_mem_write_back_source = 2'b00;
        ex_mem_mem_write = 1'b0;
        ex_mem_reg_write = 1'b1;
        ex_mem_rd = 5'd7;
        ex_mem_pc4 = 32'd20;
        #10;
        $display("ALU PASS      alu_result=%0d rd=%0d wb_src=%b reg_write=%b",
                 mem_wb_alu_result, mem_wb_rd,
                 mem_wb_write_back_source, mem_wb_reg_write);

        ex_mem_alu_result = 32'd0;
        ex_mem_rdata2 = 32'd0;
        ex_mem_write_back_source = 2'b10;
        ex_mem_mem_write = 1'b0;
        ex_mem_reg_write = 1'b1;
        ex_mem_rd = 5'd1;
        ex_mem_pc4 = 32'd104;
        #10;
        $display("PC4 PASS      pc4=%0d rd=%0d wb_src=%b reg_write=%b",
                 mem_wb_pc4, mem_wb_rd,
                 mem_wb_write_back_source, mem_wb_reg_write);

        #20;
        $finish;
    end

endmodule
