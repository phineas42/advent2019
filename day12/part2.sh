#!/bin/bash

NUM_STEPS=$1
if [[ -z "$NUM_STEPS" ]]; then
	echo Specify number of steps
	exit 1
fi

function __SORT() {
	local LIST i T
	LIST=("$@")
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

function __ABS() {
        if [[ $1 -lt 0 ]]; then
                RES=$((0-$1))
        else
                RES=$1
        fi
}

function __MIN() {
	local MIN VAL
	MIN=$1
	shift
	for VAL in $@; do
		if [[ $VAL -lt $MIN ]]; then
			MIN=$VAL
		fi
	done
	RES=$MIN
}

function __MAX() {
	local MAX VAL
	MAX=$1
	shift
	for VAL in $@; do
		if [[ $VAL -gt $MAX ]]; then
			MAX=$VAL
		fi
	done
	RES=$MAX
}

function __PRIMEFACTOR() {
	local N=$1
	local PRIMEFACTORS=()
	local i
	for (( i=2; i<=N; true )); do
		if [[ $((N%i)) -eq 0 ]]; then
			PRIMEFACTORS+=($i)
			N=$((N/i))
		else
			i=$((i+1))
		fi
	done
	RES=${PRIMEFACTORS[@]}
}

#TODO: optimize __FACTOR
function __FACTOR() {
	local N=$1
	local FACTORS=(1 $N)
	local i
	for (( i=2; i<=N/2; i++ )); do
		if [[ $((N%i)) -eq 0 ]]; then
			FACTORS+=($i $((N/i)))
		fi
	done
	RES=${FACTORS[@]}
}


function __FACTOR() {
	local N=$1
	__PRIMEFACTOR $N
	# TODO allow PRIMEFACTORS to be pre-supplied
	# TODO in which case we may wish to skip the culling of duplicates
	local PRIMEFACTORS=$RES
	local OTHERFACTORS=()
	local NDF
	for F in $PRIMEFACTORS; do
		# ASSERT: F should never equal 1
		if [[ $F -eq $N ]]; then
			continue
		fi
		NDF=$((N/F))
		#TODO: supply PRIMEFACTORS to the recursive __FACTOR call
		__FACTOR $NDF
		OTHERFACTORS+=($NDF $RES)
	done
	__SORT ${OTHERFACTORS[@]}
	__UNIQ $RES

}

function __GCD() {
	NUMBERS=($@)
	NUM_INPUTS=${#NUMBERS[@]}
	FACTORS_STR=""
	for N in ${NUMBERS[@]}; do
		__FACTOR $N
		__SORT $RES
		__UNIQ $RES
		FACTORS_STR+=" $RES"
	done
	__SORT $FACTORS_STR
	FACTORS=($RES)
	#echo FACTORS ${FACTORS[@]}
	COUNT=1
	for ((i=${#FACTORS[@]}-2; i>=0; i-- )); do
		if [[ ${FACTORS[i]} -eq ${FACTORS[i+1]} ]]; then
			COUNT=$((COUNT+1))
			if [[ $COUNT -eq $NUM_INPUTS ]]; then
				RES=${FACTORS[i]}
				return
			fi
		else
			COUNT=1
		fi
	done
	RES=1
}

function __LCM() {
	local i
	NUMBERS=($@)
	RES=${NUMBERS[0]}
	for (( i=1; i<${#NUMBERS[@]}; i++)); do
		A=$RES
		B=${NUMBERS[i]}
		__GCD $A $B
		RES=$((A*B/RES))
	done
}

FREQ=
PHASE=
function TRANSFORM_AXIS() {
	P=($1)
	V=($2)
	COUNT=${#P[@]}
	declare -A HASHES
	HASH=${P[*]}" "${V[*]}
	echo "\"$HASH\""
	TRANSFORM_STEP=0
	while [[ -z "${HASHES[HASH]}" ]]; do
		HASHES[$HASH]=$TRANSFORM_STEP
		# Apply gravity
		for (( M=0; M<COUNT; M++ )); do
			for (( M2=M+1; M2<COUNT; M2++ )); do
				if [[ ${P[M]} -lt ${P[M2]} ]]; then
					V[M]=$((V[M]+1))
					V[M2]=$((V[M2]-1))
				elif [[ ${P[M]} -gt ${P[M2]} ]]; then
					V[M]=$((V[M]-1))
					V[M2]=$((V[M2]+1))
				fi
			done
		done
		# Apply Velocity
		for (( M=0; M<COUNT; M++ )); do
			P[M]=$((P[M]+V[M]))
		done
		# Calculate HASH
		HASH=${P[*]}" "${V[*]}
		TRANSFORM_STEP=$((TRANSFORM_STEP+1))
	done
	FREQ=$((TRANSFORM_STEP-HASHES[HASH]))
	PHASE=${HASHES[HASH]}
}
function SEARCH_FREQ_PHASE_INTERSECTION() {
	FREQ_X=$1
	FREQ_Y=$2
	FREQ_Z=$3
#	PHASE_X=$4
#	PHASE_Y=$5
#	PHASE_Z=$6
#	__MAX $FREQ_X $FREQ_Y $FREQ_Z
#	if [[ $RES -eq $FREQ_Y ]]; then
#		FREQ_X=$FREQ_Y
#		PHASE_X=$PHASE_Y
#		FREQ_Y=$1
#		PHASE_Y=$4
#	elif [[ $RES -eq $FREQ_Z ]]; then
#		FREQ_X=$FREQ_Z
#		PHASE_X=$PHASE_Z
#		FREQ_Z=$1
#		PHASE_Z=$4
#	fi
#	I=0
#	for (( TEST=FREQ_X+PHASE_X; TEST<FREQ_X*FREQ_Y*FREQ_Z; TEST=TEST+FREQ_X)); do
#		if [[ $((I%10000)) -eq 0 ]]; then
#			echo $I $TEST
#		fi
#		I=$((I+1))
#		if [[ $(((TEST-PHASE_Y)%FREQ_Y)) -eq 0 && $(((TEST-PHASE_Z)%FREQ_Z)) -eq 0 ]]; then
#			echo TEST $TEST met success conditions
#			exit 0
#		fi
#	done
#	echo "LCM was not found"
#	exit 1
	__LCM $FREQ_X $FREQ_Y $FREQ_Z
	echo LCM $RES
}

MOON_POSITIONS=()
MOON_VELOCITIES=()
REGEX='^<x=(.*), y=(.*), z=(.*)>$'
while IFS= read LINE; do
	if [[ $LINE =~ $REGEX ]]; then
		X=${BASH_REMATCH[1]}
		Y=${BASH_REMATCH[2]}
		Z=${BASH_REMATCH[3]}
		MOON_POSITIONS+=("$X $Y $Z")
		MOON_VELOCITIES+=("0 0 0")
	fi
done
NUM_MOONS=${#MOON_POSITIONS[@]}

# pivot data
POSITIONS_X=""
POSITIONS_Y=""
POSITIONS_Z=""
VELOCITIES_X=""
VELOCITIES_Y=""
VELOCITIES_Z=""
for ((M=0; M<NUM_MOONS; M++ )); do
	POSITIONS=(${MOON_POSITIONS[$M]})
	POSITIONS_X+=" "${POSITIONS[0]}
	POSITIONS_Y+=" "${POSITIONS[1]}
	POSITIONS_Z+=" "${POSITIONS[2]}
	VELOCITIES=(${MOON_VELOCITIES[$M]})
	VELOCITIES_X+=" "${VELOCITIES[0]}
	VELOCITIES_Y+=" "${VELOCITIES[1]}
	VELOCITIES_Z+=" "${VELOCITIES[2]}
done

#TRANSFORM_AXIS "$POSITIONS_X" "$VELOCITIES_X"
#echo TRANSFORM X: FREQ=$FREQ PHASE=$PHASE
#echo
#FREQ_X=$FREQ
#PHASE_X=$PHASE
#TRANSFORM_AXIS "$POSITIONS_Y" "$VELOCITIES_Y"
#echo TRANSFORM Y: FREQ=$FREQ PHASE=$PHASE
#echo
#FREQ_Y=$FREQ
#PHASE_Y=$PHASE
#TRANSFORM_AXIS "$POSITIONS_Z" "$VELOCITIES_Z"
#echo TRANSFORM Z: FREQ=$FREQ PHASE=$PHASE
#echo
#FREQ_Z=$FREQ
#PHASE_Z=$PHASE
FREQ_X=231614
PHASE_X=0
FREQ_Y=96236
PHASE_Y=0
FREQ_Z=193052
PHASE_Z=0
SEARCH_FREQ_PHASE_INTERSECTION $FREQ_X $FREQ_Y $FREQ_Z $PHASE_X $PHASE_Y $PHASE_Z
#LCM(231614,96236,193052)==537881600740876
# Prime factorization largest power method: expr 115807 \* 2 \* 2 \* 7 \* 7 \* 491 \* 17 \* 17 \* 167
