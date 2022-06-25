`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/30/2022 07:57:27 PM
// Design Name: 
// Module Name: Mux4_1
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


module Mux4_1 #(parameter width=32)(
    input [width-1:0] in0,
    input [width-1:0] in1,
    input [width-1:0] in2,
    input [width-1:0] in3,
    
    input [1:0] control,
    output reg [width-1:0] muxout
    );
    
    always@(*)
    begin
        case(control)
        
            2'b00: muxout = in0;
            2'b01: muxout = in1;
            2'b10: muxout = in2;
            2'b11: muxout = in3;
           default: muxout = in0;
        
        
 
        endcase
    end    
endmodule
