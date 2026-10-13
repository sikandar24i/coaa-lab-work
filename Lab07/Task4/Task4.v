module alu_32bit (
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_op,
    output reg [31:0] result,
    output zero
);

    always @(*) begin
        case (alu_op)
            4'b0000: result = a + b;                                  // ADD
            4'b0001: result = a - b;                                  // SUB
            4'b0010: result = a & b;                                  // AND
            4'b0011: result = a | b;                                  // OR
            4'b0100: result = a ^ b;                                  // XOR
            4'b0101: result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; // SLT
            4'b0110: result = (a < b) ? 32'd1 : 32'd0;                 // SLTU
            4'b0111: result = a << b[4:0];                             // SLL
            4'b1000: result = a >> b[4:0];                             // SRL
            4'b1001: result = $signed(a) >>> b[4:0];                   // SRA
            default: result = 32'd0;
        endcase
    end

    assign zero = (result == 32'd0);

endmodule

module ALU_32bit_tb;

    reg [31:0] A, B;
    reg [3:0] alu_op;
    wire [31:0] O;
    wire zero;

    alu_32bit myALU32(A, B, alu_op, O, zero);

    initial begin
             A = 32'd15; B = 32'd10; alu_op = 4'b0000; // 15 + 10 = 25
        #10; A = 32'd15; B = 32'd10; alu_op = 4'b0001; // 15 - 10 = 5
        #10; A = 32'hF0F0; B = 32'hFF00; alu_op = 4'b0010; // F0F0 & FF00 = F000
        #10; A = 32'hF0F0; B = 32'h0F0F; alu_op = 4'b0011; // F0F0 | 0F0F = FFFF
        #10; A = 32'hFFFF; B = 32'h0FF0; alu_op = 4'b0100; // FFFF ^ 0FF0 = F00F
        #10; A = -32'd5; B = 32'd3; alu_op = 4'b0101; // -5 < 3 -> 1
        #10; A = 32'd4; B = 32'd2; alu_op = 4'b0111; // 4 << 2 = 16
        #10; A = 32'd10; B = 32'd10; alu_op = 4'b0001; // 10 - 10 = 0 -> zero=1
    end

endmodule