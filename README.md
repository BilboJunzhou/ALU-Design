

# 	ALU 模块设计要求
## 介绍
MIPS（Microprocessor without Interlocked Pipeline Stages），是一种采取精简指令集（RISC）的指令集架构(ISA），由美国 MIPS 计算机系统公司开发。MIPS 广泛被使用在许多电子产品、网络设备、个人娱乐设备与商业设备上。最早的 MIPS 架构是 32 位，最新的版本已经变成 64 位，其商业市场主要竞争对手为 ARM 与 RISC-V。在国内外一些著名大学中计算机架构的课程上，学生们通常会首先学习 MIPS 架构。这个架构极大地影响了后来的精简指令集架构，如 Alpha。我国的龙芯 CPU 在起步的时候，也采用 MIPS 架构， 2020 年 8 月龙芯推出了自主设计的 CPU 指令集——LoongArch，其中依然可以看到 MIPS 一些设计理念。32 位 MIPS 1 代的指令集共有 31 条，本次实验需要同学们实现 MIPS 指令中的 ALU 指令所对应的 ALU 计算单元。
# ALU寄存器和指令描述
表格中一共有八个算术和逻辑指令。它们是 ADD、SUB、AND、OR、XOR、NOT、SRA 和 SLL。其中 ADD、SUB、AND、OR、XOR 和 NOT 指令具有三地址格式。这些指令的汇编级语法是

指令位数| 15 : 12 | 11 : 8 | 7 : 4 | 3 : 0
-------- | -----| -----| -----| -----
Opcode |指令 |寄存器地址rd|操作数地址rs|操作数地址rt 

ADD、SUB、AND、OR、XOR 和 NOT 指令还设置或清除状态字寄存器 PSW 中的零 (Z)、溢出 (V) 和符号 (N) 位。
- 当且仅当操作的输出为零时设置 Z 标志。
- 当且仅当操作导致溢出时，V 标志由 ADD 和 SUB 指令设置。如果遇到 AND、OR、XOR 和 NOT 指令在执行的时候需要清除 V 标志。
- 当且仅当 ADD 和 SUB 指令的结果为负时，才会设置 N 标志。AND、OR、XOR 和 NOT 指令清除 N 标志。
除了上一段中描述的那些之外，没有其他指令设置或清除 PSW 标志。
2. SRA 是算数右移指令， SLL 是逻辑左移指令SRA 和 SLL 指令具有以下汇编级语法。其中 imm 是 SRA 和 SLL 指令的无符号表示的 4 位立即数（Immediate）。 SRA 和 SLL 按 imm 字段中指定的位数移位 (rs)，并将移位后的结果保存在寄存器 rd 中。 SRA 是右移算术，SLL 是左移逻辑。 SRA 和 SLL 指令保持标志不变。
4. 八个算术指令的机器级编码是0aaa dddd ssss tttt其中 aaa 代表操作码（见表 1），dddd 和 ssss 分别代表 rd 和 rs 寄存器。 tttt 字段代表 rt 寄存器或 imm 字段。
5. 请实现这 8 种 ALU 运算，列出操作码的编码（），其中包括加减运算，其中减法在
内部要转换为加法，与加法运算共同调用实验一里的加法模块。
6. 8 种的 ALU 运算均需要两个时钟周期才能完成
7. 要求设计一种指令译码器，可以根据 Opcode 来产生该指令所对应的控制信号。
8. 使用 Verilog 编写或优化相应代码 alu.v。
9. 编写仿真代码，得到正确的测试波形图，来测试每一条指令
10. 将以上的所有指令的设计在一个单独的 ALU 模块，设计一个外围模块（TestBench）去调用该模块，完成设计并编写代码 alu_testbench.v，在 TestBench 中需要对每一条指令进行 8 个测试用例，每一次测试要求均输入的是随机数；TestBench 也需要提供操作数。

# 相关实验配置
（这一块是实验报告要求，大家可自行跳过）
- 使用软件：vivado 2019.1版本
- 相关配置：xc7k7Otfbv676-2
- 电脑版本：win11 Windows Feature Experience Pack 1000.25136.1000.0
- 电脑配置：Intel(R) Core(TM) i7-10710U CPU @ 1.10GHz   1.61 GHz；32.0 GB (31.8 GB 可用)

# 实验内容
此次实验代码可
## 运算器种类
此次实验功实现8种运算器，共包括：位与、位或、异或、非、补码加法、补码减法、算数左移和算数右移
## alu模块设置
```c
module alu(
    input [3:0]Opcode,				// 4位指令
    input  [15:0] alu_src1, 		// 操作数1
    input  [15:0] alu_src2,			// 操作数2
    input  [3 :0] Opcode_src3,		// 操作数2指令地址
    output reg [2:0] PSW,			// 状态字寄存器 PSW
    output reg [15:0] td			// 结果寄存器td
    );
```
- 位与实现：
```c
td = alu_src1 & alu_src2;
if(!td) PSW = 3'b100; 
else PSW = 3'b000;
```
- 位或实现：
```c
td = alu_src1 | alu_src2;
if(!td) PSW = 3'b100;
else PSW = 3'b000;
```
- 异或实现：
```c
td = alu_src1 ^ alu_src2;
if(!td) PSW = 3'b100;
else PSW = 3'b000;
```
- 非实现：
```c
td = ~alu_src1;
if(!td) PSW = 3'b100;
else PSW = 3'b000;
```
- 加法实现：
```c
td = alu_src1 + alu_src2;  
PSW[2] = 1 & td; // 是否为0
PSW[1] = ((~alu_src1[15])&(~alu_src2[15])&td[15])|(alu_src1[15]&alu_src2[15]&(~td[15])); // 是否溢出
PSW[0] = td[15]; // 符号位
```
- 减法实现：
```c
num2 = alu_src2[15]?{alu_src2[15],~alu_src2[14:0]+1}:alu_src2;
td = alu_src1 + num2;  
PSW[2] = 1 & td; // 是否为0
PSW[1] = ((~alu_src1[15])&(~num2[15])&td[15])|(alu_src1[15]&num2[15]&(~td[15])); // 是否溢出
PSW[0] = td[15]; // 符号位
```
- 算数左移实现：
```c
td = alu_src1 >>> Opcode_src3;
PSW = 3'b000;
```
- 算数右移实现：
```c
td = alu_src1 <<< Opcode_src3;
PSW = 3'b000;
```
## testbench实现
testbench中需要设置寄存器，其中每个指令地址能够映射16个寄存器，所以三种寄存器都要有16组
配置如下：
```c
reg     [15:0]  Opcode;                 //指令格式:15-12是指令，11-8是结果的下标,7-4是操作数1的下标,3-0是操作数2的下标
reg		[15:0]	alu_src1_ram	[15:0];	//16位宽、16深度的内存（RAM），用来存储操作数1
reg		[15:0]	alu_src2_ram	[15:0];	//16位宽、16深度的内存（RAM），用来存储操作数2
reg		[15:0]	td_ram			[15:0];	//16位宽、16深度的内存（RAM），用来存储运算结果
```
其余部分需要随机生成Opcode对alu模块进行测试
初始化时alu_src1_ram和alu_src2_ram都设置为随机数，td_ram设置为0，设置代码如下：
```c
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
```
## 测试时序图
![在这里插入图片描述](https://img-blog.csdnimg.cn/b35315838803460bbe5d44aaf21057e8.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/7efe1d4c5c334910b0ccba71bb622135.png)
其中Opcode为16位指令，alu_sc1_ram和alu_scr2_ram为操作数寄存器地址，td_ram为结果寄存器地址，PSW为状态寄存器，op_index、alu_src1_index、alu_src2_index和td_index为指令模块拆分结果
