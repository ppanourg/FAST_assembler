int2flt: 
		put 1, 0		# $r0 = 1
		lb $r0, 0		# $r0 = M[1]
		put 2, 1		# $r1 = 2
		lb $r1, 1		# $r1 = M[2]
		add $r0, $r1, 0	# $r0 = $r0 + $r1
		put 0, 1		# $r1 = 0
		mov $r3, $r1	# $r3 = $r1
		put 5, 1		# $r1 = 5
		bne $r0, $r3, 1	# if($r0 == 0) return 0 else move to just past halt
		put 5, 1
		sb $r1, 0 	# update mem locations 5 & 6 with 0 and halt
  		put 6, 1
		sb $r1, 0
		halt
	
	end_if_1:
		put 1, 0		# $r0 = 1        # retrieve the MSB from mem and store
		lb $r0, 0		# $r0 = M[1]   
		put 7, 1		# $r1 = 7
		srl $r0, $r1, 0	# $r0 = $r0 >> 7
		sb $r1, 0		# M[7] = signbit (1 or 0)
		
		put 14, 0       # $r0 = 14   # set Exp to 29 and store
		put 1, 1        # $r1 = 1
		sll $r0, $r1, 0	# $r0 = $r0 << 1
		add $r0, $r1, 0	# $r0 = $r0 + 1
		put 8, 1		# $r1 = 8
		sb $r1, 0		# M[8] = exp = 29
		
		put 1, 0		#copy man 1 and 2 to mem 9 and 10
		lb $r0, 0
		put 9, 1
		sb $r1, 0
		put 2, 0
		lb $r0, 0
		put 10, 1
		sb $r1, 0
				
	loop:				# retrieve bit 14 and check value
		put 1, 0		# $r0 = 1		
		lb $r0, 0		# $r0 = M[1]
		put 1, 1		# $r1 = 1
		sll $r0, $r1, 0	# $r0 = $r0 << 1
		put 7, 1		# $r1 = 7
		srl $r0, $r1, 0	# $r0 = $r0 >> 7
		mov $r2, $r0	# $r2 = $r0
		put 1, 0	
		put 5, 1
		sll $r0, $r1, 0
		put 1, 1
		add $r0, $r1, 0 # $r0 = addr = 33
 		put 0, 1		# $r1 = 0
		bne $r2, $r1, 0	# if ($r2 != 0) branch to endLoop (if bit 14 = 1)
		 
		put 8, 0		# $r0 = 8  		# decrement exponent
		lb $r0, 0		# $r0 = M[8] = exp
		put 1, 1		# $r1 = 1
		sub $r0, $r1, 0 # $r0 = $r0 - 1
		put 8, 1		# $r1 = 8
		sb $r1, 0		# M[8] = exp-1
		
		put 9, 0		#shift entire int << 1
		lb $r0, 0
		put 10, 1 
		lb $r1, 1
		sllrr $r0, $r1
		
		mov $r2, $r1	# store shifted value back in mem 9, 10
		put 9, 1
		mov $r3, $r1
		mov $r1, $r2
		sb $r3, 1
		put 10, 1
		sb $r1, 0
		
		put 1, 0		# $r0 = 1		# get addr to jump backwards to loop
		put 7, 1		# $r1 = 7
		sll $r0, $r1, 0	# $r0 = $r0 << 7   # $r0 = negative sign bit
		put 11, 1		# $r1 = 11
		mov $r2, $r1	# $r2 = $r1 = 11
		put 2, 1		# $r1 = 2
		sll $r2, $r1, 1	# $r1 = $r2 << 2 
		mov $r2, $r1	# $r2 = $r1	
		put 3, 1		# $r1 = 3
		add $r2, $r1, 1	# $r1 = 47 = jump addr
		add $r0, $r1, 0 # $r0 = -47 (because jumping backwards)
		put 0, 1
		mov $r2, $r1
		put 1, 1
		bne $r2, $r1, 0	# jump to loop

	endLoop:
			
		# man part 1 = m9
		# man part 2 = m10
		
		put 10, 0			# Man0[4] => M[15]
		lb $r0, 0
		put 3, 1
		sll $r0, $r1, 0
		put 7, 1
		srl $r0, $r1, 0
		put 15, 1
		sb $r1, 0
		
		put 10, 0			# R[3] => M[14]
		lb $r0, 0
		put 4, 1
		sll $r0, $r1, 0
		put 7, 1
		srl $r0, $r1, 0
		put 14, 1
		sb $r1, 0

		put 10, 0			# S[2] => M[13]
		lb $r0, 0
		put 5, 1
		sll $r0, $r1, 0
		put 7, 1
		srl $r0, $r1, 0
		put 13, 1
		sb $r1, 0 

		put 10, 0			# S[1] => M[12]
		lb $r0, 0
		put 6, 1
		sll $r0, $r1, 0
		put 7, 1
		srl $r0, $r1, 0
		put 12, 1
		sb $r1, 0
		
		put 10, 0			# S[0]
		lb $r0, 0
		put 7, 1
		sll $r0, $r1, 0
		put 7, 1
		srl $r0, $r1, 0
		mov $r2, $r0	# $r2 = $r0 = S[0]
		
		put 12, 1
		lb $r1, 0		# $r0 = S[1]
		or $r0, $r2, 0
		put 13, 1
		lb $r1, 1		# $r1 = S[2]
		or $r0, $r1, 0
		put 11, 1
		sb $r1, 0		# OR(S[0-2]) => M[11]
		
		put 9, 0		# shift man << 2
		lb $r0, 0
		put 10, 1 
		lb $r1, 1
		sllrr $r0, $r1
		sllrr $r0, $r1

		srlrr $r0, $r1	# shift man >> 6
		srlrr $r0, $r1
		srlrr $r0, $r1
		srlrr $r0, $r1
		srlrr $r0, $r1
		srlrr $r0, $r1
		
		mov $r2, $r1	# store shifted value back in mem 9, 10
		put 9, 1
		mov $r3, $r1
		mov $r1, $r2
		sb $r3, 1
		put 10, 1
		sb $r1, 0
		
	if:					# If Man0 = 0 and (R) = 1 and S = 1, then add 1 to Man0
		put 15, 1
		lb $r1, 0		# $r0 = M[15] = Man0
		mov $r2, $r0	# $r2 = Man0
		put 12, 0
		put 1, 1
		sll $r0, $r1, 0
		add $r0, $r1, 0	# $r0 = addr = 25
		put 0, 1
		bne $r2, $r1, 0 # if Man0 != 0, goto else
		
		put 14, 1
		lb $r1, 0		# $r0 = M[14] = R		
		mov $r2, $r0	# $r2 = R
		put 8, 0
		put 3, 1
		sll $r0, $r1, 0
		put 5, 1
		add $r0, $r1, 0	# $r0 = addr = 69
		put 1, 1
		bne $r2, $r1, 0 # if R != 1, finish
		
		put 11, 1
		lb $r1, 0		# $r0 = M[11] = S
		mov $r2, $r0	# $r2 = S
		put 14, 0
		put 2, 1
		sll $r0, $r1, 0
		put 3, 1
		add $r0, $r1, 0	# $r0 = addr = 59
		put 1, 1
		bne $r2, $r1, 0 # if S != 1, finish
		
		put 0, 1		# $r1 = 0
		mov $r2, $r1	# $r2 = $r1 (= 0)
		put 9, 1		# $r1 = addr = 9
		put 1, 0		# $r0 = 1
		bne $r0, $r2, 1 # jump to rounding
		
	else:				# Else if Man0 == 1 and R = 1 then add 1 to Man0
		put 14, 1
		lb $r1, 0		# $r0 = M[14] = R		
		mov $r2, $r0	# $r2 = $r0
		put 11, 0
		put 2, 1
		sll $r0, $r1, 0
		put 1, 1
		add $r0, $r1, 0 # $r0 = addr = 45
		bne $r2, $r1, 0 # if R != 1, finish
		
	rounding:			# Add 1 to Man0. If this causes ovf, increment exp and right-shift man 
		put 10, 0
		lb $r0, 0
		put 1, 1
		add $r0, $r1, 1	# $r1 = Man0 + 1
		mov $r2, $r1	# $r2 = $r1
		put 1, 1
		addo $r0, $r1, 1
		mov $r3, $r1	# $r3 = $r1 = ovf value
		put 10, 0
		mov $r1, $r2
		sb $r0, 1
		put 15, 0
		put 1, 1
		sll $r0, $r1, 0 # $r0 = addr = 30
		bne $r3, $r1, 0 # if ovf != 1, finish
		
		put 9,1
		lb $r1, 0
		put 4, 1
		or $r0, $r1, 0
		put 1, 1
		add $r0, $r1, 0
		mov $r3, $r0
		put 8, 1
		and $r0, $r1, 1
		mov $r2, $r1
		put 8, 1
		put 13, 0
		bne $r2, $r1, 0	# if no ovf, no_ovf
		
	ovf:				# increment exp and right-shift man
		put 10, 1
		lb $r1, 1
		mov $r0, $r3	
		srlrr $r0, $r1 	# shift man right by 1 bit
		mov $r3, $r0
		put 10, 0
		sb $r0, 1		# M[10] = shifted Man part 2
		
		put 8, 0		# $r0 = 8  		
		lb $r0, 0		# $r0 = M[8] = exp
		put 1, 1		# $r1 = 1
		add $r0, $r1, 0 # $r0 = $r0 + 1 # increment exponent
		put 8, 1		# $r1 = 8
		sb $r1, 0		# M[8] = exp+1
				
	no_ovf:
		put 3, 0
		and $r3, $r0, 0	# hide hidden bit
		put 9, 1
		sb $r1, 0		# store Man part 1 in M[9]
		
	finish:				# Put all elements together: sign bit, exp, man
		put 7, 1
		lb $r1, 0		# $r0 = M[7] = signbit
		sll $r0, $r1, 0	# $r0 = signbit << 7
		put 8, 1
		lb $r1, 1		# $r1 = M[8] = exp	
		mov $r2, $r1	# $r2 = $r1 = exp
		put 2, 1
		sll $r2, $r1, 1 # $r1 = exp << 2
		or $r0, $r1, 0	# $r0 = OR (signbit , exp)
		put 9, 1
		lb $r1, 1		# $r1 = M[9] = MSW of Man
		or $r0, $r1, 0  # $r0 = OR (signbit, exp, man[8-9])
		put 5, 1
		sb $r1, 0		# M[5] = $r0 
		put 10, 1
		lb $r1, 1		# $r1 = M[10] = LSW of Man
		put 6, 0
		sb $r0, 1		# M[6] = $r1
		halt