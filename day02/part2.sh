#!/bin/bash

NOUN=$1
VERB=$2
IFS=,
read -a MEMORY
unset IFS

echo INITIAL Memory:
echo ${MEMORY[@]}

MEMORY[1]=$NOUN
MEMORY[2]=$VERB
echo INPUT Memory:
echo ${MEMORY[@]}

POS=0
RUN=1

while [[ RUN -gt 0 ]]; do
	OPCODE=${MEMORY[POS]}
	((REG1I=POS+1))
	((REG2I=POS+2))
	((REG3I=POS+3))
	REG1A=${MEMORY[REG1I]}
	REG2A=${MEMORY[REG2I]}
	REG3A=${MEMORY[REG3I]}
	REG1V=${MEMORY[REG1A]}
	REG2V=${MEMORY[REG2A]}
	case $OPCODE in
		1)
			((SUM=REG1V+REG2V))
			MEMORY[$REG3A]=$SUM
			;;
		2)
			((PRODUCT=REG1V*REG2V))
			MEMORY[$REG3A]=$PRODUCT
			;;
		99)
			echo "END OF PROGRAM"
			RUN=0
			# end of program
			;;
		default)
			echo "ERROR"
			exit 1
			# error
			;;
	esac
	((POS=POS+4))
done
echo ${MEMORY[@]}
echo ${MEMORY[0]}

