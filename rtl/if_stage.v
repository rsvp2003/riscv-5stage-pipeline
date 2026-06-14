module if_stage (
    input  wire        clk,
    input  wire        rst_n,

    // Load-stall control
    input  wire        pc_write,
    input  wire        if_id_write,

    // Branch flush control
    input  wire        if_id_flush,

    // Branch/JAL/JALR target from EX stage
    input  wire        ex_pc_src,
    input  wire [31:0] ex_pc_target,

    // Outputs to ID stage
    output reg  [31:0] if_id_pc,
    output reg  [31:0] if_id_pc4,
    output reg  [31:0] if_id_instr
);

    // Program Counter
    reg [31:0] pc;

    // Instruction fetched from IMEM
    wire [31:0] instr;

    // Next PC logic
    wire [31:0] pc_next;

    assign pc_next =
        ex_pc_src ? ex_pc_target :
                    (pc + 32'd4);

    //////////////////////////////////////////////////////
    // PC Register
    //////////////////////////////////////////////////////
    always @(posedge clk) begin
        if (!rst_n)
            pc <= 32'b0;

        else if (pc_write)
            pc <= pc_next;
    end

    //////////////////////////////////////////////////////
    // Instruction Memory
    //////////////////////////////////////////////////////
    imem IMEM (
        .clk(clk),
        .rst_n(rst_n),
        .address(pc),
        .read_data(instr)
    );

    //////////////////////////////////////////////////////
    // IF/ID Pipeline Register
    //////////////////////////////////////////////////////
    always @(posedge clk) begin

        // Reset
        if (!rst_n) begin
            if_id_pc    <= 32'b0;
            if_id_pc4   <= 32'b0;
            if_id_instr <= 32'b0;
        end

        // Branch/JAL/JALR Flush
        else if (if_id_flush) begin
            if_id_pc    <= 32'b0;
            if_id_pc4   <= 32'b0;
            if_id_instr <= 32'b0;   // NOP
        end

        // Normal pipeline update
        else if (if_id_write) begin
            if_id_pc    <= pc;
            if_id_pc4   <= pc + 32'd4;
            if_id_instr <= instr;
        end

        // Load-use stall
        else begin
            if_id_pc    <= if_id_pc;
            if_id_pc4   <= if_id_pc4;
            if_id_instr <= if_id_instr;
        end

    end

endmodule
