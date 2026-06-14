module forwarding_unit (
    // Source registers of instruction currently in EX stage
    input  wire [4:0] id_ex_rs1,
    input  wire [4:0] id_ex_rs2,

    // Destination register of instruction currently in MEM stage
    input  wire [4:0] ex_mem_rd,
    input  wire       ex_mem_reg_write,

    // Destination register of instruction currently in WB stage
    input  wire [4:0] mem_wb_rd,
    input  wire       mem_wb_reg_write,

    // Forwarding select outputs
    // 2'b00 -> use original id_ex_rdata
    // 2'b10 -> forward from EX/MEM stage
    // 2'b01 -> forward from MEM/WB stage
    output reg  [1:0] forward_a,
    output reg  [1:0] forward_b
);

always @(*) begin
    // Default: no forwarding
    forward_a = 2'b00;
    forward_b = 2'b00;

    // =========================
    // Forward for ALU src1 (rs1)
    // =========================
    // Highest priority: EX/MEM
    if (ex_mem_reg_write &&
        (ex_mem_rd != 5'b00000) &&
        (ex_mem_rd == id_ex_rs1)) begin
        forward_a = 2'b10;
    end
    // Next priority: MEM/WB
    else if (mem_wb_reg_write &&
             (mem_wb_rd != 5'b00000) &&
             (mem_wb_rd == id_ex_rs1)) begin
        forward_a = 2'b01;
    end

    // =========================
    // Forward for ALU src2 (rs2)
    // =========================
    // Highest priority: EX/MEM
    if (ex_mem_reg_write &&
        (ex_mem_rd != 5'b00000) &&
        (ex_mem_rd == id_ex_rs2)) begin
        forward_b = 2'b10;
    end
    // Next priority: MEM/WB
    else if (mem_wb_reg_write &&
             (mem_wb_rd != 5'b00000) &&
             (mem_wb_rd == id_ex_rs2)) begin
        forward_b = 2'b01;
    end
end

endmodule