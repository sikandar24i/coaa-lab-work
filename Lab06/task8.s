#int main(){
#   y=fib(n);
#}
#int fib(int n)
#{ 
#int a=0,b=1,c=i
##if(n==0)
#return a;
##else 	{
#	for(i=2;i<=n;i++)
#	{
#		c=a+b;
#		a=b;
#		b=c;
#	}
#return b;
#}}

.text
.globl main
main:
    li a0, 10 #n
    jal ra, fib
    
    j exit
fib:
    li t0, 0 # a
    li t1, 1 # b
    li t2, 0 # c
    li t3, 2 # i
    
    bne a0, x0, Loopstart
    li a0, 1
    ret
    Loopstart:
        bgt t3, a0, Loopend
        add t2, t0, t1
        mv t0, t1
        mv t1, t2
        addi t3, t3, 1
        j Loopstart
    Loopend:
    ret

exit: