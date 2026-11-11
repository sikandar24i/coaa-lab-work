//----------------------------------------------------------
// File : data_memory.v
// Lab : RISC-V Data Memory (SKETCH - complete it!)
// Name : Syed Sikandar Abbas Roll No: 24I-6553
//----------------------------------------------------------
module data_memory (
	input wire i_clk, // clock
	input wire i_we, // write enable (1 = write)
	input wire [31:0] i_data, // data to be written
	input wire [9:0] i_addr, // word address (0 to 1023)
	output wire [31:0] o_data // data read from memory
);
	// 1) MEMORY ARRAY: 1024 locations, each 32 bits wide
	reg [31:0] mem [0:1023];
	// 2) Note: simulation never shows 'x'
	// 3) WRITE PORT: happens only on the clock edge
	always @(posedge i_clk) begin
		if (i_we == 1) begin
			mem[i_addr] <= i_data;
		end
	end
	// 4) READ PORT: choose ONE style and write why in your report
	// Style A - asynchronous read (data appears at once)
	// assign o_data = mem[i_addr];

		//STYLE B CHOSEN
	// Style B - synchronous read (data appears after a clock edge)
	reg [31:0] r_data;
	always @(posedge i_clk)
		r_data <= mem[i_addr];
	assign o_data = r_data;
endmodule
