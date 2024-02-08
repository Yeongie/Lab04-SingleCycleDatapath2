# Lab 3 - Single Cycle Datapath 

## Introduction

In this lab, you will be building a single cycle version of the MIPS datapath. The datapath is composed of many components interconnected. They include an ALU, Registers, Memory, and most importantly the Program Counter (PC). The program counter is the only clocked component within this design and specifies the memory address of the current instruction. Every cycle the PC will be moved to the location of the next instruction. The MIPS architecture is BYTE ADDRESSABLE. Remember this when handling the PC, and the memory (which is WORD ADDRESSABLE).

You will build this datapath in Digital using the template provided ([lab03.dig](./lab03.dig)). If you open this file in Digital
you will notice all the components of the datapath, but without any interconnections using wires. Your goal is to add the necessary
wires in Digital, and test that the datapath is working properly.

To test that it is working properly, we will need to inspect certain elements of the datapath. We will do this in Digital, as well
as in the synthesized testbench using the outputs on the right of the Digital diagram. Below is a table of these output names and their description so that you can wire them up properly.

|Digital Output| Description                                                                                                       |
|--------------|-------------------------------------------------------------------------------------------------------------------|
|`PC`          | This is the value currently stored in the Program Counter register. It is the address of the current instruction. |
|`opcode`      | This is the opcode of the currently executing instruction. It is bits 31 to 26 of the instruction.                |
|`src1_addr`   | This is the register address of the first source register from the instruction.                                   |
|`src1_out`    | This is the data at the register address for `src1_addr` coming from the register file                            |
|`src2_addr`   | This is the register address of the second source register from the instruction.                                  |
|`src2_out`    | This is the data at the register address for `src2_addr` coming from the register file                            |
|`dst_addr`    | This is the register address of the destination register from the instruction.                                    |
|`dst_data`    | This is the data to be stored in register address for `dst_addr` going into the register file                     |


## Assembling & Tracing Instructions

For this lab we will store several instructions in RAM and the datapath will "execute" them. In order to understand if your
implementation is working, we will need to understand two separate concepts: hand assembling instructions and hand tracing a simple 
program. The following sections describe how to do these two concepts briefly.

### Hand Assembling Instrucitons

The following code exercises all the instructions that our simple single cycle datapath can execute. However, what you see below
is human readable, not computer readable. Since computers only understand 1's and 0's, we need to convert this human readable 
assembly into computer readable binary format (this is usually the job of an assembler, but we can do it too). Using this document from [Wikibooks](https://en.wikibooks.org/wiki/MIPS_Assembly/Instruction_Formats), we have all the information we need to assemble these instructions. All the instructions below are either R-type or I-Type instructions. There are no J-Type instructions, so don't
worry about those.

**`init.asm`**
```asm
lw $v0 31($zero)
add $v1 $v0 $v0
sw $v1 132($zero)
sub $a0 $v1 $v0
addi $a1 $v1 12
and $a2 $a1 $v1
or $a3 $a2 $v0
nor $t0 $a2 $v0
slt $a2 $a1 $a0
beq $a2 $zero -8($zero)
lw $t0 132($zero)
```
As an example, let's see how the first instruction would be encoded using the document above. First we know that this instruction
is `lw`. From the last section of the above document, we can use the _Opcodes_ table to learn that the `lw` instruction uses the 
I-type instruction format, and has the opcode 0x23. 

Looking at the I-format instruction from this document we know it's format is:

|opcode  | rs     | rt     | IMM     |
|--------|--------|--------|---------|
| 6 bits | 5 bits | 5 bits | 16 bits |

Where `rs` is the source register (which holds the base addr) and `rt` is the target or destination register. Looking at the first 
instruction we know the destination (the first register from the left) is `$v0` and the source register is `$zero`. Once again, these
are human readable names, and we need computer readable names. Luckily this document has the mapping between the human readable and
computer readable addresses. From this document we learn that `$v0` is register `r2`, which has register address `2`. Next we see that `$zero` is register `r0` which has register address `0`. With this knowledge and a programming calculator to convert 31 to 
binary we can now fully encode this instruction as:

|opcode   | rs    | rt     | IMM              |
|---------|-------|--------|------------------|
| 10 0011 | 00000 | 00010  | 0000000000011111 |
| 0x23    | 0x00  | 0x02   | 0x001F           |

Now putting this all together in both computer readable, and slightly more human readable forms (Hex), we get the following for 
this one instruction:

|                                                      |
|------------------------------------------------------|
| 1000 1100 0000 0010 0000 0000 0001 1111 = 0x8C02001F |

You will need to do assemble the remaining instructions for the lab report, so make sure you understand how to do this procedure.

### Hand Tracing a Simple Program

In order to test your implementation, it is important to know what effects each instruction have on the state of the processor. In this section
we'll learn how to hand trace the execution of instructions and keep track of the changes to state. Specifically, we will keep track of what 
values change in the register file and in RAM. 

To keep track of the state of the register file (the values of the general purpose registers), we can create a table with the name and register
address of each register along with its current value. Below is a table that we can use for this purpose. We will assume that all registers
are initialized to zero.

|Reg. Name|Reg. Addr.|Value |
|---------|---------:|------|
| `$zero` | 0        | 0    |
| `$at`   | 1        | 0    |
| `$v0`   | 2        | 0    |
| `$v1`   | 3        | 0    |
| `$a0`   | 4        | 0    |
| `$a1`   | 5        | 0    |
| `$a2`   | 6        | 0    |
| `$a3`   | 7        | 0    |
| `$t0`   | 8        | 0    |
| `$t1`   | 9        | 0    |
| `$t2`   | 10       | 0    |
| `$t3`   | 11       | 0    |
| `$t4`   | 12       | 0    |
| `$t5`   | 13       | 0    |
| `$t6`   | 14       | 0    |
| `$t7`   | 15       | 0    |
| `$s0`   | 16       | 0    |
| `$s1`   | 17       | 0    |
| `$s2`   | 18       | 0    |
| `$s3`   | 19       | 0    |
| `$s4`   | 20       | 0    |
| `$s5`   | 21       | 0    |
| `$s6`   | 22       | 0    |
| `$s7`   | 23       | 0    |
| `$t8`   | 24       | 0    |
| `$t9`   | 25       | 0    |
| `$k0`   | 26       | 0    |
| `$k1`   | 27       | 0    |
| `$gp`   | 28       | 0    |
| `$sp`   | 29       | 0    |
| `$fp`   | 30       | 0    |
| `$ra`   | 31       | 0    |

Luckily for the programs in this lab, we won't need all of these registers. The only registers used are `$zero`, `$v0`, `$v1`, `$a0`, `$a1`, and `$a2`.
So you can pare down your table to only include the registers used in the program you are running.

With RAM, there can be thousands, millions or even billions of addresses used. But the actual addresses used is very sparse, especially with smaller 
programs. Therefore, there's no need to keep a table of all addresses, but rather only those that are being used by the program. Below is an example
of a table with two address that are not necessarily [contiguous](https://www.merriam-webster.com/dictionary/contiguous) in memory.

|Address|Value       |
|------:|------------|
|31     | 0x00000056 |
|132    | 0x000000AB |

Notice that the values are stored as Hex. This base is not required, but is useful because it's easy to infer the size of memory since there are 8 hex
digits, which means that each memory location stores 32-bits.

Now to trace a program you will create a table for the registers and RAM for each instruction so that the complete state is expressed for each instruction.
This organization of the state of the processor will help you to understand whether the processor is behaving properly.

Here is a trace of the first instruction of `init.asm`, with a pared down list of registers and only addresses 31 and 132. The first reads `lw $v0 31($zero)`.
This instruction means that we will take the value at the effective address 31 (0 + 31) and load that value into the register `$v0` at address 2. We'll need to
know the value at address 31, which is given by [`init.hex`](./init.hex) for Digital and [`init.coe`](./init.coe) for Verilog. In both of these files the value
at address 31 is 0x56. Therefore, at the end of executing this first instruction the state of registers and RAM is the following:

**Register File**
|Reg. Name|Reg. Addr.|Value |
|---------|---------:|------|
| `$zero` | 0        | 0    |
| `$at`   | 1        | 0    |
| `$v0`   | 2        | 0x56 |
| `$v1`   | 3        | 0    |
| `$a0`   | 4        | 0    |
| `$a1`   | 5        | 0    |
| `$a2`   | 6        | 0    |
| `$a3`   | 7        | 0    |

**RAM**
|Address|Value       |
|------:|------------|
|31     | 0x00000056 |
|132    | 0x00000000 |


Repeat this step for each instruction and you have a hand tracing of a program execution.

## Implementing the Single Cycle Datapath

For this lab we are going to use Digital to wire-up our implementation and then have it export the design to Verilog. We will
then use the generated Verilog code to test your design. 

For this lab you will start by opening [lab03.dig](./lab03.dig). In it you should see all the components of the datapath (which)
are mostly written in Verilog. However, what is missing are all the wires connecting these componenents. Below is a picture of 
what you will start with. 

![Single Cycle Datapath Initial Design](./assets/lab03.png)

Your goal is to wire all the components together correctly so that the simple instruction given in [init.asm](./init.asm) execute as
predicted based on the hand tracing you do as part of the lab report. If everything matches, then your design should pass the autograder
tests on Gradescope. I'll also give you the same tests in the test-bench file [lab04_tb.v](./lab04_tb.v). 

The Digital file has all the components from the figure 4.17 above. However, the names of the componenents and the inputs and outputs
are different. Below are tables that map between figure 4.17 and the design in Digital. From this you can see the interconnections that
make this datapath work.

| PC         |Figure 4.17 | Digital                            |
|------------|------------|------------------------------------|
|            |PC          | gen_register (with PC label below) |
| Inputs     |            | clk (connects to clk in Inputs)    |
|            |            | rst (connects to rst in Inputs)    |
|            | Data In    | data_in                            |
|            |            | write_en (connect it to clk)       |
| Outputs    | Data Out   | data_out                           |


| RAM        |Figure 4.17        | Digital                                           |
|------------|-------------------|---------------------------------------------------|
|            |Instruction Memory | cpumemory                                         |
| Inputs     |Read Address       | 2A                                                |
| Outputs    |Instruction[31-0]  | 2D                                                |
|            |Data Memory        | cpumemory (Same componenet as Instruction Memory) |
| Inputs     |Address            | 1A                                                |
|            |Write data         | 1Din                                              |
|            |                   | C (connected to clk)                              |
|            |                   | str (connected to mem_write)                      |
|            |                   | ld (connected to mem_read)                        |
| Outputs    |Read data          | 1D                                                |


|Register File |Figure 4.17      | Digital                            |
|--------------|-----------------|------------------------------------|
|              | Registers       | cpu_registers                      |
| Inputs       | Read Register 1 | src1_addr                          |
|              | Read Register 2 | src2_addr                          |
|              | Write Register  | dst_addr                           |
|              | RegWrite        | write_en (connected to reg_write ) |
|              | Write data      | data_in                            |
|              |                 | clk (connects to clk in Inputs)    |
|              |                 | rst (connects to rst in Inputs)    |
| Outputs      | Read Data 1     | src1_out                           |
|              | Read Data 2     | src2_out                           |

| ALU          |Figure 4.17      | Digital                            |
|--------------|-----------------|------------------------------------|
|              | ALU             | alu                                |
| Inputs       | Top Input       | A                                  |
|              | Bottom Input    | B                                  |
|              | ALU Control     | alu_control                        |
| Outputs      | ALU Result      | result                             |
|              | Zero            | zero                               |

| ALU Control  |Figure 4.17      | Digital                            |
|--------------|-----------------|------------------------------------|
|              | ALU Control     | alu_control                        |
| Inputs       | ALUOp           | alu_op                             |
|              | Instruction[5-0]| funct                              |
| Outputs      | To ALU          | alu_control                        |

|Control Unit  |Figure 4.17         | Digital                         |
|--------------|--------------------|---------------------------------|
|              | Control            | control_unit                    |
| Inputs       | Instruction[31-26] | instr_op                        |
| Outputs      | RegDst             | reg_dst                         |
|              | Branch             | branch                          |
|              | MemRead            | mem_read                        |
|              | MemtoReg           | mem_to_reg                      |
|              | ALUOp              | alu_op                          |
|              | MemWrite           | mem_write                       |
|              | ALUSrc             | alu_src                         |
|              | RegWrite           | reg_write                       |

|Branch Address Adder|Figure 4.17        | Digital                    |
|--------------------|-------------------|----------------------------|
|                    |Add                | alu                        |
| Inputs             |Upper Input        | A                          |
|                    |Lower Input        | B                          |
|                    |                   | alu_control (set to 2)     |
| Outputs            |Add result         | result                     |
|                    |                   | zero (unconnected)         |

|PC Adder      |Figure 4.17        | Digital                          |
|--------------|-------------------|----------------------------------|
|              |Add                | alu                              |
| Inputs       |Upper Input        | A                                |
|              |Lower Input        | B (set to 4)                     |
|              |                   | alu_control (set to 2)           |
| Outputs      |Add result         | result                           |
|              |                   | zero (unconnected)               |

### Step 1: 

Count up the PC and check that each instruction is correct (`instr_opcode`, `reg1_addr`, `reg2_addr`, `write_reg_addr`)

Modules: 
- Instruction memory* ([`cpumemory.v`](./cpumemory.v))
- PC Register ([`gen_register.v`](./gen_register.v))
- PC adder (optional)

### Step 2:
Verify that the control signals are still correct on the `controlUnit` from the previous lab. Verify that you can read values from the registers (at this point they will most likely be all 0’s). You should now be able to get defined values for all debug signals (including `reg1_data`, `reg2_data`, `write_reg_data`). The data values will most likely be all 0’s since no data manipulation is being done yet.

### Step 3:

Add the `aluControlUnit` from the previous lab as well as the ALU. There won’t be any change in the debug signals yet, but verify that the ALU output is defined. 

### Step 4:
Connect the Data Memory* to the ALU and the CPU registers. At this point your data signals (reg1_data, reg2_data, write_reg_data) should be correct for all non-branch instructions. 

* Data and Instruction memory are unified for our processor. The CPU_memory module is a dual-port memory unit that allows simultaneous reads of instructions as well as a read/write of data through separate ports. In step 1 you will only have the instruction ports connected, now you’ll connect the rest of them.

### Step 5:
Add the modules for the branching hardware. This may involve breaking some connections from step 1 to insert the proper hardware for branching. You should not have any undefined signal before this step, so it shouldn’t be too difficult to trace down any introduced high Z or undefined signals. 

## Deliverables

For the turn-in of this lab, you should have a working **single-cycle datapath**. The true inputs to the top module ([`processor.v`](./processor.v)) are only a `clk`, and `rst` signals, although you will need to have the debug signals correctly connected as well. The datapath should be programmed by a “`.coe`” file that holds MIPS assembly instructions. This file is a paramter to the top module, but defaults to “`init.coe`”.

For this lab, you are not required to build all the datapath components (in black in the image above) but you are required to connect them together in the datapath template provided ([`processor.v`](./processor.v)). You can connect this datapath and your aluControlUnit.v and controlUnit.v from Lab 04 in this file, however a working implementation is provided. All of the files are in this GitHub repository. If you need more functionality you will have to build the components yourself. To use the given components you only need to copy the given Verilog files into your project. By default, the architecture's memory loads data from an “`init.coe`” file. The programming occurs when the rst signal is held high. A sample init.coe file is given but does not fully test the datapath. You will have to extend it. For convenience, the assembly for the `init.coe` file can be found here.  The last instruction of the program is a `lw` to load the final value from memory into register `$t0` and is used to verify correct functionality in the test bench (see below). If you add a similar line to your own program it will make testing easier. .

### Producing the Waveform

Once you've synthesized the code for the test-bench modules, you can run
the test-bench simulation script to make sure all the tests pass. This simluation run should
produce the code to make a waveform. Use techniques you learned in the first lab to produce a
waveform for this lab and save it as a PNG. Once again, I've provided a .gtkw.

### The Lab Report

Finally, create a file called REPORT.md and use GitHub markdown to write your lab report. This lab
report will again be short, and comprised of two sections. The first section is a description of 
each test case. Use this section to discuss what changes you made in your tests from the prelab
until this final report. The second section should include your waveform. 

## Submission:

Each student **must** turn in their repository from GitHub to Gradescope. The contents of which should be:
- A REPORT.md file with your name and email address, and the content described above
- All Verilog file(s) used in this lab (implementation and test benches).

**If your file does not synthesize or simulate properly, you will receive a 0 on the lab.**
