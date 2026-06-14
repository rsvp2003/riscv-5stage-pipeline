`timescale 1ns/1ps
`include "../rtl/control.v"

module tb_control;

    reg  [6:0] op;
    reg  [2:0] func3;
    reg  [6:0] func7;

    wire [3:0] alu_control;
    wire [2:0] imm_source;
    wire       mem_write;
    wire       reg_write;
    wire       alu_source;
    wire [1:0] write_back_source;
    wire       second_add_source;
    wire       branch;
    wire       jump;
    wire       jalr;

    control dut (
        .op                (op),
        .func3             (func3),
        .func7             (func7),
        .alu_control       (alu_control),
        .imm_source        (imm_source),
        .mem_write         (mem_write),
        .reg_write         (reg_write),
        .alu_source        (alu_source),
        .write_back_source (write_back_source),
        .second_add_source (second_add_source),
        .branch            (branch),
        .jump              (jump),
        .jalr              (jalr)
    );

    initial begin
        $dumpfile("../sim/control_wave.vcd");
        $dumpvars(0, tb_control);

        op = 7'b0000011; func3 = 3'b010; func7 = 7'b0000000; #20;
        $display("LW    : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0100011; func3 = 3'b010; func7 = 7'b0000000; #20;
        $display("SW    : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0110011; func3 = 3'b000; func7 = 7'b0000000; #20;
        $display("ADD   : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0110011; func3 = 3'b000; func7 = 7'b0100000; #20;
        $display("SUB   : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0110011; func3 = 3'b111; func7 = 7'b0000000; #20;
        $display("AND   : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0110011; func3 = 3'b110; func7 = 7'b0000000; #20;
        $display("OR    : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0010011; func3 = 3'b000; func7 = 7'b0000000; #20;
        $display("ADDI  : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0010011; func3 = 3'b010; func7 = 7'b0000000; #20;
        $display("SLTI  : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b1100011; func3 = 3'b000; func7 = 7'b0000000; #20;
        $display("BEQ   : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b1100011; func3 = 3'b001; func7 = 7'b0000000; #20;
        $display("BNE   : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b1101111; func3 = 3'b000; func7 = 7'b0000000; #20;
        $display("JAL   : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b1100111; func3 = 3'b000; func7 = 7'b0000000; #20;
        $display("JALR  : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, branch, jump, jalr);

        op = 7'b0110111; func3 = 3'b000; func7 = 7'b0000000; #20;
        $display("LUI   : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b second_add_source=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, second_add_source, branch, jump, jalr);

        op = 7'b0010111; func3 = 3'b000; func7 = 7'b0000000; #20;
        $display("AUIPC : alu_control=%b imm_source=%b mem_write=%b reg_write=%b alu_source=%b wb_src=%b second_add_source=%b branch=%b jump=%b jalr=%b",
                 alu_control, imm_source, mem_write, reg_write, alu_source, write_back_source, second_add_source, branch, jump, jalr);

        #20;
        $finish;
    end

endmodule
