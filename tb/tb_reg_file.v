`timescale 1ns/1ps
`include "../rtl/reg_file.v"

module tb_reg_file;

    reg         clk;
    reg  [4:0]  address1;
    reg  [4:0]  address2;
    reg         write_enable;
    reg  [4:0]  address3;
    reg  [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    reg_file dut (
        .clk          (clk),
        .address1     (address1),
        .address2     (address2),
        .read_data1   (read_data1),
        .read_data2   (read_data2),
        .write_enable (write_enable),
        .address3     (address3),
        .write_data   (write_data)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("reg_file_wave.vcd");
        $dumpvars(0, tb_reg_file);

        clk = 0;
        address1 = 0;
        address2 = 0;
        write_enable = 0;
        address3 = 0;
        write_data = 0;

        #10;

        address3 = 5'd1;
        write_data = 32'd100;
        write_enable = 1;
        #10;
        write_enable = 0;

        address1 = 5'd1;
        #10;
        $display("READ x1 : read_data1=%0d", read_data1);

        address3 = 5'd2;
        write_data = 32'd200;
        write_enable = 1;
        #10;
        write_enable = 0;

        address2 = 5'd2;
        #10;
        $display("READ x2 : read_data2=%0d", read_data2);

        address1 = 5'd1;
        address2 = 5'd2;
        #10;
        $display("READ x1/x2 : read_data1=%0d read_data2=%0d",
                 read_data1, read_data2);

        address3 = 5'd0;
        write_data = 32'd999;
        write_enable = 1;
        #10;
        write_enable = 0;

        address1 = 5'd0;
        #10;
        $display("READ x0 : read_data1=%0d", read_data1);

        address3 = 5'd1;
        write_data = 32'd555;
        write_enable = 0;
        #10;

        address1 = 5'd1;
        #10;
        $display("WRITE disabled check x1 : read_data1=%0d", read_data1);

        #20;
        $finish;
    end

endmodule
