module id_stage (
    input  wire        clk,
    input  wire        rst_n,

    // Load-stall bubble control
    input  wire        control_mux_sel,

    // Branch flush control
    input  wire        id_ex_flush,

    input  wire [31:0] if_id_pc,
    input  wire [31:0] if_id_pc4,
    input  wire [31:0] if_id_instr,

    // From WB stage
    input  wire        wb_write_enable,
    input  wire [4:0]  wb_rd,
    input  wire [31:0] wb_wdata,

    output reg  [31:0] id_ex_pc,
    output reg  [31:0] id_ex_pc4,
    output reg  [31:0] id_ex_rdata1,
    output reg  [31:0] id_ex_rdata2,
    output reg  [31:0] id_ex_imm,

    output reg  [3:0]  id_ex_alu_control,
    output reg         id_ex_alu_source,
    output reg  [1:0]  id_ex_write_back_source,
    output reg         id_ex_mem_write,
    output reg         id_ex_reg_write,

    output reg         id_ex_branch,
    output reg         id_ex_jump,
    output reg         id_ex_jalr,

    output reg  [6:0]  id_ex_op,
    output reg  [2:0]  id_ex_f3,
    output reg  [6:0]  id_ex_f7,
    output reg  [4:0]  id_ex_rs1,
    output reg  [4:0]  id_ex_rs2,
    output reg  [4:0]  id_ex_rd
);

    wire [6:0] op    = if_id_instr[6:0];
    wire [2:0] func3 = if_id_instr[14:12];
    wire [6:0] func7 = if_id_instr[31:25];
    wire [4:0] rs1   = if_id_instr[19:15];
    wire [4:0] rs2   = if_id_instr[24:20];
    wire [4:0] rd    = if_id_instr[11:7];

    wire [31:0] rf_rdata1;
    wire [31:0] rf_rdata2;
    wire [31:0] imm;

    wire [3:0] alu_control;
    wire [2:0] imm_source;
    wire       mem_write;
    wire       reg_write;
    wire       alu_source;
    wire [1:0] write_back_source;
    wire       second_add_source;
    wire       branch;
    wire       jump;
    wire       jalr;

    control CTRL (
        .op(op),
        .func3(func3),
        .func7(func7),

        .alu_control(alu_control),
        .imm_source(imm_source),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_source(alu_source),
        .write_back_source(write_back_source),
        .second_add_source(second_add_source),
        .branch(branch),
        .jump(jump),
        .jalr(jalr)
    );

    reg_file RF (
        .clk(clk),

        .address1(rs1),
        .address2(rs2),
        .read_data1(rf_rdata1),
        .read_data2(rf_rdata2),

        .write_enable(wb_write_enable),
        .address3(wb_rd),
        .write_data(wb_wdata)
    );

    sign_ext SE (
        .raw_src(if_id_instr),
        .imm_source(imm_source),
        .immediate(imm)
    );

    // ID/EX pipeline register
    always @(posedge clk) begin
        if (!rst_n) begin
            id_ex_pc                <= 32'b0;
            id_ex_pc4               <= 32'b0;
            id_ex_rdata1            <= 32'b0;
            id_ex_rdata2            <= 32'b0;
            id_ex_imm               <= 32'b0;

            id_ex_alu_control       <= 4'b0;
            id_ex_alu_source        <= 1'b0;
            id_ex_write_back_source <= 2'b0;
            id_ex_mem_write         <= 1'b0;
            id_ex_reg_write         <= 1'b0;

            id_ex_branch            <= 1'b0;
            id_ex_jump              <= 1'b0;
            id_ex_jalr              <= 1'b0;

            id_ex_op                <= 7'b0;
            id_ex_f3                <= 3'b0;
            id_ex_f7                <= 7'b0;
            id_ex_rs1               <= 5'b0;
            id_ex_rs2               <= 5'b0;
            id_ex_rd                <= 5'b0;
        end

        else if (id_ex_flush || control_mux_sel) begin
            id_ex_pc                <= 32'b0;
            id_ex_pc4               <= 32'b0;
            id_ex_rdata1            <= 32'b0;
            id_ex_rdata2            <= 32'b0;
            id_ex_imm               <= 32'b0;

            id_ex_alu_control       <= 4'b0;
            id_ex_alu_source        <= 1'b0;
            id_ex_write_back_source <= 2'b0;
            id_ex_mem_write         <= 1'b0;
            id_ex_reg_write         <= 1'b0;

            id_ex_branch            <= 1'b0;
            id_ex_jump              <= 1'b0;
            id_ex_jalr              <= 1'b0;

            id_ex_op                <= 7'b0;
            id_ex_f3                <= 3'b0;
            id_ex_f7                <= 7'b0;
            id_ex_rs1               <= 5'b0;
            id_ex_rs2               <= 5'b0;
            id_ex_rd                <= 5'b0;
        end

        else begin
            id_ex_pc     <= if_id_pc;
            id_ex_pc4    <= if_id_pc4;
            id_ex_rdata1 <= rf_rdata1;
            id_ex_rdata2 <= rf_rdata2;
            id_ex_imm    <= imm;

            id_ex_alu_control       <= alu_control;
            id_ex_alu_source        <= alu_source;
            id_ex_write_back_source <= write_back_source;
            id_ex_mem_write         <= mem_write;
            id_ex_reg_write         <= reg_write;

            id_ex_branch            <= branch;
            id_ex_jump              <= jump;
            id_ex_jalr              <= jalr;

            id_ex_op                <= op;
            id_ex_f3                <= func3;
            id_ex_f7                <= func7;
            id_ex_rs1               <= rs1;
            id_ex_rs2               <= rs2;
            id_ex_rd                <= rd;
        end
    end

endmodule
