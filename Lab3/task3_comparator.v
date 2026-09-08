module comparator(I0, I1, eq, gr, ls);

input [1:0] I0;
input [1:0] I1;
output reg eq;
output reg gr;
output reg ls;

always @ *
begin
if (I0 > I1)
begin
eq = 0;
gr = 1;
ls = 0;
end
else if (I0 == I1)
begin
eq = 1;
gr = 0;
ls = 0;
end
else
begin
eq = 0;
gr = 0;
ls = 1;
end

end

endmodule

module T3_testbench();

reg [1:0] A;
reg [1:0] B;
wire eq, gr, ls;

comparator comp(A, B, eq, gr, ls);

initial
begin
    A = 0; B = 0;
#10 A = 1; B = 0;
#10 A = 2; B = 3;
end

endmodule