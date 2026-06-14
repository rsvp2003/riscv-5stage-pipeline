`timescale 1ns/1ps

`include "../rtl/alu.v"
`include "../rtl/control.v"
`include "../rtl/sign_ext.v"
`include "../rtl/reg_file.v"

`include "../rtl/imem.v"
`include "../rtl/dmem.v"

`include "../rtl/if_stage.v"
`include "../rtl/id_stage.v"
`include "../rtl/ex_stage.v"
`include "../rtl/mem_stage.v"
`include "../rtl/wb_stage.v"

`include "../rtl/forwarding_unit.v"
`include "../rtl/load_stall.v"
`include "../rtl/branch_flush.v"

module cpu_top (
    input wire clk,
    input wire rst_n
);

    // IF/ID
    wire [31:0] if_id_pc;
    wire [31:0] if_id_pc4;
    wire [31:0] if_id_instr;

    // ID/EX
    wire [31:0] id_ex_pc;
    wire [31:0] id_ex_pc4;
    wire [31:0] id_ex_rdata1;
    wire [31:0] id_ex_rdata2;
    wire [31:0] id_ex_imm;

    wire [3:0]  id_ex_alu_control;
    wire        id_ex_alu_source;
    wire [1:0]  id_ex_write_back_source;
    wire        id_ex_mem_write;
    wire        id_ex_reg_write;
    wire        id_ex_branch;
    wire        id_ex_jump;
    wire        id_ex_jalr;

    wire [6:0]  id_ex_op;
    wire [2:0]  id_ex_f3;
    wire [6:0]  id_ex_f7;
    wire [4:0]  id_ex_rs1;
    wire [4:0]  id_ex_rs2;
    wire [4:0]  id_ex_rd;

    // EX/MEM
    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rdata2;
    wire [1:0]  ex_mem_write_back_source;
    wire        ex_mem_mem_write;
    wire        ex_mem_reg_write;
    wire [4:0]  ex_mem_rd;
    wire [31:0] ex_mem_pc4;

    // MEM/WB
    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_mem_data;
    wire [1:0]  mem_wb_write_back_source;
    wire        mem_wb_reg_write;
    wire [4:0]  mem_wb_rd;
    wire [31:0] mem_wb_pc4;

    // WB
    wire        wb_write_enable;
    wire [4:0]  wb_rd;
    wire [31:0] wb_wdata;

    // PC feedback from EX -> IF
    wire        ex_pc_src;
    wire [31:0] ex_pc_target;

    // Branch flush wires
    wire        if_id_flush;
    wire        id_ex_flush;

    // Forwarding
    wire [1:0]  forward_a;
    wire [1:0]  forward_b;
    wire [31:0] ex_mem_forward_data;
    wire [31:0] wb_forward_data;

    assign ex_mem_forward_data = ex_mem_alu_result;
    assign wb_forward_data     = wb_wdata;

    // Load-use stall wires
    wire        pc_write;
    wire        if_id_write;
    wire        control_mux_sel;

    wire [4:0]  if_id_rs1;
    wire [4:0]  if_id_rs2;
    wire        id_ex_mem_read;

    assign if_id_rs1 = if_id_instr[19:15];
    assign if_id_rs2 = if_id_instr[24:20];

    // write_back_source = 2'b01 means load instruction
    assign id_ex_mem_read = (id_ex_write_back_source == 2'b01);

    //////////////////////////////////////////////////////
    // Branch Flush Unit
    //////////////////////////////////////////////////////
    branch_flush BFU (
        .ex_pc_src(ex_pc_src),

        .if_id_flush(if_id_flush),
        .id_ex_flush(id_ex_flush)
    );

    //////////////////////////////////////////////////////
    // IF stage
    //////////////////////////////////////////////////////
    if_stage IF (
        .clk(clk),
        .rst_n(rst_n),

        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .if_id_flush(if_id_flush),

        .ex_pc_src(ex_pc_src),
        .ex_pc_target(ex_pc_target),

        .if_id_pc(if_id_pc),
        .if_id_pc4(if_id_pc4),
        .if_id_instr(if_id_instr)
    );

    //////////////////////////////////////////////////////
    // ID stage
    //////////////////////////////////////////////////////
    id_stage ID (
        .clk(clk),
        .rst_n(rst_n),

        .control_mux_sel(control_mux_sel),
        .id_ex_flush(id_ex_flush),

        .if_id_pc(if_id_pc),
        .if_id_pc4(if_id_pc4),
        .if_id_instr(if_id_instr),

        .wb_write_enable(wb_write_enable),
        .wb_rd(wb_rd),
        .wb_wdata(wb_wdata),

        .id_ex_pc(id_ex_pc),
        .id_ex_pc4(id_ex_pc4),
        .id_ex_rdata1(id_ex_rdata1),
        .id_ex_rdata2(id_ex_rdata2),
        .id_ex_imm(id_ex_imm),

        .id_ex_alu_control(id_ex_alu_control),
        .id_ex_alu_source(id_ex_alu_source),
        .id_ex_write_back_source(id_ex_write_back_source),
        .id_ex_mem_write(id_ex_mem_write),
        .id_ex_reg_write(id_ex_reg_write),

        .id_ex_branch(id_ex_branch),
        .id_ex_jump(id_ex_jump),
        .id_ex_jalr(id_ex_jalr),

        .id_ex_op(id_ex_op),
        .id_ex_f3(id_ex_f3),
        .id_ex_f7(id_ex_f7),
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .id_ex_rd(id_ex_rd)
    );

    //////////////////////////////////////////////////////
    // Load Stall Unit
    //////////////////////////////////////////////////////
    load_stall LSU (
        .if_id_rs1(if_id_rs1),
        .if_id_rs2(if_id_rs2),

        .id_ex_rd(id_ex_rd),
        .id_ex_mem_read(id_ex_mem_read),

        .pc_write(pc_write),
        .if_id_write(if_id_write),
        .control_mux_sel(control_mux_sel)
    );

    //////////////////////////////////////////////////////
    // Forwarding Unit
    //////////////////////////////////////////////////////
    forwarding_unit FU (
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),

        .ex_mem_rd(ex_mem_rd),
        .ex_mem_reg_write(ex_mem_reg_write),

        .mem_wb_rd(mem_wb_rd),
        .mem_wb_reg_write(mem_wb_reg_write),

        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    //////////////////////////////////////////////////////
    // EX stage
    //////////////////////////////////////////////////////
    ex_stage EX (
        .clk(clk),
        .rst_n(rst_n),

        .id_ex_pc(id_ex_pc),
        .id_ex_pc4(id_ex_pc4),
        .id_ex_rdata1(id_ex_rdata1),
        .id_ex_rdata2(id_ex_rdata2),
        .id_ex_imm(id_ex_imm),

        .id_ex_alu_control(id_ex_alu_control),
        .id_ex_alu_source(id_ex_alu_source),

        .id_ex_write_back_source(id_ex_write_back_source),
        .id_ex_mem_write(id_ex_mem_write),
        .id_ex_reg_write(id_ex_reg_write),

        .id_ex_branch(id_ex_branch),
        .id_ex_jump(id_ex_jump),
        .id_ex_jalr(id_ex_jalr),

        .id_ex_op(id_ex_op),
        .id_ex_f3(id_ex_f3),
        .id_ex_f7(id_ex_f7),
        .id_ex_rs1(id_ex_rs1),
        .id_ex_rs2(id_ex_rs2),
        .id_ex_rd(id_ex_rd),

        .forward_a(forward_a),
        .forward_b(forward_b),
        .ex_mem_forward_data(ex_mem_forward_data),
        .wb_forward_data(wb_forward_data),

        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rdata2(ex_mem_rdata2),
        .ex_mem_write_back_source(ex_mem_write_back_source),
        .ex_mem_mem_write(ex_mem_mem_write),
        .ex_mem_reg_write(ex_mem_reg_write),
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_pc4(ex_mem_pc4),

        .ex_pc_src(ex_pc_src),
        .ex_pc_target(ex_pc_target)
    );

    //////////////////////////////////////////////////////
    // MEM stage
    //////////////////////////////////////////////////////
    mem_stage MEM (
        .clk(clk),
        .rst_n(rst_n),

        .ex_mem_alu_result(ex_mem_alu_result),
        .ex_mem_rdata2(ex_mem_rdata2),
        .ex_mem_write_back_source(ex_mem_write_back_source),
        .ex_mem_mem_write(ex_mem_mem_write),
        .ex_mem_reg_write(ex_mem_reg_write),
        .ex_mem_rd(ex_mem_rd),
        .ex_mem_pc4(ex_mem_pc4),

        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .mem_wb_write_back_source(mem_wb_write_back_source),
        .mem_wb_reg_write(mem_wb_reg_write),
        .mem_wb_rd(mem_wb_rd),
        .mem_wb_pc4(mem_wb_pc4)
    );

    //////////////////////////////////////////////////////
    // WB stage
    //////////////////////////////////////////////////////
    wb_stage WB (
        .mem_wb_alu_result(mem_wb_alu_result),
        .mem_wb_mem_data(mem_wb_mem_data),
        .mem_wb_pc4(mem_wb_pc4),
        .mem_wb_write_back_source(mem_wb_write_back_source),
        .mem_wb_reg_write(mem_wb_reg_write),
        .mem_wb_rd(mem_wb_rd),

        .wb_write_enable(wb_write_enable),
        .wb_rd(wb_rd),
        .wb_wdata(wb_wdata)
    );

endmodule
