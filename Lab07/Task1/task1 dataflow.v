module myAND(
    output O,
    input A, B, C, D
);

assign O = A & B & C & D;

endmodule

module Multiplexer_Dataflow(
    output O,
    input S0, S1, I0, I1, I2, I3
);

assign O = (~S1 & ~S0 & I0) | (~S1 & S0 & I1) | (S1 & ~S0 & I2) | (S1 & S0 & I3);

endmodule

module HalfAdder_Dataflow(Sum, Carry, A, B);

input A, B;
output Sum, Carry;

assign Sum = A ^ B;
assign Carry = A & B;

endmodule

module FullAdder_Dataflow(Sum, Carry, A, B, Cin);

input A, B, Cin;
output Sum, Carry;

assign Sum = A ^ B ^ Cin;
assign Carry = (A & B) | (B & Cin) | (A & Cin);

endmodule

// -----------MAIN MODULE------------------
module ALU_Dataflow(A, B, carry_in, result, carry_out, S0, S1, b_inv);

input A, B, S0, S1, b_inv, carry_in;
output result, carry_out;

wire b_final;
wire fa_sum;
wire fa_carry;
wire And;
wire Or;

assign b_final = B ^ b_inv;
assign {fa_carry, fa_sum} = A + b_final + carry_in;
assign And = A & B;
assign Or = A | B;
assign result = ({S1, S0} == 2'b00) ? And : ({S1, S0} == 2'b01) ? Or : fa_sum;
assign carry_out = fa_carry;

endmodule

module _1bitALU_tb;

reg A, B, Cin;
reg b_inv;
reg S0, S1;
wire O, Cout;

ALU_Dataflow myALU(A, B, Cin, O, Cout, S0, S1, b_inv);

initial
begin
         A = 0; B = 0; Cin = 0; b_inv = 0; S0 = 0; S1 = 0; 
    #10; A = 1; B = 1; S0 = 0; S1 = 0; b_inv = 0; 
    #10; A = 0; B = 1; S0 = 0; S1 = 1; b_inv = 0; 
    #10; A = 1; B = 1; S0 = 0; S1 = 1; b_inv = 0; 
    #10; A = 1; B = 1; Cin = 0; S0 = 1; S1 = 0; b_inv = 0; 
    #10; A = 1; B = 1; Cin = 1; S0 = 1; S1 = 0; b_inv = 0; 
    #10; A = 1; B = 0; Cin = 1; S0 = 1; S1 = 0; b_inv = 1; 
    #10; A = 0; B = 1; Cin = 1; S0 = 1; S1 = 1; b_inv = 1; 
end

endmodule