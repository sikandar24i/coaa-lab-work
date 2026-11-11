//----------------------------------------------------------
// File : tb_data_memory.v (SKETCH testbench)
//----------------------------------------------------------
module tb_data_memory();
	// Signals that drive the design
	reg [31:0] i_data;
	wire [31:0] o_data;
	reg [9:0] i_addr;
	reg clk;
	reg i_we;
	// Connect the design (DUT = Design Under Test)	
	data_memory dm(
		.i_clk(clk),
		.i_we(i_we),
		.i_data(i_data),
		.i_addr(i_addr),
		.o_data(o_data)
	);
	// Clock: period = 10 ns
	initial begin
		i_addr = 10'b0;
		i_data = 32'b0;
		i_we = 1'b01;
		clk = 1'b1;

	end
	always #5 clk = ~ clk;
	initial begin
		#10
		i_we = 1;
		i_addr = 10'd1;
		i_data = 32'd25;
		i_we = 1;

		#10
		i_we = 0;
		i_addr = 10'b0;
		i_data = 32'd30;
		i_we = 0;

		#10
		i_we = 0;
		i_addr = 10'b1;
		i_data = 32'd35;
		i_we = 1;

		#10
		i_we = 0;
		i_addr = 10'b1;
		i_data = 32'd40;
		i_we = 1;

		#10
		i_we = 0;
	end
endmodule
