module load_stall (
    input  wire [4:0] if_id_rs1,
    input  wire [4:0] if_id_rs2,

    input  wire [4:0] id_ex_rd,
    input  wire       id_ex_mem_read,

    output reg        pc_write,
    output reg        if_id_write,
    output reg        control_mux_sel
);

always @(*) begin
    // Default: normal pipeline operation
    pc_write        = 1'b1;
    if_id_write     = 1'b1;
    control_mux_sel = 1'b0;

    // Load-use hazard detection
    if (id_ex_mem_read &&
        (id_ex_rd != 5'b00000) &&
        ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2))) begin

        pc_write        = 1'b0;
        if_id_write     = 1'b0;
        control_mux_sel = 1'b1;
    end
end

endmodule
