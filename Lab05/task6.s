.data
.text

.globl main
    addi s0, x0, 0 # counter = 0
    addi s1, x0, 1 # i
    addi s2, x0, 5
for:
    bgt s1, s2, end
    addi s0, s0, 1
    addi s1, s1, 1
    j for
end: