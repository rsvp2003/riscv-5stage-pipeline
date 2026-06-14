`timescale 1ns/1ps
`include "../rtl/imem.v"

module tb_imem;

    reg         clk;
    reg         rst_n;
    reg  [31:0] address;
    wire [31:0] read_data;

    imem dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .address   (address),
        .read_data (read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("imem_wave.vcd");
        $dumpvars(0, tb_imem);

        clk = 0;
        rst_n = 0;
        address = 0;

        #20;
        rst_n = 1;

        dut.mem[0] = 32'h00500093;
        dut.mem[1] = 32'h00A00113;
        dut.mem[2] = 32'h002081B3;
        dut.mem[3] = 32'h40118233;

        address = 32'd0;   #20;
        $display("IMEM[0] address=%0d read_data=%h", address, read_data);

        address = 32'd4;   #20;
        $display("IMEM[1] address=%0d read_data=%h", address, read_data);

        address = 32'd8;   #20;
        $display("IMEM[2] address=%0d read_data=%h", address, read_data);

        address = 32'd12;  #20;
        $display("IMEM[3] address=%0d read_data=%h", address, read_data);

        #20;
        $finish;
    end

endmodule
