.text
.data

.globl main
    addi s0, x0, 5 # A
    addi s1, x0, 4 # B
    add s2, s0, s1 # C = A + B
    sub s3, s0, s1 # D = A - B
    mul s4, s0, s1 # E = A * B
    mul s5, s0, s0 # F = A ^ 2
    
    li a7, 93
    li a0, 0
    ecall
