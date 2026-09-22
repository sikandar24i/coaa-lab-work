.data
num: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

.text
.globl main
    addi s1, x0, 0
    addi t0, x0, 5
    while:
        bge s1, t0, end
        
    end: