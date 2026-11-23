module control_unit (
    input  wire [31:0] i_inst,
    input  wire        i_br_eq,
    input  wire        i_br_lt,
    output reg         o_pc_sel,
    output reg  [2:0]  o_imm_sel,
    output reg         o_reg_wen,
    output reg         o_br_un,
    output reg         o_b_sel,
    output reg         o_a_sel,
    output reg  [3:0]  o_alu_sel,
    output reg         o_mem_rw,
    output reg  [1:0]  o_wb_sel
);

    localparam OP_R     = 7'b0110011,
               OP_I     = 7'b0010011,
               OP_LOAD  = 7'b0000011,
               OP_STORE = 7'b0100011,
               OP_BR    = 7'b1100011,
               OP_JAL   = 7'b1101111,
               OP_JALR  = 7'b1100111,
               OP_LUI   = 7'b0110111,
               OP_AUIPC = 7'b0010111;

    localparam ALU_ADD  = 4'b0000,
               ALU_SUB  = 4'b0001,
               ALU_AND  = 4'b0010,
               ALU_OR   = 4'b0011,
               ALU_XOR  = 4'b0100,
               ALU_SLL  = 4'b0101,
               ALU_SRL  = 4'b0110,
               ALU_SRA  = 4'b0111,
               ALU_SLT  = 4'b1000,
               ALU_SLTU = 4'b1001,
               ALU_BSEL = 4'b1010;

    wire [6:0] opcode   = i_inst[6:0];
    wire [2:0] funct3   = i_inst[14:12];
    wire       funct7_5 = i_inst[30];
    wire       is_r     = (opcode == OP_R);

    reg       take_branch;
    reg [3:0] alu_fun;

    always @(*) begin
        case (funct3)
            3'b000:  take_branch =  i_br_eq;
            3'b001:  take_branch = ~i_br_eq;
            3'b100:  take_branch =  i_br_lt;
            3'b101:  take_branch = ~i_br_lt;
            3'b110:  take_branch =  i_br_lt;
            3'b111:  take_branch = ~i_br_lt;
            default: take_branch = 1'b0;
        endcase
    end

    always @(*) begin
        case (funct3)
            3'b000:  alu_fun = (is_r && funct7_5) ? ALU_SUB : ALU_ADD;
            3'b001:  alu_fun = ALU_SLL;
            3'b010:  alu_fun = ALU_SLT;
            3'b011:  alu_fun = ALU_SLTU;
            3'b100:  alu_fun = ALU_XOR;
            3'b101:  alu_fun = funct7_5 ? ALU_SRA : ALU_SRL;
            3'b110:  alu_fun = ALU_OR;
            3'b111:  alu_fun = ALU_AND;
            default: alu_fun = ALU_ADD;
        endcase
    end

    always @(*) begin
        o_pc_sel  = 1'b0;
        o_imm_sel = 3'b000;
        o_reg_wen = 1'b0;
        o_br_un   = 1'b0;
        o_b_sel   = 1'b0;
        o_a_sel   = 1'b0;
        o_alu_sel = ALU_ADD;
        o_mem_rw  = 1'b0;
        o_wb_sel  = 2'b01;

        case (opcode)
            OP_R: begin
                o_reg_wen = 1'b1;
                o_alu_sel = alu_fun;
                o_wb_sel  = 2'b01;
            end
            OP_I: begin
                o_imm_sel = 3'b000;
                o_reg_wen = 1'b1;
                o_b_sel   = 1'b1;
                o_alu_sel = alu_fun;
                o_wb_sel  = 2'b01;
            end
            OP_LOAD: begin
                o_imm_sel = 3'b000;
                o_reg_wen = 1'b1;
                o_b_sel   = 1'b1;
                o_alu_sel = ALU_ADD;
                o_wb_sel  = 2'b00;
            end
            OP_STORE: begin
                o_imm_sel = 3'b001;
                o_b_sel   = 1'b1;
                o_alu_sel = ALU_ADD;
                o_mem_rw  = 1'b1;
            end
            OP_BR: begin
                o_imm_sel = 3'b010;
                o_br_un   = funct3[1];
                o_a_sel   = 1'b1;
                o_b_sel   = 1'b1;
                o_alu_sel = ALU_ADD;
                o_pc_sel  = take_branch;
            end
            OP_JAL: begin
                o_imm_sel = 3'b100;
                o_reg_wen = 1'b1;
                o_a_sel   = 1'b1;
                o_b_sel   = 1'b1;
                o_alu_sel = ALU_ADD;
                o_wb_sel  = 2'b10;
                o_pc_sel  = 1'b1;
            end
            OP_JALR: begin
                o_imm_sel = 3'b000;
                o_reg_wen = 1'b1;
                o_b_sel   = 1'b1;
                o_alu_sel = ALU_ADD;
                o_wb_sel  = 2'b10;
                o_pc_sel  = 1'b1;
            end
            OP_LUI: begin
                o_imm_sel = 3'b011;
                o_reg_wen = 1'b1;
                o_b_sel   = 1'b1;
                o_alu_sel = ALU_BSEL;
                o_wb_sel  = 2'b01;
            end
            OP_AUIPC: begin
                o_imm_sel = 3'b011;
                o_reg_wen = 1'b1;
                o_a_sel   = 1'b1;
                o_b_sel   = 1'b1;
                o_alu_sel = ALU_ADD;
                o_wb_sel  = 2'b01;
            end
            default: begin
            end
        endcase
    end

endmodule

module control_unit_tb;

    reg  [31:0] i_inst;
    reg         i_br_eq;
    reg         i_br_lt;
    wire        o_pc_sel;
    wire [2:0]  o_imm_sel;
    wire        o_reg_wen;
    wire        o_br_un;
    wire        o_b_sel;
    wire        o_a_sel;
    wire [3:0]  o_alu_sel;
    wire        o_mem_rw;
    wire [1:0]  o_wb_sel;

    control_unit uut (
        .i_inst    (i_inst),
        .i_br_eq   (i_br_eq),
        .i_br_lt   (i_br_lt),
        .o_pc_sel  (o_pc_sel),
        .o_imm_sel (o_imm_sel),
        .o_reg_wen (o_reg_wen),
        .o_br_un   (o_br_un),
        .o_b_sel   (o_b_sel),
        .o_a_sel   (o_a_sel),
        .o_alu_sel (o_alu_sel),
        .o_mem_rw  (o_mem_rw),
        .o_wb_sel  (o_wb_sel)
    );

    initial begin
        i_br_eq = 0;
        i_br_lt = 0;
        i_inst  = 32'h003100B3;
        #10;

        i_inst = 32'h403100B3;
        #10;

        i_inst = 32'h00514093;
        #10;

        i_inst = 32'h40515093;
        #10;

        i_inst = 32'h00512083;
        #10;

        i_inst = 32'h00112223;
        #10;

        i_br_eq = 1;
        i_inst  = 32'h00208463;
        #10;

        i_br_eq = 0;
        #10;

        i_br_lt = 1;
        i_inst  = 32'h0020C463;
        #10;

        i_inst = 32'h0020E463;
        #10;

        i_inst = 32'h004000EF;
        #10;

        i_inst = 32'h004100E7;
        #10;

        i_inst = 32'h123450B7;
        #10;

        i_inst = 32'h00001097;
        #10;
    end

endmodule