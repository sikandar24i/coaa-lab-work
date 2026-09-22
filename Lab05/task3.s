	addi	s0,	s0,	4 # Loads the value '4' in s0
	addi	s1,	s1,	6 # Loads the value '6' in s1
	beq	s0,	s1,	Fin # if (s0 == s1) branch to Fin block, in our case 4 == 6 which is false, the True Block will execute.
True: # Start of True block
	add	s2,	s1,	s0 # add the values of s1 and s0 and store in s2. s2 = s1 + s0. s2 = 6 + 4 = 10
	j	end # jump to end regardless of everything
Fin: # Start of Fin block
	sub	s2,	s1,	s0 # Subtract the value of s1 from s0 and store in s2. s0 = s1 - s0
end: #End of the code