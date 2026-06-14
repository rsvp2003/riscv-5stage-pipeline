module wb_stage (
    input  wire [31:0] mem_wb_alu_result,
    input  wire [31:0] mem_wb_mem_data,
    input  wire [31:0] mem_wb_pc4,
    input  wire [1:0]  mem_wb_write_back_source,
    input  wire        mem_wb_reg_write,
    input  wire [4:0]  mem_wb_rd,

    output wire        wb_write_enable,
    output wire [4:0]  wb_rd,
    output reg  [31:0] wb_wdata
);

    assign wb_write_enable = mem_wb_reg_write;
    assign wb_rd           = mem_wb_rd;

    always @(*) begin
        case (mem_wb_write_back_source)
            2'b00: wb_wdata = mem_wb_alu_result; // ALU result
            2'b01: wb_wdata = mem_wb_mem_data;   // Load data
            2'b10: wb_wdata = mem_wb_pc4;        // PC+4 for JAL/JALR
            default: wb_wdata = 32'b0;
        endcase
    end

endmodule