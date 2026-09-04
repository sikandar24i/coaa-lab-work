module multiplexer_dFlow(S0,S1,S2,O, D0,D1,D2,D3,D4,D5,D6,D7);

input D0,D1,D2,D3,D4,D5,D6,D7,S0,S1,S2;
output O;
wire w0,w1,w2,w3,w4,w5,w6,w7;

assign w0 = D0&(~S0)&(~S1)&(~S2);
assign w1 = D1&(~S0)&(~S1)&(S2);
assign w2 = D2&(~S0)&(S1)&(~S2);
assign w3 = D3&(~S0)&(S1)&(S2);
assign w4 = D4&(S0)&(~S1)&(~S2);
assign w5 = D5&(S0)&(~S1)&(S2);
assign w6 = D6&(S0)&(S1)&(~S2);
assign w7 = D7&(S0)&(S1)&(S2);

assign O = w0 | w1 | w2 | w3 | w4 | w5 | w6 | w7;

endmodule

module T3_ii_testbench();

reg S0,S1,S2;
reg D0,D1,D2,D3,D4,D5,D6,D7;
wire O;
multiplexer_dFlow mux(S0,S1,S2,O, D0,D1,D2,D3,D4,D5,D6,D7);

initial
begin

D0 = 1;
D1 = 0;
D2 = 1;
D3 = 0;
D4 = 1;
D5 = 0;
D6 = 1;
D7 = 0;
//even = 1, odd = 0 for testing

S0=0; S1=0; S2=0;
#10 S0=0; S1=0; S2=1;
#10 S0=0; S1=1; S2=0;
#10 S0=0; S1=1; S2=1;
#10 S0=1; S1=0; S2=0;
#10 S0=1; S1=0; S2=1;
#10 S0=1; S1=1; S2=0;
#10 S0=1; S1=1; S2=1;
end
endmodule