.data
table: .word 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
.text
.globl main
 main:
    la a1, table
    
    lw s0, 0(a1)
    lw s1, 4(a1)
    lw s2, 8(a1)
    lw s3, 12(a1)
    lw s4, 16(a1)
    lw s5, 20(a1)
    lw s6, 24(a1)
    lw s7, 28(a1)
    lw s8, 32(a1)
    lw s9, 36(a1)
    
    li a7, 93
    li a0, 10
    ecall
