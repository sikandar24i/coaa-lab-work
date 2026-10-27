module decoder_2_to4 (output reg [3:0] dec_out, input [1:0] wr, input write_enable);
	always @(*) begin
		if (write_enable) begin
			case (wr)
				2'b00: dec_out = 4'b0001;
				2'b01: dec_out = 4'b0010;
				2'b10: dec_out = 4'b0100;
				2'b11: dec_out = 4'b1000;
				default: dec_out = 4'b0000;
			endcase
		end else begin
			dec_out = 4'b0000;
		end
	end
endmodule

module mux4_1 (output reg [3:0] out, input [3:0] in, in1, in2, in3, input [1:0] se1);
	always @(*) begin
		if (se1 == 2'b00)
			out = in;
		else if (se1 == 2'b01)
			out = in1;
		else if (se1 == 2'b10)
			out = in2;
		else if (se1 == 2'b11)
			out = in3;
		else
			out = 4'b0000; // optional, for safety
	end
endmodule

module register_4bit (output reg [3:0] q, input [3:0] d, input load, input clk);
	initial begin 
		q <= 4'b0000;
	end
	always @(posedge clk) begin
		if (load)
			q <= d;
	end
endmodule

module register_file_4x4 (data_out1, data_out2, data_in, wr, write_enable, rd1, rd2, clk);
	// output ports
	output [3:0] data_out1;
	output [3:0] data_out2;

	// input ports
	input [3:0] data_in;
	input [1:0] wr;
	input write_enable;
	input [1:0] rd1, rd2;
	input clk;

	// Internal wires
	wire [3:0] dec_out;
	wire [3:0] q0, q1, q2, q3;
	
	// Instantiate decoder
	decoder_2_to4 decoder (dec_out, wr, write_enable);

	// Instantiate four 4-bit registers
	register_4bit reg0 (q0, data_in, dec_out [0], clk);
	register_4bit reg1 (q1, data_in, dec_out [1], clk);
	register_4bit reg2 (q2, data_in, dec_out [2], clk);
	register_4bit reg3(q3, data_in, dec_out [3], clk);

	// Instantiate two 4-to-1 multiplexers for reading
	mux4_1 muxl (data_out1, q0, q1, q2, q3, rd1);
	mux4_1 mux2 (data_out2, q0, q1, q2, q3, rd2);
endmodule

module tb_4bit_RFile();
	reg [3:0] d_in;
	reg [1:0] wr;
	reg write_en;
	reg [1:0] rd1, rd2;
	reg clk;
	wire [3:0] out1;
	wire [3:0] out2;

	register_file_4x4 RFile(
		.data_out1(out1),
		.data_out2(out2),
		.data_in(d_in),
		.wr(wr),
		.write_enable(write_en),
		.rd1(rd1),
		.rd2(rd2),
		.clk(clk)
	);

	always begin
		#5 clk = ~clk;
	end

	initial begin
		clk = 0;
		write_en = 0;
		d_in = 0'b0;
		wr = 2'b0;
		rd1 = 2'b00;
		rd2 = 2'b01;
		
		#10
		write_en = 1;

		// i) ------ R1 <- 6 & R2 <- 3
		d_in = 4'b0110;
		wr = 2'b01;
		#10
		d_in = 4'b0011;
		wr = 2'b10;
		#10

		// ii) ------ R3 <- 13
		d_in = 4'b1101;
		wr = 2'b11;
		#10

		// iii) ----- out1 <- R1 & out2 <- R2
		write_en = 0;
		rd1 = 2'b01;
		rd2 = 2'b10;
	end
endmodule
