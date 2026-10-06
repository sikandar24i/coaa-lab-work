addi s0, zero, 5 # s0 = 5
addi t1, zero, 10 # t1 = 10
addi t0, zero,15 # t0 = 15
addi sp, sp, -12 # allocates three bytes in stack
sw   s0, 0(sp) # save s0 (5)  at stack memory address sp + 0
sw   t0, 4(sp) # save t0 (15) at stack memory address sp + 4
sw   t1, 8(sp) # save t1 (10) at stack memory address sp + 8
lw   t4, 8(sp) # load value from sp + 8 (10) into t4
lw   t2, 4(sp) # load value from sp + 4 (15) into t2
lw   t3, 0(sp) # load value from sp + 0 (5)  into t3
addi sp, sp, 12 # free the stack