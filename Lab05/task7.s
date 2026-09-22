#   int num[10]; 
#   void main(){
#   i=0;
#   while (i < 5) 
#       num[i] = i+5;
#   }

.data
num: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.text
.globl main
main:
    li s2, 0 # i
    li s3, 5 # max
WHILE:
    bge s2, s3, ENDWHILE
        addi s4, s2, 5 # value to be stored
        la s5, num # go to the target location eg num[i]
        li t1, 4
        mul s6, s2, t1 # s6 = s2*t1 = i*4: to calculate the offset
        add s5, s5, s6 # actual offset
        sw s4, 0(s5) # num[i] = i + 5
        j WHILE
ENDWHILE: