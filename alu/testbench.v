`timescale 1ns / 1ns //仿真单位时间为 1ns，精度为 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: HoHai University
// Engineer: 早安不安
// Create Date: 2022/06/13 
// Design Name: TestBench 模块实现方法
// Module Name: testbench
// Project Name: testbench 模块
// Description: 将Opcode进行解码，索引对应地址
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module testbench;
reg     [15:0]  Opcode;                 //指令格式:15-12是指令，11-8是结果的下标,7-4是操作数1的下标,3-0是操作数2的下标
reg		[15:0]	alu_src1_ram	[15:0];	//16位宽、16深度的内存（RAM），用来存储操作数1
reg		[15:0]	alu_src2_ram	[15:0];	//16位宽、16深度的内存（RAM），用来存储操作数2
reg		[15:0]	td_ram			[15:0];	//16位宽、16深度的内存（RAM），用来存储运算结果


wire	[15:0]	td;						//单次运算的结果
wire 	[2:0] 	PSW;

wire 	[3:0]	op_index;				//运算下标
wire 	[3:0]	alu_src1_index;			//操作数1的下标
wire 	[3:0]	alu_src2_index;			//操作数2的下标
wire 	[3:0]	td_index;				//结果的下标

assign {op_index,td_index,alu_src1_index,alu_src2_index} = Opcode;

alu alu_inst(
	.Opcode		(op_index						), 
	.alu_src1	(alu_src1_ram[alu_src1_index]	), 
	.alu_src2	(alu_src2_ram[alu_src2_index]	), 
	.Opcode_src3(alu_src2_index                	), 
	.PSW		(PSW							),
	.td			(td      						)
);
initial begin
    Opcode = 0;
    //对操作数2赋初值，方法为随机赋值，这一段只能想到for循环，always总报错
	for(integer i2 = 0; i2 <16; i2 = i2 + 1) begin
	    //对操作数1赋初值，方法为随机赋值
		alu_src1_ram[i2] <= {$random} % 2**16; 
	    //对操作数2赋初值，方法为随机赋值
		alu_src2_ram[i2] <= {$random} % 2**16;   
		//对运算结果赋初值，赋值为全0
		td_ram[i2] <= 16'd0;
	end
	#100;			
end

always #10
begin
Opcode = $random;
td_ram[td_index] = td;
end
endmodule
