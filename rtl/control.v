module control (
    input  [6:0] op,
    input  [2:0] func3,
    input  [6:0] func7,

    //OUT
    output reg [3:0] alu_control,
    output reg [2:0] imm_source,
    output reg mem_write,
    output reg  reg_write,
    //added for R type instruction
    output reg alu_source,
    output reg [1:0] write_back_source,
    //for U type 
    output reg second_add_source,
    output reg branch,
    output reg jump,
    output reg jalr
);


/////////////////////////////////
///Main decoder to compute alu_op///
////////////////////////////////////

reg [1:0] alu_op;


always @(*) begin

    // defaults values
    reg_write         = 1'b0;
    imm_source        = 3'b000;
    mem_write         = 1'b0;
    alu_op            = 2'b00;
    alu_source        = 1'b0;
    write_back_source = 2'b00;
    second_add_source = 1'b0;
    branch            = 1'b0;
    jump              = 1'b0;
    jalr              = 1'b0;

    case (op)

    //LW , I type
        7'b0000011 : begin
            reg_write = 1'b1;
            imm_source = 3'b000;
            mem_write = 1'b0;
            alu_op = 2'b00;
            alu_source = 1'b1;
            write_back_source = 2'b01; 
            branch = 1'b0;
            jump = 1'b0;
        end
    //SW , S type
        7'b0100011 : begin
            reg_write = 1'b0;
            imm_source = 3'b001;
            mem_write = 1'b1;
            alu_op = 2'b00;
            alu_source = 1'b1;
            branch = 1'b0;
            jump = 1'b0;
        end

    //R Type -> add , or , and
        7'b0110011 : begin
            reg_write = 1'b1;
            mem_write = 1'b0;
            alu_op = 2'b10;
            alu_source = 1'b0; //take reg2 instead of immediate
            write_back_source = 2'b00; // take the alu_result instead of memory value
            branch = 1'b0;
            jump = 1'b0;
        end

    //B Type -> beq
        7'b1100011 : begin
            reg_write = 1'b0;
            imm_source = 3'b010;
            alu_source = 1'b0;
            mem_write = 1'b0;
            alu_op = 2'b01;
            branch = 1'b1;
            jump = 1'b0;
            //modified while adding u type
            second_add_source = 1'b0;
        end

    //J Type -> jal
        7'b1101111 : begin
            reg_write = 1'b1;
            imm_source = 3'b011;
            mem_write = 1'b0;
            write_back_source = 2'b10; //store pc = pc+4 into a destination register
            branch = 1'b0;
            jump = 1'b1;
            //modifed while adding u type
            second_add_source = 1'b0;
        end

    //I type - ALU instructions : addi
        7'b0010011 : begin
            reg_write = 1'b1;
            imm_source = 3'b000;
            alu_source = 1'b1; // select immediate as src2 of ALU
            mem_write = 1'b0;
            alu_op = 2'b10; //R type instr
            write_back_source = 2'b00; //write back the ALU Result to the dest reg
            branch = 1'b0;
            jump = 1'b0;
        end

    // U Type instructions : lui and auipc
        7'b0110111, 7'b0010111 : begin
            imm_source = 3'b100;
            mem_write = 1'b0;
            reg_write = 1'b1;
            write_back_source = 2'b00;
            branch = 1'b0;
            jump = 1'b0;
            alu_source = 1'b1;
            alu_op = 2'b00;
            if (op == 7'b0110111)
                second_add_source = 1'b1; // LUI → immediate only
            else
                second_add_source = 1'b0; // AUIPC → PC + immediate
        end

    //JALR 

        7'b1100111 : begin
            reg_write = 1'b1;
            imm_source = 3'b000;        // I-type immediate
            mem_write = 1'b0;
            write_back_source = 2'b10;  // rd = PC + 4
            branch = 1'b0;
            jump   = 1'b0;
            // JALR signal is 1
            jalr = 1'b1;
            alu_op = 2'b00;
            alu_source = 1'b1;
            second_add_source = 1'b0;
        end

        default: begin
            reg_write = 1'b0;
            imm_source = 3'b000;
            mem_write = 1'b0;
            alu_op = 2'b00;
            alu_source = 1'b0;
            branch = 1'b0;
            jump = 1'b0;
        end
    endcase
end

////////////////////////////////////
//ALU DECODER to compute alu_control
////////////////////////////////////

always @(*) begin
    case (alu_op)
    //LW and SW , ALU has to add
        2'b00 : alu_control = 4'b0000;
    //R Type instruction , ALU Operation is dependent on func3, func7
        2'b10 : begin
            case (func3)
                // ADD and SUB have same funct3 but diff is at funct7
                3'b000 : begin
                    if ((op == 7'b0110011) && (func7 == 7'b0100000))
                        alu_control = 4'b0001;   // SUB
                    else
                        alu_control = 4'b0000;   // ADD and ADDI
                end
                //AND
                3'b111 : alu_control = 4'b0010;
                //OR instruction
                3'b110 : alu_control = 4'b0011;
                //SLTI instruction
                3'b010 : alu_control = 4'b0101;
                //SLTU Instruction
                3'b011 : alu_control = 4'b0111;
                //xor
                3'b100 : alu_control = 4'b1000;
                //SLLI instruction
                3'b001 : alu_control = 4'b1001;

                //SRLI / SRAI (and SRL / SRA) have same funct3 they are difference by funct7
                3'b101 : begin
                    if (func7 == 7'b0100000)
                        alu_control = 4'b1011;  // SRAI (arithmetic shift right)
                    else
                        alu_control = 4'b1010;  // SRLI (logical shift right)
                    end
                // ALL THE OTHERS
                default: alu_control = 4'b0000;
            endcase
        end
    //REST OF THE INSTRUCTIONS
    //B type -> beq
        //ALU Has to sub to compare reg1 , reg2
        2'b01 : begin
            //Based on func3 we can differentiate Branch instructions
            case (func3)
                3'b000 : alu_control = 4'b0001;  // BEQ
                3'b001 : alu_control = 4'b0001;  // BNE
                3'b100 : alu_control = 4'b0101;  // BLT
                3'b101 : alu_control = 4'b0101;  // BGE
                3'b110 : alu_control = 4'b0111;  // BLTU
                3'b111 : alu_control = 4'b0111;  // BGEU
                default: alu_control = 4'b0001;
            endcase
        end

        default: alu_control = 4'b0111;
    endcase
end




endmodule