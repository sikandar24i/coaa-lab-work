module myAND(
    output O,
    input A, B, C, D
);
    wire t0, t1;
    and(t0, A, B);
    and(t1, C, D);
    and(O, t0, t1);
endmodule

module Multiplexer_GLevel(
    output O,
    input S0, S1, I0, I1, I2, I3
);
    wire SN0, SN1;
    not(SN0, S0);
    not(SN1, S1);

    wire t0, t1, t2, t3;

    myAND A1(t0, I0, SN0, SN1, 1);
    myAND A2(t1, I1, SN0, S1, 1);
    myAND A3(t2, I2, S0, SN1, 1);
    myAND A4(t3, I3, S0, S1, 1);

    wire to0, to1;
    or(to0, t0, t1);
    or(to1, to0, t2);
    or(O, t3, to1);
endmodule

module HalfAdder_GLevel(Sum, Carry, A, B);
    input A, B;
    output Sum, Carry;

    xor sum(Sum, A, B);
    and carry(Carry, A, B);
endmodule

module FullAdder_GLevel(Sum, Carry, A, B, Cin);
    input A, B, Cin;
    output Sum, Carry;
    wire s1, c1, c2;

    HalfAdder_GLevel ha1(s1, c1, A, B);
    HalfAdder_GLevel ha2(Sum, c2, s1, Cin);
    or carry(Carry, c1, c2);
endmodule

// ----------- 1-BIT ALU MODULE ------------------
module ALU_1bit_GLevel(A, B, carry_in, result, carry_out, S0, S1, b_inv, less);
    input A, B, S0, S1, b_inv, carry_in, less;
    output result, carry_out;

    wire b_final;
    wire fa_sum;
    wire fa_carry;
    wire And;
    wire Or;

    xor (b_final, B, b_inv);
    FullAdder_GLevel fa1(fa_sum, fa_carry, A, b_final, carry_in);

    and a(And, A, B);
    or o(Or, A, B);

    // Multiplexer selects:
    // 00: AND, 01: OR, 10: ADD/SUB, 11: SLT
    Multiplexer_GLevel mux(result, S0, S1, And, Or, fa_sum, less); 
    assign carry_out = fa_carry;
endmodule

// ----------- 4-BIT ALU MODULE ------------------
module ALU_4bit_GLevel(
    input [3:0] A,
    input [3:0] B,
    input S0, S1, b_inv, carry_in,
    output [3:0] result,
    output carry_out,
    output cf, sf, zf, of
);
    wire [4:0] c;
    wire [3:0] fa_results;
    wire slt_val;

    assign c[0] = carry_in | b_inv;
    assign slt_val = sf ^ of;

    ALU_1bit_GLevel alu0(A[0], B[0], c[0], result[0], c[1], S0, S1, b_inv, slt_val);
    ALU_1bit_GLevel alu1(A[1], B[1], c[1], result[1], c[2], S0, S1, b_inv, 1'b0);
    ALU_1bit_GLevel alu2(A[2], B[2], c[2], result[2], c[3], S0, S1, b_inv, 1'b0);
    ALU_1bit_GLevel alu3(A[3], B[3], c[3], result[3], c[4], S0, S1, b_inv, 1'b0);

    assign carry_out = c[4];

    assign cf = c[4] & (S0); // Carry Flag active during arithmetic
    assign sf = result[3]; // Sign Flag (MSB of result)
    assign zf = ~(|result); // Zero Flag (1 if all bits are 0)
    assign of = c[4] ^ c[3]; // Overflow Flag (C4 ^ C3)

endmodule

// ----------- TESTBENCH ------------------
module ALU_4bit_tb;

    reg [3:0] A, B;
    reg S0, S1, b_inv, carry_in;
    wire [3:0] O;
    wire Cout, CF, SF, ZF, OF;

    ALU_4bit_GLevel myALU4(A, B, S0, S1, b_inv, carry_in, O, Cout, CF, SF, ZF, OF);

    initial begin
             A = 4'b1100; B = 4'b1010; S0 = 0; S1 = 0; b_inv = 0; carry_in = 0; //1100 & 1010 = 1000
        #10; A = 4'b1100; B = 4'b1010; S0 = 1; S1 = 0; b_inv = 0; carry_in = 0; //1100 | 1010 = 1110
        #10; A = 4'b0010; B = 4'b0011; S0 = 0; S1 = 1; b_inv = 0; carry_in = 0; //0010 + 0011 = 0101
        #10; A = 4'b0101; B = 4'b0010; S0 = 0; S1 = 1; b_inv = 1; carry_in = 1; //0101 - 0010 = 0011
        #10; A = 4'b0010; B = 4'b0101; S0 = 1; S1 = 1; b_inv = 1; carry_in = 1; //0010 < 0101 -> true, so result = 0001
        #10; A = 4'b0011; B = 4'b0011; S0 = 0; S1 = 1; b_inv = 1; carry_in = 1; //0011 - 0011 = 0000 -> ZF=1
    end

endmodule