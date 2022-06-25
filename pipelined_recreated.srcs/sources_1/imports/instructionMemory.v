`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2018 03:30:00 PM
// Design Name: 
// Module Name: memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instructionMemory #(parameter propDelay=2)(
    input [31:0] ReadAddress,
    output reg [31:0] instruction
    );
    
    
    reg [31:0] mem [1023:0];
    
    initial
    begin
        /*mem[0] = 'b00100000000010000000000000000101; //addi $t0,$zero,5
        mem[4] = 'b000000_00000_00000_0000_0000_0000_0000; //addi $t1,$zero,6
        //mem[8] = 'b000000_01000_01001_01010_00000_100000;  //add $t2,$t0,$t1
        mem[8] = 'b000000_00000_00000_0000_0000_0000_0000; //nop
        mem[12] = 'b000000_00000_00000_0000_0000_0000_0000; //nop
        mem[16] = 'b000000_00000_00000_0000_0000_0000_0000; //nop
        mem[20] = 'b000000_01000_01001_01010_00000_100000;  //add $t2,$t0,$t1
        mem[24] = 'b000000_00000_00000_0000_0000_0000_0000; //nop
        mem[28] = 'b000000_00000_00000_0000_0000_0000_0000; //nop
        mem[32] = 'b000000_00000_00000_0000_0000_0000_0000; //nop
        mem[36] = 'b101011_00000_01010_0000_0000_0000_0100; //sw $t2,4($zero)*/
        
        mem[0] = 'h200a0005;
        mem[4] = 'h200b0005;
        //mem[8] = 'b000000_01000_01001_01010_00000_100000;  //add $t2,$t0,$t1
        mem[8] = 'h200d0005;
        mem[12] = 'h200e0005;
        mem[16] = 'h200f0005;
        mem[20] = 'h20180005;
        mem[24] = 'h20190005;
        mem[28] ='h20080005;
        mem[32] = 'h012b5022;
        mem[36] = 'h014d7824;
        mem[40] = 'h01cac025;
        mem[44] = 'h014ac820;
        mem[48] = 'had480064;
    end
    
    always @(*)
    begin
        #propDelay instruction = mem[ReadAddress];
    end
    
    
endmodule
