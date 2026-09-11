.text
.data

.globl main
    addi s0, x0, 5 # A
    addi s1, x0, 4 # B
    add s2, s0, s1 # C = A + B
    sub s3, s0, s1 # D = A - B
    mul s4, s0, s1 # E = A * B
    mul s5, s0, s0 # F = A ^ 2
    
    sub s6, s0, s2 # A - C
    add s7, s3, s4 # D + E
    mul s8, s7, s5 # (D+E)*F
    add s9, s6, s8 # m 
    
    li a7, 93
    li a0, 0
    ecall
