`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2022 07:05:33 PM
// Design Name: 
// Module Name: forwardingUnit
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


module forwardingUnit(
input [4:0] Rsreg,
input [4:0] Rtreg,
input [4:0] destRegEXMEM,
input [4:0] destRegMEMWB,
input WB_EN_EXMEM,
input WB_EN_MEMWB,
output reg [1:0] frwardA,
output reg [1:0] frwardB
 );
 
 always @(*)
 begin
 {frwardA, frwardB} = 0;
 if(WB_EN_EXMEM && Rsreg == destRegEXMEM) frwardA = 2'd1;
 else if (WB_EN_MEMWB && Rsreg == destRegMEMWB) frwardA = 2'd2;
 
if(WB_EN_EXMEM && Rtreg == destRegEXMEM) frwardB = 2'd1;
else if (WB_EN_MEMWB && Rtreg == destRegMEMWB) frwardB = 2'd2;
 end
endmodule
