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
or(O, t3, to1); //or'ed 3 inputs using 3 2-input modules

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

// -----------MAIN MODULE------------------
module ALU_GLevel(A, B, carry_in, result, carry_out, S0, S1, b_inv);

input A, B, S0, S1, b_inv, carry_in;
output result, carry_out;

wire b_final;
wire fa_sum;
wire fa_carry;
wire And;
wire Or;

xor (b_final, B, b_inv); //b final will be used in the circuit

FullAdder_GLevel fa1(fa_sum, fa_carry, A, b_final, carry_in);

and a(And, A, B);
or o(Or, A, B);

/*
S0 S1
0  0 - AND
0  1 - OR
1  0 - ADD/SUB
1  1 - ADD/SUB
*/

Multiplexer_GLevel mux(result, S0, S1, And, Or, fa_sum, fa_sum); 
assign carry_out = fa_carry;

endmodule


module _1bitALU_tb;

reg A, B, Cin;
reg b_inv;
reg S0, S1;
wire O, Cout;

ALU_GLevel myALU(A, B, Cin, O, Cout, S0, S1, b_inv);

initial
begin
         A = 0; B = 0; Cin = 0; b_inv = 0; S0 = 0; S1 = 0; //0 AND 0 = 0
    #10; A = 1; B = 1; S0 = 0; S1 = 0; b_inv = 0; //1 AND 1 = 1
    #10; A = 0; B = 1; S0 = 0; S1 = 1; b_inv = 0; //0 OR 1 = 1
    #10; A = 1; B = 1; S0 = 0; S1 = 1; b_inv = 0; //1 OR 1 = 1
    #10; A = 1; B = 1; Cin = 0; S0 = 1; S1 = 0; b_inv = 0; //1 + 1 = 10
    #10; A = 1; B = 1; Cin = 1; S0 = 1; S1 = 0; b_inv = 0; //1 + 1 + 1 = 11
    #10; A = 1; B = 0; Cin = 1; S0 = 1; S1 = 0; b_inv = 1; //1 - 0 + 1 = 1 + 1 + 1 = 11
    #10; A = 0; B = 1; Cin = 1; S0 = 1; S1 = 1; b_inv = 1; //0 - 1 + 1 = 0 + 1 + 1 = 10
end

endmodule
