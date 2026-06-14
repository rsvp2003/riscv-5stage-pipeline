module mem_stage (
    input  wire        clk,
    input  wire        rst_n,

    input  wire [31:0] ex_mem_alu_result,
    input  wire [31:0] ex_mem_rdata2,
    input  wire [1:0]  ex_mem_write_back_source,
    input  wire        ex_mem_mem_write,
    input  wire        ex_mem_reg_write,
    input  wire [4:0]  ex_mem_rd,
    input  wire [31:0] ex_mem_pc4,

    output reg  [31:0] mem_wb_alu_result,
    output reg  [31:0] mem_wb_mem_data,
    output reg  [1:0]  mem_wb_write_back_source,
    output reg         mem_wb_reg_write,
    output reg  [4:0]  mem_wb_rd,
    output reg  [31:0] mem_wb_pc4
);

    wire [31:0] dmem_read_data;

    // Data memory
    dmem DMEM (
        .clk(clk),
        .rst_n(rst_n),
        .address(ex_mem_alu_result),
        .write_data(ex_mem_rdata2),
        .write_enable(ex_mem_mem_write),
        .read_data(dmem_read_data)
    );

    // MEM/WB pipeline register
    always @(posedge clk) begin
        if (!rst_n) begin
            mem_wb_alu_result        <= 32'b0;
            mem_wb_mem_data          <= 32'b0;
            mem_wb_write_back_source <= 2'b0;
            mem_wb_reg_write         <= 1'b0;
            mem_wb_rd                <= 5'b0;
            mem_wb_pc4               <= 32'b0;
        end else begin
            mem_wb_alu_result        <= ex_mem_alu_result;
            mem_wb_mem_data          <= dmem_read_data;
            mem_wb_write_back_source <= ex_mem_write_back_source;
            mem_wb_reg_write         <= ex_mem_reg_write;
            mem_wb_rd                <= ex_mem_rd;
            mem_wb_pc4               <= ex_mem_pc4;
        end
    end

endmodule