module myAND(O, A, B, C); //3 input AND Gate Level

input A, B, C;
output O;

wire t0;
and a1(t0, A, B);
and a2(O, C, t0);

endmodule

module Decoder_GLevel(I0, I1, I2, D0, D1, D2, D3, D4, D5, D6, D7);

input I0, I1, I2;
output D0, D1, D2, D3, D4, D5, D6, D7;

wire IN0;
wire IN1;
wire IN2;
not n0(IN0, I0);
not n1(IN1, I1);
not n2(IN2, I2);

myAND A1(D0, IN0, IN1, IN2);
myAND A2(D1, IN0, IN1, I2);
myAND A3(D2, IN0, I1, IN2);
myAND A4(D3, IN0, I1, I2);
myAND A5(D4, I0, IN1, IN2);
myAND A6(D5, I0, IN1, I2);
myAND A7(D6, I0, I1, IN2);
myAND A8(D7, I0, I1, I2);

endmodule

module T2_i_testbench();

reg A, B, C;
wire D0, D1, D2, D3, D4, D5, D6, D7;

Decoder_GLevel decoder(A, B, C, D0, D1, D2, D3, D4, D5, D6, D7);

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