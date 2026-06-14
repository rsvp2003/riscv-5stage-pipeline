`timescale 1ns/1ps
`include "../rtl/alu.v"

module tb_alu;

    reg  [3:0]  alu_control;
    reg  [31:0] src1;
    reg  [31:0] src2;

    wire [31:0] alu_result;
    wire        zero;
    wire        less_than;
    wire        less_than_u;

    alu dut (
        .alu_control (alu_control),
        .src1        (src1),
        .src2        (src2),
        .alu_result  (alu_result),
        .zero        (zero),
        .less_than   (less_than),
        .less_than_u (less_than_u)
    );

    initial begin

        $dumpfile("alu_wave.vcd");
        $dumpvars(0, tb_alu);

        src1 = 10;
        src2 = 5;

        alu_control = 4'b0000; #10;
        $display("ADD  : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        alu_control = 4'b0001; #10;
        $display("SUB  : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        alu_control = 4'b0010; #10;
        $display("AND  : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        alu_control = 4'b0011; #10;
        $display("OR   : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        alu_control = 4'b1000; #10;
        $display("XOR  : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        alu_control = 4'b0101; #10;
        $display("SLT  : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        alu_control = 4'b0111; #10;
        $display("SLTU : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        src1 = 8;
        src2 = 2;

        alu_control = 4'b1001; #10;
        $display("SLL  : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        alu_control = 4'b1010; #10;
        $display("SRL  : src1=%0d src2=%0d result=%0d", src1, src2, alu_result);

        src1 = 32'hFFFF_FFF0;
        src2 = 2;

        alu_control = 4'b1011; #10;
        $display("SRA  : src1=%h src2=%0d result=%h", src1, src2, alu_result);

        src1 = 5;
        src2 = 5;

        alu_control = 4'b0001; #10;
        $display("ZERO : src1=%0d src2=%0d result=%0d zero=%b",
                 src1, src2, alu_result, zero);

        src1 = -5;
        src2 = 3;

        alu_control = 4'b0101; #10;
        $display("SLT Signed : src1=%0d src2=%0d result=%0d",
                 $signed(src1), $signed(src2), alu_result);

        src1 = 32'hFFFF_FFFF;
        src2 = 1;

        alu_control = 4'b0111; #10;
        $display("SLTU Unsigned : src1=%h src2=%0d result=%0d",
                 src1, src2, alu_result);

        #10;
        $finish;
    end

endmodule
