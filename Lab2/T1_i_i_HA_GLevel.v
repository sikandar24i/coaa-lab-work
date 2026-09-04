module HalfAdder_GLevel(Sum, Carry, A, B);

input A, B;
output Sum, Carry;

xor sum(Sum, A, B);
and carry(Carry, A, B);

endmodule

module T1_i_i_testbench();

reg A, B;
wire Sum, Carry;

HalfAdder_GLevel HA(Sum, Carry, A, B);

initial

begin
    A = 0; B = 0;
#10 A = 0; B = 1;
#10 A = 1; B = 0;
#10 A = 1; B = 1;
end

endmodule