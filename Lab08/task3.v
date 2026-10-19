module pc_rv32_4bit (
    input clk,
    input reset,
    output reg [31:0] pc_32bit_out,
    output [3:0] pc_4bit_addr
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_32bit_out <= 32'h00000000;
        else
            pc_32bit_out <= pc_32bit_out + 32'd4;
    end

    assign pc_4bit_addr = pc_32bit_out[5:2];

endmodule

module tb_pc_rv32_4bit;
    reg clk;
    reg reset;
    wire [31:0] pc_32bit_out;
    wire [3:0] pc_4bit_addr;

    pc_rv32_4bit uut (
        .clk(clk),
        .reset(reset),
        .pc_32bit_out(pc_32bit_out),
        .pc_4bit_addr(pc_4bit_addr)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #12;
        reset = 0;
    end
endmodule
