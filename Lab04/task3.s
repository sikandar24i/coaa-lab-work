.text
.data

.globl main
    li s0, 0xFFF
    li s1, 0xF0F
    
    and s2, s0, s1
    or s3, s0, s1
    xor s4, s0, s1
    
    li a7, 93
    li a0, 0
    ecall
