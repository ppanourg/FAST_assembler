###########################
## CSE141L - ISA Assembler
## Peter Panourgias
## Mayreni Abajian
###########################

import sys, re

def get_opcode(op):
	''' Mapping of opcode to machine code '''
	op = op.lower()

	if   op == 'add'  : return ('r', '0000')
	elif op == 'addi' : return ('i', '0001')
	elif op == 'sub'  : return ('r', '0010')
	elif op == 'sllrr': return ('rother', '0011')
	elif op == 'or'   : return ('r', '0100')
	elif op == 'and'  : return ('r', '0101')
	elif op == 'sll'  : return ('r', '0110')
	elif op == 'srl'  : return ('r', '0111')
	elif op == 'lb'   : return ('rmem', '1000')
	elif op == 'sb'   : return ('rmem', '1001')
	elif op == 'bne'  : return ('r', '1010')
	elif op == 'put'  : return ('i', '1011')
	elif op == 'mov'  : return ('rother', '1100')
	elif op == 'halt' : return ('h', '1101')
	elif op == 'srlrr': return ('rother', '1110')
	elif op == 'addo' : return ('r', '1111')

	return None

def getReg(reg):
	''' Mapping of registers to machine code '''
	reg = reg.lower().strip(',')

	if   reg == '$r0': return '00'
	elif reg == '$r1': return '01'
	elif reg == '$r2': return '10'
	elif reg == '$r3': return '11'
	elif reg == '0'  : return '0'
	elif reg == '1'  : return '1'

	return '0'

def main():
	if len(sys.argv) == 1:
		print("USE: python FASTassembler.py <path_to_assembly_file>")
		return

	file = open(sys.argv[1], 'r')

	if file == None:
		print("File does not exist!")
		return

	for line in file:
		machine_code = ''

		# format the input
		
		line = re.findall(r"\$[r][0-3]|[\w]+|\#.*", line)

		l = len(line)

		if (l > 1) or (l == 1 and line[0].lower() == 'halt') :
			opcode = get_opcode(line[0])

			# if the op is not a valid instruction,
			# treat it like a comment
			if opcode == None: continue

			machine_code += opcode[1] + '_'

			inst_type = opcode[0]

			# handle r-types, note the 2 subtypes
			if inst_type == 'r':
				machine_code += getReg(line[1])
				machine_code += getReg(line[2])
				machine_code += getReg(line[3])

			elif inst_type == 'rmem':
				machine_code += getReg(line[1]) + '00'
				machine_code += getReg(line[2])

			elif inst_type == 'rother':
				machine_code += getReg(line[1])
				machine_code += getReg(line[2]) + '0'

			elif inst_type == 'i':
				imm = int(line[1].strip(','))

				# convert the immediate to bits and append to the machine code
				for i in range(3,-1,-1):
					if ( (imm >> i) & 1 ) == 1:
						machine_code += '1'
					else:
						machine_code += '0'

				machine_code += getReg(line[2])

			# halt instructions
			elif inst_type == 'h':
				machine_code += '00000'

			machine_code += '  // '

			for chunk in line:
				machine_code += chunk + ' '

			print machine_code

if __name__ == "__main__":
	main()