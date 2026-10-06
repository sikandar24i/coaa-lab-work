.text
main:
    li a3, 5
    
    jal ra, EqSolver
    mv s0, a0
    
    j end

EqSolver:
    # x^3+5x^2+6x
    mul t0, a3, a3
    mul t0, t0, a3
    addi t5, x0, 5
    addi t6, x0, 6
    mul t1, a3, a3
    mul t1, t1, t5
    mul t2, t6, a3
    add t3, t0, t1
    add a0, t3, t2 
end: