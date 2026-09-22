.data
.text
.globl main
    addi	s0,	s0,	4		      
	addi	s1,	s1,	6
	beq	s0,	s1,	Fin	
True:	
	add	s2,	s1,	s0	
	j	end
Fin:
	sub	s2,	s1,	s0	
end:
