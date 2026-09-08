module Adder_Subtractor(I0, I1, Signal, Output);

input [3:0] I0;
input [3:0] I1;
input Signal;
output reg [4:0] Output;

always @(*)
begin
if (Signal == 0)
Output = I0 + I1;
else
Output = I0 - I1;
ende

endmodule

module T1_testbench();

reg [3:0] I0;
reg [3:0] I1;
reg signal;
wire [4:0] op;

Adder_Subtractor myAddSub(I0, I1, signal, op);

initial
begin
    I0 = 0; I1 = 5; signal = 0;
#10 I0 = 2; I1 = 4; signal = 0;
#10 I0 = 9; I1 = 5; signal = 0;
#10 I0 = 2; I1 = 7; signal = 0;
#10 I0 = 7; I1 = 5; signal = 1;
#10 I0 = 15; I1 = 4; signal = 1;
#10 I0 = 14; I1 = 6; signal = 1;
#10 I0 = 8; I1 = 8; signal = 1;
end

endmodule