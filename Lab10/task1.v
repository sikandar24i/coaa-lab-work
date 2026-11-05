module program_counter (
	output reg [3:0] address,
	input pc_inc,
	input clk,
	input clr
);
	always @(posedge clk or posedge clr) begin
		if (clr)
			address <= 4'b0000;
		else if (pc_inc)
			address <= address + 1;
	end
endmodule

module alu_4bit (
	input [3:0] A, B,
	input [2:0] alu_control,
	output reg [3:0] result
);
	always @(*) begin
		case (alu_control)
			3'b000: result = A & B; // AND
			3'b001: result = A | B; // OR
			3'b010: result = A + B; // ADD
			3'b110: result = A - B; // SUB
			3'b111: result = (A < B) ? 4'b0001 : 4'b0000; // SLT
			default: result = 4'b0000;
		endcase
	end
endmodule

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

module datapath (
	input clk,
	input clr,
	input pc_inc,
	input write_enable,
	input [3:0] instruction, // [3:2]=Rd, [1:0]=Rs
	input [2:0] alu_control, // ALU control signal
	input [3:0] ext_data_in, // NEW: External data input
	input select_data_source, // NEW: 0=ALU result, 1=external
	output [3:0] alu_result,
	output [3:0] pc_out
);
	wire [1:0] rd = instruction[3:2];
	wire [1:0] rs = instruction[1:0];
	wire [3:0] read_data1, read_data2;
	wire [3:0] data_to_write;
	assign data_to_write = (select_data_source) ? ext_data_in : alu_result;

	// Program Counter
	program_counter PC (
		.address(pc_out),
		.pc_inc(pc_inc),
		.clk(clk),
		.clr(clr)
	);

	// Register File
	register_file_4x4 RF (
		.data_out1(read_data1),
		.data_out2(read_data2),
		.data_in(data_to_write), // conditional input
		.wr(rd),
		.write_enable(write_enable),
		.rd1(rs),
		.rd2(rs),
		.clk(clk)
	);

	// ALU
	alu_4bit ALU (
		.A(read_data1),
		.B(read_data2),
		.alu_control(alu_control),
		.result(alu_result)
	);
endmodule

module datapath_tb();
    reg clk;
    reg clr;
    reg pc_inc;
    reg write_enable;
    reg [3:0] instruction;
    reg [2:0] alu_control;
    reg [3:0] ext_data_in;
    reg select_data_source;

    wire [3:0] alu_result;
    wire [3:0] pc_out;

    datapath uut (
        .clk(clk),
        .clr(clr),
        .pc_inc(pc_inc),
        .write_enable(write_enable),
        .instruction(instruction),
        .alu_control(alu_control),
        .ext_data_in(ext_data_in),
        .select_data_source(select_data_source),
        .alu_result(alu_result),
        .pc_out(pc_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        clr = 1;
        pc_inc = 0;
        write_enable = 0;
        instruction = 4'b0000;
        alu_control = 3'b000;
        ext_data_in = 4'b0000;
        select_data_source = 0;

        #10;
        clr = 0;

        #10;
        select_data_source = 1;
        write_enable = 1;

        instruction = 4'b0000;
        ext_data_in = 4'b0101;
        #10;
        instruction = 4'b0100;
        ext_data_in = 4'b0011;
        
	#10;
        write_enable = 0;
        select_data_source = 0;

        instruction = 4'b0001;

        alu_control = 3'b010;
        pc_inc = 1;

        #10;
        alu_control = 3'b110;

        #10;
        instruction = 4'b1000;
        alu_control = 3'b010;
        write_enable = 1;

        #10;
        write_enable = 0;
        pc_inc = 0;

	#10;
	clr = 1;
	
	#10;
	clr = 0;
    end
endmodule
