#!/bin/bash

PROGRAM_MEMORY_FILE_NAME=$1
shift
INITIAL_INPUTS=($@)
IFS=,
read -a MEMORY < $PROGRAM_MEMORY_FILE_NAME
unset IFS


function DEBUG() {
	echo "$PHASE $1" >&2
}
function DEBUGF() {
	printf "$PHASE $@" >&2
	echo >&2
}

# DEBUGF "INITIAL Memory:\n%s" "${MEMORY[*]}"

POS=0
RUN=1
PHASE=
INSTRUCTION_LENGTHS=(
	[1]=4
	[2]=4
	[3]=2
	[4]=2
	[5]=3
	[6]=3
	[7]=4
	[8]=4
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
			if [[ ${#INITIAL_INPUTS[@]} -gt 0 ]]; then
				INPUT=${INITIAL_INPUTS[0]}
				INITIAL_INPUTS=("${INITIAL_INPUTS[@]:1}")
			else
				read INPUT
			fi
			if [[ -z $PHASE ]]; then
				PHASE=$INPUT
			fi
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
			echo $OUTPUT
			;;
		5)
			# JUMP-IF-TRUE
			CONDITIONAL=${PARAMETERS[0]}
			TARGET=${PARAMETERS[1]}
			# DEBUG "(Jump-if-true): ..."
			if [[ $CONDITIONAL -ne 0 ]]; then
				((POS=TARGET))
				continue
			fi
			;;
		6)
			# JUMP-IF-FALSE
			CONDITIONAL=${PARAMETERS[0]}
			TARGET=${PARAMETERS[1]}
			# DEBUG "(Jump-if-false): ..."
			if [[ $CONDITIONAL -eq 0 ]]; then
				((POS=TARGET))
				continue
			fi
			;;
		7)
			# LESS-THAN
			ARG1=${PARAMETERS[0]}
			ARG2=${PARAMETERS[1]}
			DST=${PARAMETERS_RAW[2]}
			if [[ $ARG1 -lt $ARG2 ]]; then
				RESULT=1
			else
				RESULT=0
			fi
			# DEBUG "(less-than): ..."
			MEMORY[$DST]=$RESULT
			;;
		8)
			# EQUALS
			ARG1=${PARAMETERS[0]}
			ARG2=${PARAMETERS[1]}
			DST=${PARAMETERS_RAW[2]}
			if [[ $ARG1 -eq $ARG2 ]]; then
				RESULT=1
			else
				RESULT=0
			fi
			# DEBUG "(equals): ..."
			MEMORY[$DST]=$RESULT
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
