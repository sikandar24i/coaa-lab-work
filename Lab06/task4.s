.data
.text
.globl main
main:
    li a0, 4
    
    jal ra, AreaFinder
    mv s0, a0 # store a0 in s0. s0 is area
    
    jal ra, PerimeterFinder
    # a0 now has the perimeter
    mv s1, a0
    
    j end
    
AreaFinder:
    mul a0, a0, a0
    ret

PerimeterFinder:
    li t0, 4
    mul a0, a0, t0
    ret
    
end: