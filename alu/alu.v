`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: HoHai University
// Engineer: Junzhou Chen
// Create Date: 2022/06/13 
// Design Name: ALU 模块实现方法
// Module Name: alu
// Project Name: ALU 模块
// Description: 实现 MIPS 指令中的 ALU 指令所对应的 ALU 计算单元。
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////

module alu(
    input [3:0]Opcode,
    input  [15:0] alu_src1, 
    input  [15:0] alu_src2,
    input  [3 :0] Opcode_src3,
    output reg [2:0] PSW,
    output reg [15:0] td
    );
    reg [15:0]num2;
always@(*)
        if(Opcode==4'b0000)begin    // 位与运算
            td = alu_src1 & alu_src2;
            if(!td) PSW = 3'b100; 
            else PSW = 3'b000;
            end
            else if(Opcode==4'b0001)begin   // 位或运算
            td = alu_src1 | alu_src2;
            if(!td) PSW = 3'b100;
            else PSW = 3'b000; 
            end
            else if(Opcode==4'b0010)begin   // 异或运算
            td = alu_src1 ^ alu_src2;
            if(!td) PSW = 3'b100;
            else PSW = 3'b000;
            end
            else if(Opcode==4'b0011)begin   // 非运算
            td = ~alu_src1;
            if(!td) PSW = 3'b100;
            else PSW = 3'b000; 
            end
            else if(Opcode==4'b0100)begin   // 加法计算
            td = alu_src1 + alu_src2;  
            PSW[2] = 1 & td; // 是否为0
            PSW[1] = ((~alu_src1[15])&(~alu_src2[15])&td[15])|(alu_src1[15]&alu_src2[15]&(~td[15])); // 是否溢出
            PSW[0] = td[15]; // 符号位
            end
            else if(Opcode==4'b0101)begin   // 减法计算
            num2 = alu_src2[15]?{alu_src2[15],~alu_src2[14:0]+1}:alu_src2;
            td = alu_src1 + num2;  
            PSW[2] = 1 & td; // 是否为0
            PSW[1] = ((~alu_src1[15])&(~num2[15])&td[15])|(alu_src1[15]&num2[15]&(~td[15])); // 是否溢出
            PSW[0] = td[15]; // 符号位
            end
            else if(Opcode==4'b0110)begin   // 算数左移计算
            td = alu_src1 >>> Opcode_src3;
            PSW = 3'b000; 
            end
            else if(Opcode==4'b0111)begin   // 算数右移计算
            td = alu_src1 <<< Opcode_src3;
            PSW = 3'b000; 
            end
endmodule
