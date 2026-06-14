`timescale 1ns/1ps

`include "../rtl/control.v"
`include "../rtl/sign_ext.v"
`include "../rtl/reg_file.v"
`include "../rtl/id_stage.v"

module tb_id_stage;

    reg         clk;
    reg         rst_n;

    reg         control_mux_sel;
    reg         id_ex_flush;

    reg  [31:0] if_id_pc;
    reg  [31:0] if_id_pc4;
    reg  [31:0] if_id_instr;

    reg         wb_write_enable;
    reg  [4:0]  wb_rd;
    reg  [31:0] wb_wdata;

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

    id_stage dut (
        .clk                     (clk),
        .rst_n                   (rst_n),

        .control_mux_sel         (control_mux_sel),
        .id_ex_flush             (id_ex_flush),

        .if_id_pc                (if_id_pc),
        .if_id_pc4               (if_id_pc4),
        .if_id_instr             (if_id_instr),

        .wb_write_enable         (wb_write_enable),
        .wb_rd                   (wb_rd),
        .wb_wdata                (wb_wdata),

        .id_ex_pc                (id_ex_pc),
        .id_ex_pc4               (id_ex_pc4),
        .id_ex_rdata1            (id_ex_rdata1),
        .id_ex_rdata2            (id_ex_rdata2),
        .id_ex_imm               (id_ex_imm),

        .id_ex_alu_control       (id_ex_alu_control),
        .id_ex_alu_source        (id_ex_alu_source),
        .id_ex_write_back_source (id_ex_write_back_source),
        .id_ex_mem_write         (id_ex_mem_write),
        .id_ex_reg_write         (id_ex_reg_write),

        .id_ex_branch            (id_ex_branch),
        .id_ex_jump              (id_ex_jump),
        .id_ex_jalr              (id_ex_jalr),

        .id_ex_op                (id_ex_op),
        .id_ex_f3                (id_ex_f3),
        .id_ex_f7                (id_ex_f7),
        .id_ex_rs1               (id_ex_rs1),
        .id_ex_rs2               (id_ex_rs2),
        .id_ex_rd                (id_ex_rd)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../sim/id_stage_wave.vcd");
        $dumpvars(0, tb_id_stage);

        clk = 0;
        rst_n = 0;

        control_mux_sel = 0;
        id_ex_flush = 0;

        if_id_pc = 0;
        if_id_pc4 = 4;
        if_id_instr = 32'b0;

        wb_write_enable = 0;
        wb_rd = 0;
        wb_wdata = 0;

        #20;
        rst_n = 1;

        wb_rd = 5'd1;
        wb_wdata = 32'd10;
        wb_write_enable = 1;
        #10;
        wb_write_enable = 0;

        wb_rd = 5'd2;
        wb_wdata = 32'd20;
        wb_write_enable = 1;
        #10;
        wb_write_enable = 0;

        if_id_pc = 32'd0;
        if_id_pc4 = 32'd4;
        if_id_instr = 32'h002081B3;   
        #10;
        $display("ADD  : rs1=%0d rs2=%0d rd=%0d rdata1=%0d rdata2=%0d alu_ctrl=%b reg_write=%b",
                 id_ex_rs1, id_ex_rs2, id_ex_rd,
                 id_ex_rdata1, id_ex_rdata2,
                 id_ex_alu_control, id_ex_reg_write);

        if_id_pc = 32'd4;
        if_id_pc4 = 32'd8;
        if_id_instr = 32'h00518213;
        #10;
        $display("ADDI : rs1=%0d rd=%0d rdata1=%0d imm=%0d alu_src=%b reg_write=%b",
                 id_ex_rs1, id_ex_rd,
                 id_ex_rdata1, id_ex_imm,
                 id_ex_alu_source, id_ex_reg_write);

        if_id_pc = 32'd8;
        if_id_pc4 = 32'd12;
        if_id_instr = 32'h0041A283;
        #10;
        $display("LW   : rs1=%0d rd=%0d imm=%0d alu_src=%b wb_src=%b reg_write=%b mem_write=%b",
                 id_ex_rs1, id_ex_rd, id_ex_imm,
                 id_ex_alu_source, id_ex_write_back_source,
                 id_ex_reg_write, id_ex_mem_write);

        if_id_pc = 32'd12;
        if_id_pc4 = 32'd16;
        if_id_instr = 32'h0051A223;
        #10;
        $display("SW   : rs1=%0d rs2=%0d imm=%0d alu_src=%b reg_write=%b mem_write=%b",
                 id_ex_rs1, id_ex_rs2, id_ex_imm,
                 id_ex_alu_source, id_ex_reg_write, id_ex_mem_write);

        if_id_pc = 32'd16;
        if_id_pc4 = 32'd20;
        if_id_instr = 32'h00208463;
        #10;
        $display("BEQ  : rs1=%0d rs2=%0d imm=%0d branch=%b reg_write=%b mem_write=%b",
                 id_ex_rs1, id_ex_rs2, id_ex_imm,
                 id_ex_branch, id_ex_reg_write, id_ex_mem_write);

        control_mux_sel = 1;
        if_id_instr = 32'h002081B3;
        #10;
        $display("STALL BUBBLE : reg_write=%b mem_write=%b branch=%b jump=%b jalr=%b rd=%0d",
                 id_ex_reg_write, id_ex_mem_write,
                 id_ex_branch, id_ex_jump, id_ex_jalr, id_ex_rd);

        control_mux_sel = 0;

        id_ex_flush = 1;
        if_id_instr = 32'h00518213;
        #10;
        $display("BRANCH FLUSH : reg_write=%b mem_write=%b branch=%b jump=%b jalr=%b rd=%0d",
                 id_ex_reg_write, id_ex_mem_write,
                 id_ex_branch, id_ex_jump, id_ex_jalr, id_ex_rd);

        id_ex_flush = 0;

        if_id_pc = 32'd24;
        if_id_pc4 = 32'd28;
        if_id_instr = 32'h008000EF;
        #10;
        $display("JAL  : rd=%0d imm=%0d jump=%b wb_src=%b reg_write=%b",
                 id_ex_rd, id_ex_imm,
                 id_ex_jump, id_ex_write_back_source, id_ex_reg_write);

        if_id_pc = 32'd28;
        if_id_pc4 = 32'd32;
        if_id_instr = 32'h000080E7;
        #10;
        $display("JALR : rs1=%0d rd=%0d imm=%0d jalr=%b wb_src=%b reg_write=%b",
                 id_ex_rs1, id_ex_rd, id_ex_imm,
                 id_ex_jalr, id_ex_write_back_source, id_ex_reg_write);

        #20;
        $finish;
    end

endmodule
