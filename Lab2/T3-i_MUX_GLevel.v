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
    input S0, S1, S2, I0, I1, I2, I3, I4, I5, I6, I7
);

wire SN0, SN1, SN2;
not(SN0, S0);
not(SN1, S1);
not(SN2, S2);

wire t0, t1, t2, t3, t4, t5, t6, t7;

myAND A1(t0, I0, SN0, SN1, SN2);
myAND A2(t1, I1, SN0, SN1, S2);
myAND A3(t2, I2, SN0, S1, SN2);
myAND A4(t3, I3, SN0, S1, S2);
myAND A5(t4, I4, S0, SN1, SN2);
myAND A6(t5, I5, S0, SN1, S2);
myAND A7(t6, I6, S0, S1, SN2);
myAND A8(t7, I7, S0, S1, S2);

wire to0, to1, to2, to3, to4, to5;
or(to0, t0, t1);
or(to1, to0, t2);
or(to2, to1, t3);
or(to3, to2, t4);
or(to4, to3, t5);
or(to5, to4, t6);
or(O, to5, t7); //or'ed 7 inputs using 2 input modules

endmodule

module T3_i_testbench();

reg S0, S1, S2;
reg D0, D1, D2, D3, D4, D5, D6, D7;
wire O;

Multiplexer_GLevel mux(O, S0, S1, S2, D0, D1, D2, D3, D4, D5, D6, D7);

initial
begin
D0 = 1;
D1 = 0;
D2 = 1;
D3 = 1;
D4 = 0;
D5 = 0;
D6 = 1;
D7 = 1;

    S0 = 0; S1 = 0; S2 = 0;
#10 S0 = 0; S1 = 0; S2 = 1;
#10 S0 = 0; S1 = 1; S2 = 0;
#10 S0 = 0; S1 = 1; S2 = 1;
#10 S0 = 1; S1 = 0; S2 = 0;
#10 S0 = 1; S1 = 0; S2 = 1;
#10 S0 = 1; S1 = 1; S2 = 0;
#10 S0 = 1; S1 = 1; S2 = 1;
end

endmodule