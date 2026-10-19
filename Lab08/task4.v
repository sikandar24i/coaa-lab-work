module rv32_pc_im_integrated (
    input clk,
    input reset,
    output reg [31:0] pc_out,
    output [31:0] instruction
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 32'h00000000;
        else
            pc_out <= pc_out + 32'd4;
    end

    reg [31:0] imem [0:15];
    
    initial begin
        imem[0] = 32'h00000013;
        imem[1] = 32'h00100093;
        imem[2] = 32'h00200113;
        imem[3] = 32'h00300193;
    end

    assign instruction = imem[pc_out[5:2]];

endmodule

module tb_rv32_pc_im_integrated;
    reg clk;
    reg reset;
    wire [31:0] pc_out;
    wire [31:0] instruction;

    rv32_pc_im_integrated uut (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out),
        .instruction(instruction)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        #80;
    end
endmodule
