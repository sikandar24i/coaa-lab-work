module Parameterized_ALU #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    input [2:0] op,
    output reg [N-1:0] O,
    output reg Cout,
    output reg ZF,
    output reg SF,
    output reg OF
);

    always @(*) begin
        Cout = 0;
        OF = 0;
        case(op)
            3'b000: {Cout, O} = A + B;
            3'b001: {Cout, O} = A - B;
            3'b010: O = A & B;
            3'b011: O = A | B;
            3'b100: O = ~A;
            3'b101: O = A ^ B;
            default: O = 0;
        endcase
        ZF = (O == 0);
        SF = O[N-1];
        if (op == 3'b000)
            OF = (A[N-1] == B[N-1]) && (O[N-1] != A[N-1]);
        else if (op == 3'b001)
            OF = (A[N-1] != B[N-1]) && (O[N-1] != A[N-1]);
    end

endmodule

module ALU_4bit_tb;

    reg [3:0] A, B;
    reg [2:0] op;
    wire [3:0] O;
    wire Cout, ZF, SF, OF;

    Parameterized_ALU #(4) myALU4(A, B, op, O, Cout, ZF, SF, OF);

    initial begin
             A = 4'b1100; B = 4'b1010; op = 3'b010; // 1100 & 1010 = 1000
        #10; A = 4'b1100; B = 4'b1010; op = 3'b011; // 1100 | 1010 = 1110
        #10; A = 4'b1100; B = 4'b1010; op = 3'b100; // ~1100 = 0011
        #10; A = 4'b1100; B = 4'b1010; op = 3'b101; // 1100 ^ 1010 = 0110
        #10; A = 4'b0010; B = 4'b0011; op = 3'b000; // 0010 + 0011 = 0101
        #10; A = 4'b0101; B = 4'b0010; op = 3'b001; // 0101 - 0010 = 0011
    end

endmodule