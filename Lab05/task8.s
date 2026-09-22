.data
.text

.globl main
    li s0, 0 # counter
    li s1, 0 # x
    li s3, 3
    li s4, 2
    for1:
        bge s1, s3, end1
        li s2, 0 # y
        for2:
            bge s2, s4, end2
            add s0, s1, s2
            addi, s2, s2, 1
            j for2
        end2:
        addi s1, s1, 1
        j for1
    end1: