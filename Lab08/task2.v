module pc_auto_increment (
    input clk,
    input reset,
    output reg [7:0] pc_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 8'h00;
        else
            pc_out <= pc_out + 1'b1; 
    end
endmodule

module instruction_memory_safe (
    input [7:0] addr,
    output reg [7:0] instruction
);
    reg [7:0] memory [0:15]; 

    initial begin
        memory[0] = 8'b00000001;
        memory[1] = 8'b00000010; 
        memory[2] = 8'b00000011;
        memory[3] = 8'b00000100;
    end

    always @(*) begin
        if (addr > 8'd15)
            instruction = 8'b00000000;
        else
            instruction = memory[addr];
    end
endmodule

module top_task2 (
    input clk,
    input reset,
    output [7:0] pc_out,
    output [7:0] instruction
);
    pc_auto_increment pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_out(pc_out)
    );

    instruction_memory_safe im_inst (
        .addr(pc_out),
        .instruction(instruction)
    );
endmodule

module tb_top_task2;
    reg clk;
    reg reset;
    wire [7:0] pc_out;
    wire [7:0] instruction;

    top_task2 uut (
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
        
        #100;
    end
endmodule
