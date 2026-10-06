#int main(int n, int k){
#    if (k == 0) 
#        y=fun1(n);
#    else if (n == k) 
#        y= fun2(n);
#    else 
#        y= fun3(n);    
#}
#int fun1 (int x){
#   return (x2);
#}
#int fun2 (int z){
#   return (z3);
#}
#int fun3 (int w){
#   return (w+1);
#}

.text
.globl main
main:
    li a0, 5 #n
    li a1, 9 #k
    beq a1, zero, callfun1
    beq a0, a1, callfun2
    jal ra, fun3
    j exit
    callfun1:
        jal ra, fun1
        j exit
    callfun2:
        jal ra, fun2
        j exit
fun1:
    mul a0, a0, a0
    ret
fun2:
    mul t0, a0, a0
    mul a0, t0, a0
    ret
fun3:
    addi a0, a0, 1
    ret
exit: