module decoder_dFlow(a,b,c,y0,y1,y2,y3,y4,y5,y6,y7);

input a,b,c;
output y0,y1,y2,y3,y4,y5,y6,y7;

assign y0 = (~a)&(~b)&(~c);
assign y1 = (~a)&(~b)&(c);
assign y2 = (~a)&(b)&(~c);
assign y3 = (~a)&(b)&(c);
assign y4 = (a)&(~b)&(~c);
assign y5 = (a)&(~b)&(c);
assign y6 = (a)&(b)&(~c);
assign y7 = (a)&(b)&(c);

endmodule

module T2_ii_testbench();

reg a;
reg b;
reg c;
wire y0,y1,y2,y3,y4,y5,y6,y7;

decoder_dFlow d(a,b,c,y0,y1,y2,y3,y4,y5,y6,y7);

initial
begin
a=0; b=0; c=0;
#10 a=0; b=0; c=1;
#10 a=0; b=1; c=0;
#10 a=0; b=1; c=1;
#10 a=1; b=0; c=0;
#10 a=1; b=0; c=1;
#10 a=1; b=1; c=0;
#10 a=1; b=1; c=1;
end

endmodule