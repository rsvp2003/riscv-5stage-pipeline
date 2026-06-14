`timescale 1ns/1ps

`include "../rtl/wb_stage.v"

module tb_wb_stage;

    reg  [31:0] mem_wb_alu_result;
    reg  [31:0] mem_wb_mem_data;
    reg  [31:0] mem_wb_pc4;
    reg  [1:0]  mem_wb_write_back_source;
    reg         mem_wb_reg_write;
    reg  [4:0]  mem_wb_rd;

    wire        wb_write_enable;
    wire [4:0]  wb_rd;
    wire [31:0] wb_wdata;

    wb_stage dut (
        .mem_wb_alu_result        (mem_wb_alu_result),
        .mem_wb_mem_data          (mem_wb_mem_data),
        .mem_wb_pc4               (mem_wb_pc4),
        .mem_wb_write_back_source (mem_wb_write_back_source),
        .mem_wb_reg_write         (mem_wb_reg_write),
        .mem_wb_rd                (mem_wb_rd),

        .wb_write_enable          (wb_write_enable),
        .wb_rd                    (wb_rd),
        .wb_wdata                 (wb_wdata)
    );

    initial begin
        $dumpfile("../sim/wb_stage_wave.vcd");
        $dumpvars(0, tb_wb_stage);

        mem_wb_alu_result = 32'd100;
        mem_wb_mem_data = 32'd200;
        mem_wb_pc4 = 32'd300;
        mem_wb_reg_write = 1'b1;
        mem_wb_rd = 5'd5;

        mem_wb_write_back_source = 2'b00;
        #20;
        $display("ALU WB : wb_wdata=%0d wb_rd=%0d wb_write_enable=%b",
                 wb_wdata, wb_rd, wb_write_enable);

        mem_wb_write_back_source = 2'b01;
        #20;
        $display("MEM WB : wb_wdata=%0d wb_rd=%0d wb_write_enable=%b",
                 wb_wdata, wb_rd, wb_write_enable);

        mem_wb_write_back_source = 2'b10;
        #20;
        $display("PC4 WB : wb_wdata=%0d wb_rd=%0d wb_write_enable=%b",
                 wb_wdata, wb_rd, wb_write_enable);

        mem_wb_write_back_source = 2'b11;
        #20;
        $display("DEFAULT: wb_wdata=%0d wb_rd=%0d wb_write_enable=%b",
                 wb_wdata, wb_rd, wb_write_enable);

        mem_wb_reg_write = 1'b0;
        mem_wb_write_back_source = 2'b00;
        mem_wb_rd = 5'd7;
        #20;
        $display("NO WRITE: wb_wdata=%0d wb_rd=%0d wb_write_enable=%b",
                 wb_wdata, wb_rd, wb_write_enable);

        #20;
        $finish;
    end

endmodule
