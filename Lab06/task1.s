.text
.globl main

main:
    li a0, 1
    li s0, 2500
    jal ra, procedure              # call procedure

    add t1, s0, a0                 # result should be 1003+2500

    li a0, 1                       # setup system call for display (command in a0)
    mv a1, t1                      # data to display in a1
    ecall                          # displays result on console

    li a7, 93
    li a0, 10
    ecall

procedure:
    li t2, 3                       # Use temporary register t2 instead of s0
    li t0, 1000
    add a0, t2, t0
    ret                            # return