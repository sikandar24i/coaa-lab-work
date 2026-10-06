#int main(){
#   x=EqSolver(a,b);
#}
#int EqSolver (int a, int b){
#   return (a+b)(a-b);
#}

.data
.text
main:
    li a3, 5
    li a4, 7
    
    jal ra, EqSolver
    j end
    
EqSolver:
    add t0, a3, a4
    sub t1, a3, a4
    mul a0, t0, t1
    
    ret
    
end: