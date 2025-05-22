#lab 4 report
**name:** Isaac Lee
**email:** ilee002@ucr.edu

Part1:
- I ran into extreme difficulty tracing the wires to the correct connections, this took several days of trial and frusturating error. After much debugging, reading, and reaching out for help I was able to get a connection that finally did not produce an error.

Part2:

and $t0, $t1, $t2

    Type: R-type
    Opcode: 0 (0x00)
    Funct: 36 (0x24)
    rs (source register $t1): 9 (00101)
    rt (source register $t2): 10 (00110)
    rd (destination register $t0): 8 (00100)
    shamt (shift amount): 0 (00000)
    Binary: 000000 00101 00110 00100 00000 100100
    Hex: 0x012A4024

addi $t3, $t4, 123

    Type: I-type
    Opcode: 8 (0x08)
    rs (source register $t4): 12 (01100)
    rt (destination register $t3): 11 (01011)
    immediate: 123 (decimal) = 0000000001111011 (binary 16-bit)
    Binary: 001000 01100 01011 0000000001111011
    Hex: 0x218B007B

lw $t5, 135($t1)

    Type: I-type
    Opcode: 35 (0x23)
    rs (base address register $t1): 9 (00101)
    rt (destination register $t5): 13 (01101)
    immediate (offset): 135 (decimal) = 0000000010000111 (binary 16-bit)
    Binary: 100011 00101 01101 0000000010000111
    Hex: 0x8CAd0087 

sw $t3, 136($t1)

    Type: I-type
    Opcode: 43 (0x2B)
    rs (base address register $t1): 9 (00101)
    rt (source register $t3): 11 (01011)
    immediate (offset): 136 (decimal) = 0000000010001000 (binary 16-bit)
    Binary: 101011 00101 01011 0000000010001000
    Hex: 0xACAB0088

beq $t3, $zero, -10

    Type: I-type
    Opcode: 4 (0x04)
    rs (source register $t3): 11 (01011)
    rt (source register $zero): 0 (00000)
    immediate (offset in words, relative to PC+4): -10 (decimal)
        10 decimal = 0000000000001010
        -10 decimal (2's comp): 1111111111110110 (binary 16-bit)
    Binary: 000100 01011 00000 1111111111110110
    Hex: 0x1160FFF6    


    lw $v0, 31($zero)
    op=100011 rs=00000 rt=00010 imm=0000 0000 0001 1111
    binary: 100011 00000 00010 0000000000011111
    hex: 0x8C02001F

    add $v1, $v0, $v0	
    op=000000 rs=00010 rt=00010 rd=00011 shamt=00000 funct=100000	
    binary: 000000 00010 00010 00011 00000 100000	
    hex: 0x00421820

    sw $v1,132($zero)	
    op=101011 rs=00000 rt=00011 imm=0000 0000 1000 0100	
    binary: 101011 00000 00011 0000000010000100	
    hex: 0xAC030084

    sub $a0, $v1, $v0	
    op=000000 rs=00011 rt=00010 rd=00100 shamt=00000 funct=100010
    binary:000000 00011 00010 00100 00000 100010	
    hex: 0x00622022

    addi $a1, $v1, 12	
    op=001000 rs=00011 rt=00101 imm=0000 0000 0000 1100
    binary: 001000 00011 00101 0000000000001100
    hex: 0x2065000C

    and $a2, $a1, $v1	
    op=000000 rs=00101 rt=00011 rd=00110 shamt=00000 funct=100100	
    binary: 000000 00101 00011 00110 00000 100100	
    hex: 0x00A33024

    or $a3, $a2, $v0	
    op=000000 rs=00110 rt=00010 rd=00111 shamt=00000 funct=100101	
    binary: 000000 00110 00010 00111 00000 100101	
    hex: 0x00C2382

    nor $t0, $a2, $v0	
    op=000000 rs=00110 rt=00010 rd=01000 shamt=00000 funct=100111	
    binary: 000000 00110 00010 01000 00000 100111	
    hex: 0x00C24027

    slt $a2, $a1, $a0	
    op=000000 rs=00101 rt=00100 rd=00110 shamt=00000 funct=101010	
    binary: 000000 00101 00100 00110 00000 101010	
    hex: 0x00A4302A

    beq $a2, $zero, -8	
    op=000100 rs=00110 rt=00000 imm=1111 1111 1111 1000 (–8)	
    binary: 000100 00110 00000 1111111111111000	
    hex: 0x10C0FFF8

    lw $t0,132($zero)	
    =100011 rs=00000 rt=01000 imm=0000 0000 1000 0100	
    binary:100011 00000 01000 0000000010000100	
    hex: 0x8C080084