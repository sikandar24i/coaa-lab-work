#int main(){
 #  y=fib(n);
#}
#int fib(int n)
#{ 
##if (n==0) 
#return 0; 
##else if (n == 1) 
#return 1; 
##else 
#return fib(n1) + fib(n2); 
#}

.text
.globl main

main:
    li a0, 10
    jal ra, fib
    j exit

fib:
    beq a0, zero, ifzero
    li t0, 1
    beq a0, t0, ifone

    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)
    sw s1, 4(sp)

    mv s0, a0

    addi a0, s0, -1
    jal ra, fib
    mv s1, a0

    addi a0, s0, -2
    jal ra, fib

    add a0, s1, a0

    lw s1, 4(sp)
    lw s0, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

ifzero:
    li a0, 0
    ret

ifone:
    li a0, 1
    ret

exit:
    li a0, 10
    ecall