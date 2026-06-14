module dmem (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    input  wire        write_enable,
    output wire [31:0] read_data
);

    integer i;
    reg [31:0] mem [0:63];

    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 64; i = i + 1)
                mem[i] <= 32'b0;
        end
        else if (write_enable) begin
            if (address[1:0] == 2'b00)
                mem[address[31:2]] <= write_data;
        end
    end

    assign read_data = mem[address[31:2]];

endmodule