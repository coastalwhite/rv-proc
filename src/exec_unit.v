module exec_unit(
    input clk,
    input rst,

    output reg [31:0] next_pc,
    input [31:0] pc,

    output [4:0] rs1_select,
    output [4:0] rs2_select,
    input [31:0] rs1,
    input [31:0] rs2,

    output [4:0] rd_select,
    output [31:0] rd,

    output [3:0] mem_bmask,

    output rb_write_enable,
    output mem_write_enable);

    assign rd = rs1 + rs2;

    assign mem_bmask = 0;

    assign mem_write_enable = 0;
    assign rb_write_enable = 0;

    reg [2:0]  state;
    reg [1:0]  err;
    reg [31:0] instr;

    localparam [1:0]
        NONE           = 2'b00,
        UNIMPLEMENTED  = 2'b01,
        INVALID_OP     = 2'b11;

    localparam [2:0]
        READ_INSTR     = 3'b000,
        CALC_RESULT    = 3'b001,
        WRITE_BACK     = 3'b010;

    always @ (posedge clk) begin
        rs1_select = 0;
        rs2_select = 0;
        rd_select = 0;

        if (rst) next_pc = 0;
        else next_pc = pc + 4;
    end

    always @ (posedge clk) begin
        if (rst) begin
            next_pc = 0;
            err = NONE;
            instr = 0;
            state = READ_INSTR;
        end
        else begin
            case (state)
                READ_INSTR: begin
                    instr = membus;
                    state = CALC_RESULT;
                end

                CALC_RESULT: begin
                    rb_write_enable = 1;
                end
            endcase
        end
    end

    always @ (instr) begin
        // @TODO: This should not be zeroed by default.
        rs1_select = 5'b00000;
        rs2_select = 5'b00000;
        rd_select  = 5'b00000;
        rd         = 32'h0000_0000;

        if (instr[1:0] == 2'b11) begin
            case (instr[4:2])
                3'b000: case (instr[6:5])
                    // LOAD
                    2'b00: begin
                        err = UNIMPLEMENTED;
                    end

                    // STORE
                    2'b01: begin
                        err = UNIMPLEMENTED;
                    end

                    // MADD
                    2'b10: err = INVALID_OP;

                    // BRANCH
                    2'b11: begin
                        err = UNIMPLEMENTED;
                    end
                endcase

                3'b001: case (instr[6:5])
                    // LOAD-FP
                    2'b00: err = INVALID_OP;

                    // STORE-FP
                    2'b01: err = INVALID_OP;

                    // MSUB
                    2'b10: err = INVALID_OP;

                    // JALR
                    2'b11: begin
                        err = UNIMPLEMENTED;
                    end
                endcase

                3'b010: case (instr[6:5])
                    // custom-0
                    2'b00: err = INVALID_OP;

                    // custom-1
                    2'b01: err = INVALID_OP;

                    // NMSUB
                    2'b10: err = INVALID_OP;

                    // reserved
                    2'b11: err = INVALID_OP;
                endcase

                3'b011: case (instr[6:5])
                    // MISC-MEM
                    2'b00: err = INVALID_OP;

                    // AMO
                    2'b01: err = INVALID_OP;

                    // NMADD
                    2'b10: err = INVALID_OP;

                    // JAL
                    2'b11: begin
                        err = UNIMPLEMENTED;
                    end
                endcase

                3'b100: case (instr[6:5])
                    // OP-IMM
                    2'b00: case (instr[12:14])
                        // ADDI
                        3'b000: err = UNIMPLEMENTED;

                        // SLTI
                        3'b010: err = UNIMPLEMENTED;

                        // SLTIU
                        3'b011: err = UNIMPLEMENTED;

                        // XORI
                        3'b100: err = UNIMPLEMENTED;

                        // ORI
                        3'b110: err = UNIMPLEMENTED;

                        // ANDI
                        3'b111: err = UNIMPLEMENTED;

                        // SLLI (TODO: verify upper bits)
                        3'b001: err = UNIMPLEMENTED;

                        // SRLI / SRAI (TODO: verify upper bits)
                        3'b101: err = UNIMPLEMENTED;
                    endcase

                    // OP
                    2'b01: case (instr[12:14]) // TODO: verify upper bits
                        // ADD / SUB
                        3'b000: err = UNIMPLEMENTED;

                        // SLL
                        3'b001: err = UNIMPLEMENTED;

                        // SLT
                        3'b010: err = UNIMPLEMENTED;

                        // SLTU
                        3'b011: err = UNIMPLEMENTED;

                        // XOR
                        3'b100: err = UNIMPLEMENTED;

                        // SRL / SRA
                        3'b101: err = UNIMPLEMENTED;

                        // OR
                        3'b110: err = UNIMPLEMENTED;

                        // AND
                        3'b111: err = UNIMPLEMENTED;
                    endcase

                    // OP-FP
                    2'b10: err = INVALID_OP;

                    // SYSTEM
                    2'b11: err = INVALID_OP;
                endcase

                3'b101: case (instr[6:5])
                    // AUIPC
                    2'b00: begin
                        rd = { instr[31:12], 12'h000 } + pc;
                        rd_select = instr[11:7];
                    end

                    // LUI
                    2'b01: begin
                        imm = { instr[31:12], 12'h000 };
                        rd_select = instr[11:7];
                    end

                    // reserved
                    2'b10: err = INVALID_OP;

                    // reserved
                    2'b11: err = INVALID_OP;
                endcase

                3'b110: case (instr[6:5])
                    // OP-IMM-32
                    2'b00: begin
                        err = UNIMPLEMENTED;
                    end

                    // OP-32
                    2'b01: begin
                        err = UNIMPLEMENTED;
                    end

                    // custom-2 / rv128
                    2'b10: err = INVALID_OP;

                    // custom-3 / rv128
                    2'b11: err = INVALID_OP;
                endcase

                3'b111: err = INVALID_OP;
            endcase
        end
    end

    
endmodule
