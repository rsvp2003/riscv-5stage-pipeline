module reg_file (
    //clk 
    input clk,
    //writes
    input [4:0] address1,address2,
    output reg [31:0] read_data1,read_data2,
    //writes
    input write_enable,
    input [4:0] address3,
    input [31:0] write_data
);

reg [31:0] register [31:0];

//write operation

always @(posedge clk ) begin
    if (write_enable && address3 != 5'd0) begin  // If register is x0 , ignore the write
        register[address3] <= write_data;
    end
end

//read operation
//X0 register is  hardwired to 0
always @(*) begin
    read_data1 = (address1 == 5'd0) ? 32'b0 : register[address1];
    read_data2 = (address2 == 5'd0) ? 32'b0 : register[address2];
end
    
endmodule