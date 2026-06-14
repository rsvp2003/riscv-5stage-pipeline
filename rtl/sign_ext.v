module sign_ext (
    input  [31:0] raw_src,
    input  [2:0] imm_source,
    // OUT (immediate)
    output  [31:0] immediate  
);

reg [31:0] gathered_imm; 

always @(*) begin
    case (imm_source)
        // I type -> lw
        3'b000 : gathered_imm = {{20{raw_src[31]}}, raw_src[31:20]};
        // S type -> sw
        3'b001 : gathered_imm = {{20{raw_src[31]}}, raw_src[31:25], raw_src[11:7]};
        //B type -> beq
        3'b010 : gathered_imm = {{20{raw_src[31]}}, raw_src[7], raw_src[30:25], raw_src[11:8], 1'b0};
        //J Type -> jal
        3'b011 : gathered_imm = {{12{raw_src[31]}}, raw_src[19:12], raw_src[20], raw_src[30:21], 1'b0};
        //U Type instruction
        3'b100 : gathered_imm = {raw_src[31:12],12'b000000000000};
        //Default case : all zeroes
        default : gathered_imm = 32'b0; 
    endcase
end

    

assign immediate = gathered_imm;

endmodule

