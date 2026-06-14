`timescale 1ns/1ps
`include "../rtl/dmem.v"

module tb_dmem;

    reg         clk;
    reg         rst_n;
    reg  [31:0] address;
    reg  [31:0] write_data;
    reg         write_enable;
    wire [31:0] read_data;

    dmem dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .address      (address),
        .write_data   (write_data),
        .write_enable (write_enable),
        .read_data    (read_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("dmem_wave.vcd");
        $dumpvars(0, tb_dmem);

        clk = 0;
        rst_n = 0;
        address = 0;
        write_data = 0;
        write_enable = 0;

        #20;
        rst_n = 1;

        address = 32'd0;
        write_data = 32'hAAAA_1111;
        write_enable = 1;
        #10;
        write_enable = 0;
        #10;
        $display("WRITE/READ address=%0d data=%h", address, read_data);

        address = 32'd4;
        write_data = 32'hBBBB_2222;
        write_enable = 1;
        #10;
        write_enable = 0;
        #10;
        $display("WRITE/READ address=%0d data=%h", address, read_data);

        address = 32'd8;
        write_data = 32'hCCCC_3333;
        write_enable = 1;
        #10;
        write_enable = 0;
        #10;
        $display("WRITE/READ address=%0d data=%h", address, read_data);

        address = 32'd0;
        #20;
        $display("READ address=%0d data=%h", address, read_data);

        address = 32'd4;
        #20;
        $display("READ address=%0d data=%h", address, read_data);

        address = 32'd8;
        #20;
        $display("READ address=%0d data=%h", address, read_data);

        #20;
        $finish;
    end

endmodule
