`timescale 1ns/1ps

`include "../rtl/cpu_top.v"

module tb_cpu_top;

    reg clk;
    reg rst_n;

    cpu_top dut (
        .clk   (clk),
        .rst_n (rst_n)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("../sim/cpu_top_wave.vcd");
        $dumpvars(0, tb_cpu_top);

        clk = 0;
        rst_n = 0;

        #20;
        rst_n = 1;

        #500;

        $finish;
    end

endmodule
