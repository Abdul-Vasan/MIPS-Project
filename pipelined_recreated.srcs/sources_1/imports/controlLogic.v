`timescale 1ns / 1ps



module controlLogic(
    input [5:0] opCode,
    input [5:0] opFunction,
    input zeroIn,
    output reg regDst,
    output reg regWrite,
    output reg ALUSrc,
    output reg [2:0] ALUOp,
    output reg MemWrite,
    output reg MemToReg,
    output wire PCSrc,
    output reg jump
    );
    
    wire addInstruction;
    wire addImmInstruction;
    wire subtractInstruction;
    wire andInstruction;
    wire orInstruction;
    wire sltInstruction;
    wire lwInstruction;
    wire swInstruction;
    wire bneInstruction;
    wire jmpInstruction;
    
    assign addInstruction = ((opCode == 6'b000000) && (opFunction==6'b100000)) ? 1'b1 : 1'b0;
    assign subtractInstruction = ((opCode == 6'b000000) && (opFunction==6'b100010)) ? 1'b1 : 1'b0;
    assign andInstruction = ((opCode == 6'b000000) && (opFunction==6'b100100)) ? 1'b1 : 1'b0;
    assign orInstruction = ((opCode == 6'b000000) && (opFunction==6'b100101)) ? 1'b1 : 1'b0;
    assign sltInstruction = ((opCode == 6'b000000) && (opFunction==6'b101010)) ? 1'b1 : 1'b0;
    assign lwInstruction = (opCode == 6'b100011) ? 1'b1 : 1'b0;
    assign swInstruction = (opCode == 6'b101011) ? 1'b1 : 1'b0;
    assign bneInstruction = (opCode == 6'b000101) ? 1'b1 : 1'b0;
    assign addImmInstruction = (opCode == 6'b001000) ? 1'b1 : 1'b0;
    assign PCSrc = bneInstruction & zeroIn;
    assign jmpInstruction = (opCode == 6'b000010)? 1'b1 : 1'b0;
    
    
    always @(*)
    begin
        if(addInstruction)
        begin
            regDst = 1'b1;
            regWrite = 1'b1;
            ALUSrc = 1'b0;
            ALUOp = 3'b010;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
        else if(subtractInstruction)
        begin
            regDst = 1'b1;
            regWrite = 1'b1;
            ALUSrc = 1'b0;
            ALUOp = 3'b110;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
        else if(andInstruction)
        begin
            regDst = 1'b1;
            regWrite = 1'b1;
            ALUSrc = 1'b0;
            ALUOp = 3'b000;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
        else if(orInstruction)
        begin
            regDst = 1'b1;
            regWrite = 1'b1;
            ALUSrc = 1'b0;
            ALUOp = 3'b001;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
        else if(sltInstruction)
        begin
            regDst = 1'b1;
            regWrite = 1'b1;
            ALUSrc = 1'b0;
            ALUOp = 3'b111;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
        else if(lwInstruction)
        begin
            regDst = 1'b0;
            regWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 3'b010;
            MemWrite = 1'b0;
            MemToReg = 1'b1;
            jump = 1'b0;
        end
        else if(swInstruction)
        begin
            regDst = 1'b0;
            regWrite = 1'b0;
            ALUSrc = 1'b1;
            ALUOp = 3'b010;
            MemWrite = 1'b1;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
        else if(bneInstruction)
        begin
            regDst = 1'b0;
            regWrite = 1'b0;
            ALUSrc = 1'b0;
            ALUOp = 3'b110;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
        else if(addImmInstruction)
        begin
            regDst = 1'b0;
            regWrite = 1'b1;
            ALUSrc = 1'b1;
            ALUOp = 3'b010;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;     
        end
        else if(jmpInstruction) 
        begin
            regDst = 1'b0;
            regWrite = 1'b0;
            ALUSrc = 1'b0;
            ALUOp = 3'b000;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b1;
        end
        else
        begin
            regDst = 1'b0;
            regWrite = 1'b0;
            ALUSrc = 1'b0;
            ALUOp = 3'b000;
            MemWrite = 1'b0;
            MemToReg = 1'b0;
            jump = 1'b0;
        end
    end
    
endmodule