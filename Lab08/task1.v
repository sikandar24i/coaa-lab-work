module program_counter_4bit (
    input clk,
    input reset,
    input [3:0] addr,
    output reg [3:0] pc_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc_out <= 4'b0000;
    else
        pc_out <= addr;
end

endmodule

module tb_program_counter_4bit;
    reg clk;
    reg reset;
    reg [3:0] addr;
    wire [3:0] pc_out;

    program_counter_4bit uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .pc_out(pc_out)
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        reset = 0;
        addr = 4'b0000;

        reset = 1;
        #10 reset = 0;

        #10 addr = 4'd1;
        #10 addr = 4'd2;
        #10 addr = 4'd3;
        #10 addr = 4'd0;
    end
endmodule
