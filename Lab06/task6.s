#int main(int n, int k){
#    if (k == 1) 
#        y=F1(n,k);
#    else if (n > k) 
#        y= F2(n);
#    else 
#        y= F3(n);    
#}
#int F1 (int x,int z){
#   return (x2 + z2);
#}
##int F2 (int z){
#   return (z3);
#}
#int F3 (int w){
#   return (w+5);
#}

.text
main:
    li a0, 5 # n
    li a1, 7 # k
    
    li s0, 1
    
    beq a1, s0, callF1
    bgt a0, a1, callF2
    jal ra, F3
    j exit
    callF1:
        jal ra, F1
        j exit
    callF2:
        jal ra, F2
        j exit
    
F1:
    mul t0, a0, a0 # x2
    mul t1, a1, a1 # z2
    add a0, t0, t1
    ret

F2:
    mul t0, a0, a0 # a^2
    mul a0, t0, a0 # a^2 * a = a^3
    ret
 
F3:
    addi a0, a0, 5
    ret

exit:
