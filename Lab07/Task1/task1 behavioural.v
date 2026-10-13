module myAND(
    output reg O,
    input A, B, C, D
);

always @(*) begin
    O = A & B & C & D;
end

endmodule

module Multiplexer_Behavioral(
    output reg O,
    input S0, S1, I0, I1, I2, I3
);

always @(*) begin
    case ({S1, S0})
        2'b00: O = I0;
        2'b01: O = I1;
        2'b10: O = I2;
        2'b11: O = I3;
        default: O = 1'b0;
    endcase
end

endmodule

module HalfAdder_Behavioral(Sum, Carry, A, B);

input A, B;
output reg Sum, Carry;

always @(*) begin
    Sum = A ^ B;
    Carry = A & B;
end

endmodule

module FullAdder_Behavioral(Sum, Carry, A, B, Cin);

input A, B, Cin;
output reg Sum, Carry;

always @(*) begin
    {Carry, Sum} = A + B + Cin;
end

endmodule

// -----------MAIN MODULE------------------
module ALU_Behavioral(A, B, carry_in, result, carry_out, S0, S1, b_inv);

input A, B, S0, S1, b_inv, carry_in;
output reg result, carry_out;

reg b_final;
reg fa_sum;
reg fa_carry;
reg And;
reg Or;

always @(*) begin
    b_final = B ^ b_inv;
    {fa_carry, fa_sum} = A + b_final + carry_in;
    And = A & B;
    Or = A | B;
    
    case ({S1, S0})
        2'b00: result = And;
        2'b01: result = Or;
        2'b10: result = fa_sum;
        2'b11: result = fa_sum;
        default: result = 1'b0;
    endcase
    
    carry_out = fa_carry;
end

endmodule

module _1bitALU_tb;

reg A, B, Cin;
reg b_inv;
reg S0, S1;
wire O, Cout;

ALU_Behavioral myALU(A, B, Cin, O, Cout, S0, S1, b_inv);

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