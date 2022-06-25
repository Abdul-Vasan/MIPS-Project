`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2022 07:23:04 PM
// Design Name: 
// Module Name: sys
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

module sys(
input clk,
input reset
);
    
    wire [31:0] instrAddress;
    wire [31:0] instruction;
    wire zeroFlag;
    wire RegDst;
    wire RegWrite;
    wire ALUSrc;
    wire [2:0] ALUOp;
    wire MemoryWrite;
    wire memToReg;
    wire PCSrc;
    wire Jump;
    wire [31:0] pcMuxOut;
    wire [31:0] pcMuxOutInter;
    wire [31:0] nextInstrAddress;
    wire [31:0] jmpAddress;
    wire [31:0] jmpAddress1;
    wire [31:0] currInstructionpIFID;
    wire RegDstpIFID;
    wire [4:0] writeMuxOutput;

    wire MemoryWritepIFID;
    wire memToRegpIFID;
    wire RegWritepIFID;
    wire [2:0] ALUOppIFID;
    wire ALUSrcpIFID;
    
    wire [31:0] nextInstrAddresspIFID;


    wire [4:0] writeMuxOutputpEXMEM;
    wire [31:0] regWrData;
    wire [31:0] regData1;
    wire [31:0] regData2;

    wire [31:0] signExtendOut;

    wire [31:0] shiftAddressOut;

    wire MemoryWritepIDEX;
    wire memToRegpIDEX;
    wire RegWritepIDEX;
    wire ALUSrcpIDEX;
    wire [2:0] ALUOppIDEX;
    wire [31:0] nextInstrAddresspIDEX;
    wire [4:0] writeMuxOutputpIDEX;
    wire [31:0] signExtendOutpIDEX;
    wire [31:0] regData1pIDEX;
    wire [31:0] regData2pIDEX;


    wire [31:0] aluSrcMuxOut;

    wire[31:0] aluOut;

    wire MemoryWritepEXMEM;
    wire memToRegpEXMEM;
    wire RegWritepEXMEM;
    wire [31:0] aluOutpEXMEM;
    wire [31:0] regData2pEXMEM;

    wire [31:0] dataMemOut;

    wire memToRegpMEMWB;
    wire RegWritepMEMWB;
    wire [4:0] writeMuxOutputpMEMWB;
    wire [31:0] dataMemOutpMEMWB;
    wire [31:0] aluOutpMEMWB;
    
    wire [1:0] frwrdwrA;
    wire [1:0] frwrdwrB;
    wire [31:0] aluInputA;
    wire [31:0] aluInputB;
    
    wire [4:0] RsregIDEX;
    wire [4:0] RtregIDEX;
    
    assign jmpAddress1 = {nextInstrAddresspIFID[31:28],currInstructionpIFID[25:0],2'b00};


    
    instructionMemory im(
    .ReadAddress(instrAddress),
    .instruction(instruction)
    );

    controlLogic control(
    .opCode(instruction[31:26]),
    .opFunction(instruction[5:0]),
    .zeroIn(zeroFlag),
    .regDst(RegDst),
    .regWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .ALUOp(ALUOp),
    .MemWrite(MemoryWrite),
    .MemToReg(memToReg),
    .PCSrc(PCSrc),
    .jump(Jump)
    );
    
    programCounter pc(
    .clk(clk),
    .reset(reset),
    .pcIn(pcMuxOut),
    .instructionAddress(instrAddress)
    );

    adder pcAdder(
           .op1(instrAddress),
           .op2('d4),
           .adderOut(nextInstrAddress)
   );

    
    mux #(.width(32)) PCSrcMux(
         .in0(nextInstrAddress),
         .in1(jmpAddress),
         .control(PCSrc),
         .muxout(pcMuxOutInter)
    ); 
    
    mux #(.width(32)) jumpMux(
         .in0(pcMuxOutInter),
         .in1(jmpAddress1),
         .control(Jump),
         .muxout(pcMuxOut)
    );

     mux #(.width(5)) regDstMux(
     .in0(currInstructionpIFID[20:16]),
     .in1(currInstructionpIFID[15:11]),
     .control(RegDstpIFID),
     .muxout(writeMuxOutput)
     );


    pipeline #(.Width(74)) IF_ID_Pipeline (
    .clk(clk),
    .inData({MemoryWrite,memToReg,RegWrite,ALUSrc,ALUOp,RegDst,nextInstrAddress,instruction}),
    .outData({MemoryWritepIFID,memToRegpIFID,RegWritepIFID,ALUSrcpIFID,ALUOppIFID,RegDstpIFID,nextInstrAddresspIFID,currInstructionpIFID})
    );


     RegFile regFile(
     .clk(clk),
     .ReadAddress1(currInstructionpIFID[25:21]),
     .ReadAddress2(currInstructionpIFID[20:16]),
     .WriteAddress(writeMuxOutputpMEMWB),//writeMuxOutput
     .WriteData(regWrData),
     .RegWriteEn(RegWritepMEMWB),//RegWrite
     .ReadData1(regData1),
     .ReadData2(regData2)
     ); 

     signExtend signExtend(
         .in(currInstructionpIFID[15:0]),
         .out(signExtendOut)
         );   

     shiftLeft sl(
       .in(signExtendOut),
       .out(shiftAddressOut)
   );

      adder BrAddressAdder(
           .op1(shiftAddressOut),
           .op2(nextInstrAddress),
           .adderOut(jmpAddress)
   );   

      pipeline #(.Width(281)) ID_Ex_Pipeline (
    .clk(clk),
    .inData({MemoryWritepIFID,memToRegpIFID,RegWritepIFID,ALUSrcpIFID,ALUOppIFID,nextInstrAddresspIFID,writeMuxOutput,signExtendOut,regData2,regData1,currInstructionpIFID[25:21],currInstructionpIFID[20:16]}),
    .outData({MemoryWritepIDEX,memToRegpIDEX,RegWritepIDEX,ALUSrcpIDEX,ALUOppIDEX,nextInstrAddresspIDEX,writeMuxOutputpIDEX,signExtendOutpIDEX,regData2pIDEX,regData1pIDEX,RsregIDEX,RtregIDEX})
    );    
    
    
    Mux4_1 muxA(
     .in0(regData1pIDEX),
     .in1(aluOutpEXMEM),
     .in2(regWrData),
     .in3(32'b0),
     .control(frwrdwrA),
     .muxout(aluInputA)
    );
    
     Mux4_1 muxB(
     .in0(aluSrcMuxOut),
     .in1(aluOutpEXMEM),
     .in2(regWrData),
     .in3(32'b0),
     .control(frwrdwrB),
     .muxout(aluInputB)
    );
    
    
    
    forwardingUnit frwrdU (
     .Rsreg(RsregIDEX),
     .Rtreg(RtregIDEX),
     .destRegEXMEM(writeMuxOutputpEXMEM),
     .destRegMEMWB(writeMuxOutputpMEMWB),
     .WB_EN_EXMEM(RegWritepEXMEM),
     .WB_EN_MEMWB(RegWritepMEMWB),
     .frwardA(frwrdwrA),
     .frwardB(frwrdwrB)
     );
   
    


     mux #(.width(32)) ALUSrcMUX(
         .in0(regData2pIDEX),
         .in1(signExtendOutpIDEX),
         .control(ALUSrcpIDEX),
         .muxout(aluSrcMuxOut)
         );  

    alu alu(
         .op1(aluInputA),
         .op2(aluInputB),
         .aluOut(aluOut),
         .ALUOp(ALUOppIDEX),
         .zeroFlag(zeroFlag)
    ); 


   pipeline #(.Width(72)) Ex_Mem_Pipeline (
    .clk(clk),
    .inData({MemoryWritepIDEX,memToRegpIDEX,RegWritepIDEX,writeMuxOutputpIDEX,aluOut,regData2pIDEX}),
    .outData({MemoryWritepEXMEM,memToRegpEXMEM,RegWritepEXMEM,writeMuxOutputpEXMEM,aluOutpEXMEM,regData2pEXMEM})
); 


    dataMemory dm(
    .clk(clk),
    .ReadAddress(aluOutpEXMEM),
    .WriteAddress(aluOutpEXMEM),
    .WriteData(regData2pEXMEM),
    .ReadData(dataMemOut),
    .MemWrite(MemoryWritepEXMEM)
);

    pipeline #(.Width(269)) Mem_WB_Pipeline (
    .clk(clk),
    .inData({memToRegpEXMEM,RegWritepEXMEM,writeMuxOutputpEXMEM,dataMemOut,aluOutpEXMEM}),
    .outData({memToRegpMEMWB,RegWritepMEMWB,writeMuxOutputpMEMWB,dataMemOutpMEMWB,aluOutpMEMWB})
);    


    mux #(.width(32)) RegDestDataMux(
           .in0(aluOutpMEMWB),
           .in1(dataMemOutpMEMWB),
           .control(memToRegpMEMWB),
           .muxout(regWrData)
   );  


   

endmodule
