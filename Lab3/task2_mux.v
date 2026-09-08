module _2to1Mux(I0, I1, S, O);
input I0;
input I1;
input S;
output reg O;

always @ (*)
begin
if (S == 0)
O = I0 & I1;
else
O = I0 | I1;
end

endmodule

module T2_testbench();

reg A;
reg B;
reg S;
wire Op;

_2to1Mux mux(A, B, S, Op);

initial
begin
    A = 0; B = 0; S = 0;
#10 A = 0; B = 0; S = 1;
#10 A = 0; B = 1; S = 0;
#10 A = 0; B = 1; S = 1;
#10 A = 1; B = 0; S = 0;
#10 A = 1; B = 0; S = 1;
#10 A = 1; B = 1; S = 0;
#10 A = 1; B = 1; S = 1;
end

endmodule