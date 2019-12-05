#!/bin/bash

PROGRAM_MEMORY_FILE_NAME=$1
IFS=,
read -a MEMORY < $PROGRAM_MEMORY_FILE_NAME
unset IFS


function DEBUG() {
	echo "$1" >&2
}
function DEBUGF() {
	printf "$@" >&2
	echo >&2
}

DEBUGF "INITIAL Memory:\n%s" "${MEMORY[*]}"

POS=0
RUN=1

INSTRUCTION_LENGTHS=(
	[1]=4
	[2]=4
	[3]=2
	[4]=2
	[99]=1
)

while [[ RUN -gt 0 ]]; do
	# UNPACK INSTRUCTION
	PARAMETER_MODES_AND_OPCODE=${MEMORY[POS]}
	OPCODE=$((PARAMETER_MODES_AND_OPCODE % 100))
	PARAMETER_MODES_STRING=$((PARAMETER_MODES_AND_OPCODE / 100))
	INSTRUCTION_LENGTH=${INSTRUCTION_LENGTHS[OPCODE]}
	NUM_PARAMETERS=$((INSTRUCTION_LENGTH - 1))
	# DEBUGF '[%6d] %6d (%1d)' "$POS" "$PARAMETER_MODES_AND_OPCODE" "$INSTRUCTION_LENGTH"
	MODES=()
	PARAMETERS_RAW=()
	PARAMETERS=()
	for (( i=0; i<$NUM_PARAMETERS; i++ )); do
		if [[ $i -ge ${#PARAMETER_MODES_STRING} ]]; then
			MODES[$i]=0
		else
			MODES[$i]=${PARAMETER_MODES_STRING:$((${#PARAMETER_MODES_STRING}-1-i)):1}
		fi
		PARAMETERS_RAW[$i]=${MEMORY[$((POS+1+i))]}
		# DEBUG "MODES[$i]="${MODES[$i]}
		if [[ ${MODES[i]} -eq 0 ]]; then
			# Follow indirection
			PARAMETERS[$i]=${MEMORY[${PARAMETERS_RAW[i]}]}
		else
			# Use raw (literal) value
			PARAMETERS[$i]=${PARAMETERS_RAW[i]}
		fi
	done
	# TRACE
	# DEBUGF '[%6d] %6d [%s] (%s)' "$POS" "$PARAMETER_MODES_AND_OPCODE" "${PARAMETERS_RAW[*]}" "${PARAMETERS[*]}"
	case $OPCODE in
		1)
			# Add-Store
			# INPUT: None
			# OUTPUT: None
			AUGEND=${PARAMETERS[0]}
			ADDEND=${PARAMETERS[1]}
			DST=${PARAMETERS_RAW[2]}
			((SUM=AUGEND+ADDEND))
			# DEBUG "(Add-Store): [$DST]=${AUGEND}+${ADDEND}=$SUM"
			MEMORY[$DST]=$SUM
			;;
		2)
			# Multiply-Store
			# INPUT: None
			# OUTPUT: None
			MULTIPLICAND=${PARAMETERS[0]}
			MULTIPLIER=${PARAMETERS[1]}
			DST=${PARAMETERS_RAW[2]}
			((PRODUCT=MULTIPLICAND*MULTIPLIER))
			# DEBUG "(Multiply-Store): [$DST]=${MULTIPLICAND}*${MULTIPLIER}=$PRODUCT"
			MEMORY[$DST]=$PRODUCT
			;;
		3)
			# STORE
			# INPUT: Value
			# OUTPUT: None
			DST=${PARAMETERS_RAW[0]}
			read -p "INPUT: " INPUT
			# DEBUG "(Store): [$DST]=$INPUT"
			MEMORY[$DST]=$INPUT
			;;
		4)
			# OUTPUT
			# *SRC
			# INPUT: None
			# OUTPUT: Value
			SRC=${PARAMETERS[0]}
			OUTPUT=$SRC
			# DEBUG "(Output): $OUTPUT"
			echo OUTPUT: $OUTPUT
			;;
		99)
			# END OF PROGRAM
			# (No Parameters, No Input, No Output)
			# DEBUG "(End-Of-Program)."
			RUN=0
			;;
		default)
			echo "ERROR" >&2
			exit 1
			# error
			;;
	esac
	((POS=POS+INSTRUCTION_LENGTH))
done
