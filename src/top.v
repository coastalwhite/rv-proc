module top(
    input CLK,

    input BTN_N,
    
    output TX,
    input RX
);
    wire clk = CLK;
    wire rst = !BTN_N;


    wire [4:0] rs1_select;
    wire [4:0] rs2_select;
    wire [4:0] rd_select;

    wire [31:0] rs1;
    wire [31:0] rs2;
    wire [31:0] rd;

    wire [31:0] next_pc;
    wire [31:0] pc;

    wire [3:0] mem_bmask;

    wire [12:0] memaddr;
    wire [31:0] membus;

    wire rb_write_enable;
    wire mem_write_enable;

    exec_unit ex(
        .clk(clk),
        .rst(rst),

        .next_pc(next_pc),
        .pc(pc),

        .rs1_select(rs1_select),
        .rs2_select(rs2_select),
        .rs1(rs1),
        .rs2(rs2),

        .rd_select(rd_select),
        .rd(rd),

        .mem_bmask(mem_bmask),

        .rb_write_enable(rb_write_enable),
        .mem_write_enable(mem_write_enable)
    );

    register_bank rb(
        .clk(clk),
        .rst(rst),

        .next_pc(next_pc),
        .pc(pc),

        .rs1_select(rs1_select),
        .rs2_select(rs2_select),
        .rd_select(rd_select),

        .rs1(rs1),
        .rs2(rs2),
        .rd (rd),

        .write_enable(rb_write_enable)
    );

endmodule