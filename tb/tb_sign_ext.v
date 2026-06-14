`timescale 1ns/1ps
`include "../rtl/sign_ext.v"

module tb_sign_ext;

    reg  [31:0] raw_src;
    reg  [2:0]  imm_source;
    wire [31:0] immediate;

    sign_ext dut (
        .raw_src    (raw_src),
        .imm_source (imm_source),
        .immediate  (immediate)
    );

    initial begin
        $dumpfile("sign_ext_wave.vcd");
        $dumpvars(0, tb_sign_ext);

        raw_src = 32'h0050_0093;
        imm_source = 3'b000;
        #10;
        $display("I-type : raw_src=%h immediate=%h expected=00000005",
                 raw_src, immediate);

        raw_src = 32'hFEA4_2E23;
        imm_source = 3'b001;
        #10;
        $display("S-type : raw_src=%h immediate=%h expected=fffffffc",
                 raw_src, immediate);

        raw_src = 32'h0020_8463;
        imm_source = 3'b010;
        #10;
        $display("B-type : raw_src=%h immediate=%h expected=00000008",
                 raw_src, immediate);

        raw_src = 32'h0080_00EF;
        imm_source = 3'b011;
        #10;
        $display("J-type : raw_src=%h immediate=%h expected=00000008",
                 raw_src, immediate);

        raw_src = 32'h1234_5237;
        imm_source = 3'b100;
        #10;
        $display("U-type : raw_src=%h immediate=%h expected=12345000",
                 raw_src, immediate);

        raw_src = 32'hFFF0_0093;
        imm_source = 3'b000;
        #10;
        $display("I-type negative : raw_src=%h immediate=%h expected=ffffffff",
                 raw_src, immediate);

        raw_src = 32'h0000_0000;
        imm_source = 3'b111;
        #10;
        $display("Default : raw_src=%h immediate=%h expected=00000000",
                 raw_src, immediate);

        #10;
        $finish;
    end

endmodule
