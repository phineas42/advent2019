#!/bin/bash

PROGRAM_MEMORY_FILE_NAME=
STDOUT_PROMPT=0
while [[ ${#@} -gt 0 ]]; do
	case "$1" in
		--stdout-prompt)
			STDOUT_PROMPT=1
			shift
			;;
		--signal)
			NOTIFY_PID=$2
			echo will notify $NOTIFY_PID >&2
			shift 2
			;;
		*)
			if [[ -z "$PROGRAM_MEMORY_FILE_NAME" ]]; then
				PROGRAM_MEMORY_FILE_NAME=$1
				shift
			else
				break
			fi
			;;
	esac
done
INITIAL_INPUTS=($@)
IFS=,
read -a MEMORY < $PROGRAM_MEMORY_FILE_NAME
unset IFS


function DEBUGF() {
	FORMAT=$1
	shift
	# printf "Phase:%2d $FORMAT\n" "$PHASE" "$@" >&2
}
function DEBUG() {
	DEBUGF "%s" "$@"
}

# DEBUGF "INITIAL Memory:\n%s" "${MEMORY[*]}"

POS=0
RELATIVE_BASE=0
RUN=1
PHASE=0
# LENGTH DESCRIPTION
INSTRUCTION_INFO=(
	[1]="4 ADD"
	[2]="4 MUL"
	[3]="2 INP"
	[4]="2 OUT"
	[5]="3 JIT"
	[6]="3 JIF"
	[7]="4 LES"
	[8]="4 EQU"
	[9]="2 ARB"
	[99]="1 HLT"
)

while [[ RUN -gt 0 ]]; do
	# UNPACK INSTRUCTION
	PARAMETER_MODES_AND_OPCODE=${MEMORY[POS]}
	OPCODE=$((PARAMETER_MODES_AND_OPCODE % 100))
	PARAMETER_MODES_STRING=$((PARAMETER_MODES_AND_OPCODE / 100))
	INSTRUCTION_METADATA=(${INSTRUCTION_INFO[OPCODE]})
	INSTRUCTION_LENGTH=${INSTRUCTION_METADATA[0]}
	NUM_PARAMETERS=$((INSTRUCTION_LENGTH - 1))
	printf -v DEBUG_MSG 'POS:%6d  RB:%6d  OpCode:%6d  NumParms:%1d (' "$POS" "$RELATIVE_BASE" "$PARAMETER_MODES_AND_OPCODE" "$((INSTRUCTION_LENGTH-1))"
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
		case ${MODES[i]} in
			1)
				# Use raw (literal) value
				PARAMETERS[$i]=${PARAMETERS_RAW[i]}
				DEBUG_MSG="$DEBUG_MSG L:${PARAMETERS[$i]}"
				;;
			2)
				# Use relative base
				PARAMETERS[$i]=${MEMORY[$((RELATIVE_BASE+${PARAMETERS_RAW[i]}))]}
				ADDRESS[$i]=$((RELATIVE_BASE+${PARAMETERS_RAW[i]}))
				DEBUG_MSG="$DEBUG_MSG R:[$RELATIVE_BASE+${PARAMETERS_RAW[i]}]:${PARAMETERS[i]}"
				;;
			*)
				# Follow indirection
				PARAMETERS[$i]=${MEMORY[${PARAMETERS_RAW[i]}]}
				ADDRESS[$i]=${PARAMETERS_RAW[i]}
				DEBUG_MSG="$DEBUG_MSG I:[${PARAMETERS_RAW[i]}]:${PARAMETERS[i]}"
				;;
		esac
	done
	DEBUG_MSG="$DEBUG_MSG ) OP:"${INSTRUCTION_METADATA[1]}
	DEBUG "$DEBUG_MSG"
	# TRACE
	DEBUGF '[%6d] %6d [%s] (%s)' "$POS" "$PARAMETER_MODES_AND_OPCODE" "${PARAMETERS_RAW[*]}" "${PARAMETERS[*]}"
	case $OPCODE in
		1)
			# Add-Store
			# INPUT: None
			# OUTPUT: None
			AUGEND=${PARAMETERS[0]}
			ADDEND=${PARAMETERS[1]}
			DST=${ADDRESS[2]}
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
			DST=${ADDRESS[2]}
			((PRODUCT=MULTIPLICAND*MULTIPLIER))
			# DEBUG "(Multiply-Store): [$DST]=${MULTIPLICAND}*${MULTIPLIER}=$PRODUCT"
			MEMORY[$DST]=$PRODUCT
			;;
		3)
			# STORE
			# INPUT: Value
			# OUTPUT: None
			DST=${ADDRESS[0]}
			if [[ ${#INITIAL_INPUTS[@]} -gt 0 ]]; then
				INPUT=${INITIAL_INPUTS[0]}
				INITIAL_INPUTS=("${INITIAL_INPUTS[@]:1}")
			else
				if [[ -n $NOTIFY_PID ]]; then
					echo SIGNAL >&2
					kill -SIGUSR1 $NOTIFY_PID
					read INPUT
				elif [[ $STDOUT_PROMPT -eq 1 ]]; then
					echo INPUT:
					read INPUT
				else
					read -p "INPUT: " INPUT
				fi
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
			DEBUG "OUTPUT $OUTPUT"
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
			DST=${ADDRESS[2]}
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
			DST=${ADDRESS[2]}
			if [[ $ARG1 -eq $ARG2 ]]; then
				RESULT=1
			else
				RESULT=0
			fi
			# DEBUG "(equals): ..."
			MEMORY[$DST]=$RESULT
			;;
		9)
			# Adjust relative base
			ARG1=${PARAMETERS[0]}
			((RELATIVE_BASE=RELATIVE_BASE+ARG1))
			# DEBUG "(relbase): ..."
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
