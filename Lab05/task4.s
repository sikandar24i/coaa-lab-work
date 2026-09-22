.data
.text

.globl main
    addi s1, x0, 5 # a = 5
    addi s2, x0, 10 # b = 10
    addi s4, x0, 4 # d = 4
    addi s5, x0, 3 # e = 3
    bne s1, s2, NotEqual
Equal:
    sub s3, s4, s5
    j End
NotEqual:
    add s3, s4, s5
End: