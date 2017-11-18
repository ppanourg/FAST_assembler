import sys

def get_opcode(op):
	op = op.lower()

	if   op == 'add':  return ('r', '0000')
	elif op == 'addi': return ('i', '0001')
	elif op == 'sub':  return ('r', '0010')
	elif op == 'nor':  return ('r', '0011')
	elif op == 'or':   return ('r', '0100')
	elif op == 'and':  return ('r', '0101')
	elif op == 'sll':  return ('r', '0110')
	elif op == 'srl':  return ('r', '0111')
	elif op == 'lb':   return ('r', '1000')
	elif op == 'sb':   return ('r', '1001')
	elif op == 'bne':  return ('r', '1010')
	elif op == 'put':  return ('i', '1011')
	elif op == 'mov':  return ('r', '1100')
	elif op == 'halt': return ('h', '1101')

	return None

def getReg(reg):
	reg = reg.lower().strip(',')

	if   reg == '$r0': return '00'
	elif reg == '$r1': return '01'
	elif reg == '$r2': return '10'
	elif reg == '$r3': return '11'
	elif reg == '0':   return '0'
	elif reg == '1':   return '1'

	return None

def main():
	fname = sys.argv[1] 

	file = open(fname, 'r')

	for line in file:
		machine_code = ''

		line = line.strip('\n').strip('\t').strip(' ')

		line = line.split(' ')

		if len(line) != 0:
			opcode = get_opcode(line[0])

			if opcode == None: continue

			machine_code += opcode[1]







			print machine_code


		


if __name__ == "__main__":
	main()