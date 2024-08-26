module register_bank(
    input clk,
    input rst,

    input [4:0] rs1_select,
    input [4:0] rs2_select,
    input [4:0] rd_select,

    output [31:0] rs1,
    output [31:0] rs2,
    input [31:0] rd,

    input [31:0] next_pc,
    output reg [31:0] pc,

    input write_enable);
    
    reg [31:0] bank[0:30];

    assign rs1 = rs1_select == 0 ? 32'h0000_0000 : bank[rs1_select - 1];
    assign rs2 = rs2_select == 0 ? 32'h0000_0000 : bank[rs2_select - 1];

    integer i;
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < 31; i += 1) bank[i] = 0;
            pc = 0;
        end
        else begin
            if (write_enable && rd_select != 0) bank[rd_select - 1] = rd;
            pc = next_pc;
        end
    end
endmodule
