module ex_stage (
    input  wire        clk,
    input  wire        rst_n,

    input  wire [31:0] id_ex_pc,
    input  wire [31:0] id_ex_pc4,
    input  wire [31:0] id_ex_rdata1,
    input  wire [31:0] id_ex_rdata2,
    input  wire [31:0] id_ex_imm,

    input  wire [3:0]  id_ex_alu_control,
    input  wire        id_ex_alu_source,

    input  wire [1:0]  id_ex_write_back_source,
    input  wire        id_ex_mem_write,
    input  wire        id_ex_reg_write,

    input  wire        id_ex_branch,
    input  wire        id_ex_jump,
    input  wire        id_ex_jalr,

    input  wire [6:0]  id_ex_op,
    input  wire [2:0]  id_ex_f3,
    input  wire [6:0]  id_ex_f7,
    input  wire [4:0]  id_ex_rs1,
    input  wire [4:0]  id_ex_rs2,
    input  wire [4:0]  id_ex_rd,

    // Forwarding control
    input  wire [1:0]  forward_a,
    input  wire [1:0]  forward_b,

    // Forwarded data from later stages
    input  wire [31:0] ex_mem_forward_data,
    input  wire [31:0] wb_forward_data,

    output reg  [31:0] ex_mem_alu_result,
    output reg  [31:0] ex_mem_rdata2,
    output reg  [1:0]  ex_mem_write_back_source,
    output reg         ex_mem_mem_write,
    output reg         ex_mem_reg_write,
    output reg  [4:0]  ex_mem_rd,
    output reg  [31:0] ex_mem_pc4,

    output wire        ex_pc_src,
    output wire [31:0] ex_pc_target
);

    // For AUIPC/LUI handling
    wire is_lui;
    wire is_auipc;

    assign is_lui   = (id_ex_op == 7'b0110111);
    assign is_auipc = (id_ex_op == 7'b0010111);

    // Forwarded register operands
    reg [31:0] forwarded_rs1;
    reg [31:0] forwarded_rs2;

    always @(*) begin
        case (forward_a)
            2'b00: forwarded_rs1 = id_ex_rdata1;
            2'b10: forwarded_rs1 = ex_mem_forward_data;
            2'b01: forwarded_rs1 = wb_forward_data;
            default: forwarded_rs1 = id_ex_rdata1;
        endcase
    end

    always @(*) begin
        case (forward_b)
            2'b00: forwarded_rs2 = id_ex_rdata2;
            2'b10: forwarded_rs2 = ex_mem_forward_data;
            2'b01: forwarded_rs2 = wb_forward_data;
            default: forwarded_rs2 = id_ex_rdata2;
        endcase
    end

    // Final ALU inputs after forwarding
    wire [31:0] alu_src1;
    wire [31:0] alu_src2;

    assign alu_src1 = is_lui   ? 32'b0 :
                      is_auipc ? id_ex_pc :
                                 forwarded_rs1;

    assign alu_src2 = id_ex_alu_source ? id_ex_imm : forwarded_rs2;

    wire [31:0] alu_result;
    wire        zero;
    wire        less_than;
    wire        less_than_u;

    alu ALU (
        .alu_control(id_ex_alu_control),
        .src1(alu_src1),
        .src2(alu_src2),
        .alu_result(alu_result),
        .zero(zero),
        .less_than(less_than),
        .less_than_u(less_than_u)
    );

    // Branch taken logic
    wire branch_taken;

    assign branch_taken =
        id_ex_branch & (
            (id_ex_f3 == 3'b000 &&  zero)        |  // BEQ
            (id_ex_f3 == 3'b001 && !zero)        |  // BNE
            (id_ex_f3 == 3'b100 &&  less_than)   |  // BLT
            (id_ex_f3 == 3'b101 && !less_than)   |  // BGE
            (id_ex_f3 == 3'b110 &&  less_than_u) |  // BLTU
            (id_ex_f3 == 3'b111 && !less_than_u)    // BGEU
        );

    assign ex_pc_src = id_ex_jump | id_ex_jalr | branch_taken;

    assign ex_pc_target =
        id_ex_jump ? (id_ex_pc + id_ex_imm) :
        id_ex_jalr ? ((forwarded_rs1 + id_ex_imm) & ~32'd1) :
                     (id_ex_pc + id_ex_imm);

    // EX/MEM pipeline register
    always @(posedge clk) begin
        if (!rst_n) begin
            ex_mem_alu_result        <= 32'b0;
            ex_mem_rdata2            <= 32'b0;
            ex_mem_write_back_source <= 2'b0;
            ex_mem_mem_write         <= 1'b0;
            ex_mem_reg_write         <= 1'b0;
            ex_mem_rd                <= 5'b0;
            ex_mem_pc4               <= 32'b0;
        end
        else begin
            ex_mem_alu_result        <= alu_result;
            ex_mem_rdata2            <= forwarded_rs2;
            ex_mem_write_back_source <= id_ex_write_back_source;
            ex_mem_mem_write         <= id_ex_mem_write;
            ex_mem_reg_write         <= id_ex_reg_write;
            ex_mem_rd                <= id_ex_rd;
            ex_mem_pc4               <= id_ex_pc4;
        end
    end

endmodule