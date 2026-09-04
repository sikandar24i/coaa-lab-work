module FullAdder_dFlow(Sum, Carry, A, B, Cin);

input A, B, Cin;
output Sum, Carry;

assign Sum = A ^ B ^ Cin;
assign Carry = ((A ^ B) & Cin) | (A & B);

endmodule

module T1_ii_ii_testbench();

reg A, B, C;
wire Sum, Carry;

FullAdder_dFlow FA(Sum, Carry, A, B, C);

initial
begin
    A = 0; B = 0; C = 0;
#10 A = 0; B = 0; C = 1;
#10 A = 0; B = 1; C = 0;
#10 A = 0; B = 1; C = 1;
#10 A = 1; B = 0; C = 0;
#10 A = 1; B = 0; C = 1;
#10 A = 1; B = 1; C = 0;
#10 A = 1; B = 1; C = 1;
end

endmodule