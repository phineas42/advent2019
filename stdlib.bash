# vi: filetype=bash
# This file should be included, not executed
# Math and utility library for BASH

TIMEFORMAT="%Rs"

function DEBUGF() {
        FORMAT=$1
        shift
        printf "$FORMAT" "$@" >&2
}

function DEBUG() {
        DEBUGF "%s\n" "$@" >&2
}

# __STRINDEX
# Determines the index of a substring within a string
# PRECONDITION: $1 is a string in which to search
#               $2 is a substring to find.
# POSTCONDITION: RES is the index of $2 in $1, or -1 if not found
function __STRINDEX() {
	# Adapted from https://stackoverflow.com/a/5032641	
	local x="${1%%$2*}"
	if [[ "$x" == "$1" ]]; then
		RES=-1
	else
       		RES="${#x}"
	fi
}

# __SORT
# Sorts a list of integers
# PRECONDITION: Argument list $@ consists of at least one integer
# POSTCONDITION: RES is a string, a space-separated list of sorted integers
function __SORT() {
	local LIST i T
	LIST=("$@")
	# bubble sort
	for (( i=1; i<${#LIST[@]}; i++ )); do
		if [[ ${LIST[i]} -lt ${LIST[i-1]} ]]; then
			T=${LIST[i-1]}
			LIST[i-1]=${LIST[i]}
			LIST[i]=$T
			if [[ $i -gt 1 ]]; then
				i=$((i-2))
			fi
		fi
	done
	RES=${LIST[@]}
}

# __UNIQ
# Remove duplicates from a list of integers
# PRECONDITION: Argument list $@ consists of at least one integer.
#               The input list must be sorted (equal values must be adjacent).
# POSTCONDITION: RES is a string, a space-separated unique set of sorted integers.
function __UNIQ() {
	local LIST i T LIST2
	LIST=("$@")
	LIST2=(${LIST[0]})
	for (( i=1; i<${#LIST[@]}; i++ )); do
		if [[ ${LIST[i]} -ne ${LIST[i-1]} ]]; then
			LIST2+=(${LIST[i]})
		fi
	done
	RES=${LIST2[@]}
}

# __ABS
# Computes Absolute value of an integer
# PRECONDITION: $1 is the input integer
# POSTCONDITION: RES is the absolute value of $1
function __ABS() {
        if [[ $1 -lt 0 ]]; then
                RES=$((0-$1))
        else
                RES=$1
        fi
}

# __MIN
# Finds the lowest value of the inputs
# PRECONDITION: Argument list $@ consists of at least one integer.
# POSTCONDITION: RES is the lowest integer from the inputs.
function __MIN() {
	local MIN VAL
	while [[ -z $MIN ]]; do
		MIN=$1
		shift
	done
	for VAL in $@; do
		if [[ $VAL -lt $MIN ]]; then
			MIN=$VAL
		fi
	done
	RES=$MIN
}

# __MAX
# Finds the highest value of the inputs
# PRECONDITION: Argument list $@ consists of at least one integer.
# POSTCONDITION: RES is the highest integer from the inputs.
function __MAX() {
	local MAX VAL
	while [[ -z $MAX ]]; do
		MAX=$1
		shift
	done
	for VAL in $@; do
		if [[ $VAL -gt $MAX ]]; then
			MAX=$VAL
		fi
	done
	RES=$MAX
}

# __PRIMEFACTOR
# Finds the Prime Factorization of an integer N
# PRECONDITION: N==$1 is a positive integer
# POSTCONDITION: RES is a string, a space-separated list of the prime factors of N.
#                1 and N itself are not included in the result.
#                The product of the factors is equal to N.
function __PRIMEFACTOR() {
	local N=$1
	local PRIMEFACTORS=()
	local i
	for (( i=2; i<=N; true )); do
		if [[ $((N%i)) -eq 0 ]]; then
			PRIMEFACTORS+=($i)
			N=$((N/i))
		elif [[ i -eq 2 ]]; then
			i=3
		else
			# Skip even numbers after i==2
			i=$((i+2))
		fi
	done
	RES=${PRIMEFACTORS[@]}
}

# __FACTOR
# Find all factors of an integer N
# PRECONDITION: N==$1 is a positive integer
# POSTCONDITION: RES is a string, a space-separated list of the factors of N.
#                1 and N itself ARE included in the result
function __FACTOR() {
	local N=$1
	local INDENT=$2
	__PRIMEFACTOR $N
	__UNIQ $RES
	local PRIMEFACTORS=$RES
	local OTHERFACTORS=$N
	local NDF
	for F in $PRIMEFACTORS; do
		# ASSERT: F should never equal 1
		if [[ $F -eq $N ]]; then
			continue
		fi
		NDF=$((N/F))
		echo "$INDENT"__FACTOR $NDF
		local TIMEFORMAT="  $TIMEFORMAT"
		time __FACTOR $NDF "$INDENT  "
		OTHERFACTORS="$RES $OTHERFACTORS"
	done
	OTHERFACTORS="1 $OTHERFACTORS"
	__SORT $OTHERFACTORS
	__UNIQ $RES
}

## __GCD
## Find the greatest common divisor of the inputs
## PRECONDITION: Argument list $@ is a list of positive integers
## POSTCONDITION: RES is an integer, the greatest common divisor of $@
#function __GCD() {
#	NUMBERS=($@)
#	NUM_INPUTS=${#NUMBERS[@]}
#	FACTORS_STR=""
#	for N in ${NUMBERS[@]}; do
#		__FACTOR $N
#		__SORT $RES
#		__UNIQ $RES
#		FACTORS_STR+=" $RES"
#	done
#	__SORT $FACTORS_STR
#	FACTORS=($RES)
#	#echo FACTORS ${FACTORS[@]}
#	COUNT=1
#	for ((i=${#FACTORS[@]}-2; i>=0; i-- )); do
#		if [[ ${FACTORS[i]} -eq ${FACTORS[i+1]} ]]; then
#			COUNT=$((COUNT+1))
#			if [[ $COUNT -eq $NUM_INPUTS ]]; then
#				RES=${FACTORS[i]}
#				return
#			fi
#		else
#			COUNT=1
#		fi
#	done
#	RES=1
#}

# __LCM
# Find the Least Common multiple of the inputs
# PRECONDITION: Argument list $@ consists of a list of positive integers
# POSTCONDITION: RES is an integer, the least common multiple of $@
function __LCM() {
	local A B A_INIT B_INIT MAG
	local NUMBERS=($@)
	while [[ ${#NUMBERS[@]} -gt 1 ]]; do
		A_INIT=${NUMBERS[0]}
		B_INIT=${NUMBERS[1]}
		A=$A_INIT
		B=$B_INIT
		while [[ $A -ne $B ]]; do
			if [[ $A -lt $B ]]; then
				MAG=$(((B-A)/A_INIT))
				while [[ $MAG -eq 0 ]]; do
					B=$((B+B_INIT))
					MAG=$(((B-A)/A_INIT))
				done
				A=$((A+A_INIT*MAG))
			else
				MAG=$(((A-B)/B_INIT))
				while [[ $MAG -eq 0 ]]; do
					A=$((A+A_INIT))
					MAG=$(((A-B)/B_INIT))
				done
				B=$((B+B_INIT*MAG))
			fi
		done
		NUMBERS=($A ${NUMBERS[@]:2})
	done
	RES=${NUMBERS[0]}
}
