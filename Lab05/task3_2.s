	addi s0, s0, 4 # loads value '4' in register s0
	addi s1, s1, 4 # loads value '4' in s1
	beq s0, s1, Fin # if (s0 == s1) goto Fin else goto True;
True: # Start of True block
	add s2, s1, s0 # add s1 and s0 and store in s2. s2 = s1 + s0
	j end # branch to End block (end of code) regardless of everything
Fin: # Start of Fin block
	sub s2, s1, s0 # subtraction: s2 = s1 - s0
End: # End of code