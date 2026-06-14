module alu (
    input  [3:0] alu_control,
    input  [31:0] src1,
    input  [31:0] src2,
    // OUT
    output reg [31:0] alu_result,
    output  zero,
    output less_than,
    output less_than_u
);


always @(*) begin
    case (alu_control)
        //ADD Operation
        4'b0000: alu_result = src1 + src2; 
        // Bitwise and operation
        4'b0010 : alu_result = src1 & src2;
        //OR operation
        4'b0011 : alu_result = src1 | src2;
        //Sub operation -> beq
        4'b0001 : alu_result = src1 + (~src2 + 1'b1); //2s complement representation
        //slti operation
        4'b0101 : alu_result = {31'b0, $signed(src1) < $signed(src2)};
        //sltiu operation
        4'b0111 : alu_result = {31'b0, src1 < src2};
        //xori operation
        4'b1000 : alu_result = src1 ^ src2;
        //shift left logical -> shamt is 5 bits
        4'b1001: alu_result = src1 << src2[4:0];
        //shift right logical 
        4'b1010: alu_result = src1 >> src2[4:0];
        //shift right arithmetic with sign preserved
        4'b1011: alu_result = $signed(src1) >>> src2[4:0];
        default: alu_result = 32'b0;
    endcase
end

assign zero = (alu_result == 32'b0);
//For blt instruction
assign less_than = ($signed(src1) < $signed(src2));
//BLTU unsigned
assign less_than_u = (src1 < src2);
    
endmodule