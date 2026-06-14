`timescale 1ns/1ps

`include "../rtl/alu.v"
`include "../rtl/ex_stage.v"

module tb_ex_stage;

    reg clk;
    reg rst_n;

    reg [31:0] id_ex_pc;
    reg [31:0] id_ex_pc4;
    reg [31:0] id_ex_rdata1;
    reg [31:0] id_ex_rdata2;
    reg [31:0] id_ex_imm;

    reg [3:0]  id_ex_alu_control;
    reg        id_ex_alu_source;

    reg [1:0]  id_ex_write_back_source;
    reg        id_ex_mem_write;
    reg        id_ex_reg_write;

    reg        id_ex_branch;
    reg        id_ex_jump;
    reg        id_ex_jalr;

    reg [6:0]  id_ex_op;
    reg [2:0]  id_ex_f3;
    reg [6:0]  id_ex_f7;
    reg [4:0]  id_ex_rs1;
    reg [4:0]  id_ex_rs2;
    reg [4:0]  id_ex_rd;

    reg [1:0]  forward_a;
    reg [1:0]  forward_b;
    reg [31:0] ex_mem_forward_data;
    reg [31:0] wb_forward_data;

    wire [31:0] ex_mem_alu_result;
    wire [31:0] ex_mem_rdata2;
    wire [1:0]  ex_mem_write_back_source;
    wire        ex_mem_mem_write;
    wire        ex_mem_reg_write;
    wire [4:0]  ex_mem_rd;
    wire [31:0] ex_mem_pc4;

    wire        ex_pc_src;
    wire [31:0] ex_pc_target;

    ex_stage dut (
        .clk                      (clk),
        .rst_n                    (rst_n),

        .id_ex_pc                 (id_ex_pc),
        .id_ex_pc4                (id_ex_pc4),
        .id_ex_rdata1             (id_ex_rdata1),
        .id_ex_rdata2             (id_ex_rdata2),
        .id_ex_imm                (id_ex_imm),

        .id_ex_alu_control        (id_ex_alu_control),
        .id_ex_alu_source         (id_ex_alu_source),

        .id_ex_write_back_source  (id_ex_write_back_source),
        .id_ex_mem_write          (id_ex_mem_write),
        .id_ex_reg_write          (id_ex_reg_write),

        .id_ex_branch             (id_ex_branch),
        .id_ex_jump               (id_ex_jump),
        .id_ex_jalr               (id_ex_jalr),

        .id_ex_op                 (id_ex_op),
        .id_ex_f3                 (id_ex_f3),
        .id_ex_f7                 (id_ex_f7),
        .id_ex_rs1                (id_ex_rs1),
        .id_ex_rs2                (id_ex_rs2),
        .id_ex_rd                 (id_ex_rd),

        .forward_a                (forward_a),
        .forward_b                (forward_b),
        .ex_mem_forward_data      (ex_mem_forward_data),
        .wb_forward_data          (wb_forward_data),

        .ex_mem_alu_result        (ex_mem_alu_result),
        .ex_mem_rdata2            (ex_mem_rdata2),
        .ex_mem_write_back_source (ex_mem_write_back_source),
        .ex_mem_mem_write         (ex_mem_mem_write),
        .ex_mem_reg_write         (ex_mem_reg_write),
        .ex_mem_rd                (ex_mem_rd),
        .ex_mem_pc4               (ex_mem_pc4),

        .ex_pc_src                (ex_pc_src),
        .ex_pc_target             (ex_pc_target)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../sim/ex_stage_wave.vcd");
        $dumpvars(0, tb_ex_stage);

        clk = 0;
        rst_n = 0;

        id_ex_pc = 0;
        id_ex_pc4 = 0;
        id_ex_rdata1 = 0;
        id_ex_rdata2 = 0;
        id_ex_imm = 0;

        id_ex_alu_control = 0;
        id_ex_alu_source = 0;

        id_ex_write_back_source = 0;
        id_ex_mem_write = 0;
        id_ex_reg_write = 0;

        id_ex_branch = 0;
        id_ex_jump = 0;
        id_ex_jalr = 0;

        id_ex_op = 0;
        id_ex_f3 = 0;
        id_ex_f7 = 0;
        id_ex_rs1 = 0;
        id_ex_rs2 = 0;
        id_ex_rd = 0;

        forward_a = 2'b00;
        forward_b = 2'b00;
        ex_mem_forward_data = 0;
        wb_forward_data = 0;

        #20;
        rst_n = 1;

        id_ex_pc = 32'd0;
        id_ex_pc4 = 32'd4;
        id_ex_rdata1 = 32'd10;
        id_ex_rdata2 = 32'd20;
        id_ex_imm = 32'd0;
        id_ex_alu_control = 4'b0000;
        id_ex_alu_source = 1'b0;
        id_ex_write_back_source = 2'b00;
        id_ex_mem_write = 1'b0;
        id_ex_reg_write = 1'b1;
        id_ex_branch = 1'b0;
        id_ex_jump = 1'b0;
        id_ex_jalr = 1'b0;
        id_ex_op = 7'b0110011;
        id_ex_f3 = 3'b000;
        id_ex_f7 = 7'b0000000;
        id_ex_rs1 = 5'd1;
        id_ex_rs2 = 5'd2;
        id_ex_rd = 5'd3;
        forward_a = 2'b00;
        forward_b = 2'b00;
        #10;
        $display("ADD      : alu_result=%0d rd=%0d reg_write=%b",
                 ex_mem_alu_result, ex_mem_rd, ex_mem_reg_write);

        id_ex_pc = 32'd4;
        id_ex_pc4 = 32'd8;
        id_ex_rdata1 = 32'd50;
        id_ex_rdata2 = 32'd15;
        id_ex_alu_control = 4'b0001;
        id_ex_alu_source = 1'b0;
        id_ex_rd = 5'd4;
        #10;
        $display("SUB      : alu_result=%0d rd=%0d",
                 ex_mem_alu_result, ex_mem_rd);

        id_ex_pc = 32'd8;
        id_ex_pc4 = 32'd12;
        id_ex_rdata1 = 32'd10;
        id_ex_rdata2 = 32'd0;
        id_ex_imm = 32'd5;
        id_ex_alu_control = 4'b0000;
        id_ex_alu_source = 1'b1;
        id_ex_rd = 5'd5;
        #10;
        $display("ADDI     : alu_result=%0d rd=%0d",
                 ex_mem_alu_result, ex_mem_rd);

        id_ex_pc = 32'd12;
        id_ex_pc4 = 32'd16;
        id_ex_rdata1 = 32'd10;
        id_ex_rdata2 = 32'd20;
        ex_mem_forward_data = 32'd100;
        wb_forward_data = 32'd200;
        forward_a = 2'b10;
        forward_b = 2'b00;
        id_ex_alu_control = 4'b0000;
        id_ex_alu_source = 1'b0;
        id_ex_rd = 5'd6;
        #10;
        $display("FWD A EX : alu_result=%0d expected=120",
                 ex_mem_alu_result);

        id_ex_pc = 32'd16;
        id_ex_pc4 = 32'd20;
        id_ex_rdata1 = 32'd10;
        id_ex_rdata2 = 32'd20;
        ex_mem_forward_data = 32'd100;
        wb_forward_data = 32'd200;
        forward_a = 2'b00;
        forward_b = 2'b01;
        id_ex_alu_control = 4'b0000;
        id_ex_alu_source = 1'b0;
        id_ex_rd = 5'd7;
        #10;
        $display("FWD B WB : alu_result=%0d expected=210",
                 ex_mem_alu_result);

        id_ex_pc = 32'd20;
        id_ex_pc4 = 32'd24;
        id_ex_rdata1 = 32'd30;
        id_ex_rdata2 = 32'd30;
        id_ex_imm = 32'd16;
        id_ex_alu_control = 4'b0001;
        id_ex_alu_source = 1'b0;
        id_ex_branch = 1'b1;
        id_ex_jump = 1'b0;
        id_ex_jalr = 1'b0;
        id_ex_f3 = 3'b000;
        forward_a = 2'b00;
        forward_b = 2'b00;
        id_ex_rd = 5'd0;
        id_ex_reg_write = 1'b0;
        #10;
        $display("BEQ TAKEN: ex_pc_src=%b target=%0d",
                 ex_pc_src, ex_pc_target);

        id_ex_pc = 32'd24;
        id_ex_pc4 = 32'd28;
        id_ex_rdata1 = 32'd30;
        id_ex_rdata2 = 32'd40;
        id_ex_imm = 32'd16;
        id_ex_alu_control = 4'b0001;
        id_ex_branch = 1'b1;
        id_ex_f3 = 3'b000;
        #10;
        $display("BEQ NOT  : ex_pc_src=%b target=%0d",
                 ex_pc_src, ex_pc_target);

        id_ex_pc = 32'd28;
        id_ex_pc4 = 32'd32;
        id_ex_imm = 32'd20;
        id_ex_branch = 1'b0;
        id_ex_jump = 1'b1;
        id_ex_jalr = 1'b0;
        id_ex_reg_write = 1'b1;
        id_ex_write_back_source = 2'b10;
        id_ex_rd = 5'd1;
        #10;
        $display("JAL      : ex_pc_src=%b target=%0d pc4=%0d rd=%0d wb_src=%b",
                 ex_pc_src, ex_pc_target, ex_mem_pc4, ex_mem_rd,
                 ex_mem_write_back_source);

        id_ex_pc = 32'd40;
        id_ex_pc4 = 32'd44;
        id_ex_rdata1 = 32'd100;
        id_ex_imm = 32'd12;
        id_ex_branch = 1'b0;
        id_ex_jump = 1'b0;
        id_ex_jalr = 1'b1;
        id_ex_reg_write = 1'b1;
        id_ex_write_back_source = 2'b10;
        id_ex_rd = 5'd2;
        forward_a = 2'b00;
        #10;
        $display("JALR     : ex_pc_src=%b target=%0d pc4=%0d rd=%0d wb_src=%b",
                 ex_pc_src, ex_pc_target, ex_mem_pc4, ex_mem_rd,
                 ex_mem_write_back_source);

        id_ex_pc = 32'd44;
        id_ex_pc4 = 32'd48;
        id_ex_rdata1 = 32'd0;
        id_ex_rdata2 = 32'd0;
        id_ex_imm = 32'h12345000;
        id_ex_alu_control = 4'b0000;
        id_ex_alu_source = 1'b1;
        id_ex_op = 7'b0110111;
        id_ex_branch = 1'b0;
        id_ex_jump = 1'b0;
        id_ex_jalr = 1'b0;
        id_ex_reg_write = 1'b1;
        id_ex_write_back_source = 2'b00;
        id_ex_rd = 5'd10;
        #10;
        $display("LUI      : alu_result=%h expected=12345000",
                 ex_mem_alu_result);

        id_ex_pc = 32'd100;
        id_ex_pc4 = 32'd104;
        id_ex_imm = 32'h00001000;
        id_ex_op = 7'b0010111;
        id_ex_alu_source = 1'b1;
        id_ex_alu_control = 4'b0000;
        id_ex_rd = 5'd11;
        #10;
        $display("AUIPC    : alu_result=%0d expected=%0d",
                 ex_mem_alu_result, 32'd100 + 32'h00001000);

        #20;
        $finish;
    end

endmodule
