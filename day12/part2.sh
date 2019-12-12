#!/bin/bash

NUM_STEPS=$1
if [[ -z "$NUM_STEPS" ]]; then
	echo Specify number of steps
	exit 1
fi

function apply_gravity() {
	for (( A=0; A<NUM_MOONS; A++ )); do
		for (( B=A+1; B<NUM_MOONS; B++)); do
			if [[ $A -ne $B ]]; then
				AP=(${MOON_POSITIONS[$A]})
				BP=(${MOON_POSITIONS[$B]})
				AV=(${MOON_VELOCITIES[$A]})
				BV=(${MOON_VELOCITIES[$B]})
				for AXIS in 0 1 2; do
					if [[ ${AP[$AXIS]} -lt ${BP[$AXIS]} ]]; then
						AV[$AXIS]=$((AV[$AXIS]+1))
						BV[$AXIS]=$((BV[$AXIS]-1))
					elif [[ ${AP[$AXIS]} -gt ${BP[$AXIS]} ]]; then
						AV[$AXIS]=$((AV[$AXIS]-1))
						BV[$AXIS]=$((BV[$AXIS]+1))
					fi
				done
				MOON_VELOCITIES[$A]=${AV[*]}
				MOON_VELOCITIES[$B]=${BV[*]}
			fi
		done
	done
}

function apply_velocity() {
	for (( M=0; M<NUM_MOONS; M++)); do
		MP=(${MOON_POSITIONS[$M]})
		MV=(${MOON_VELOCITIES[$M]})
		for AXIS in 0 1 2; do
			MP[$AXIS]=$((MP[$AXIS]+MV[$AXIS]))
		done
		MOON_POSITIONS[$M]=${MP[*]}
	done
}

function __ABS() {
        if [[ $1 -lt 0 ]]; then
                ((RES=0-$1))
        else
                ((RES=$1))
        fi
}

function calculate_energy() {
	SUM_TOTAL_ENERGY=0
	for (( M=0; M<NUM_MOONS; M++)); do
		MP=(${MOON_POSITIONS[$M]})
		MV=(${MOON_VELOCITIES[$M]})
		POTENTIAL_ENERGY=0
		KINETIC_ENERGY=0
		for AXIS in 0 1 2; do
			__ABS ${MP[$AXIS]}
			POTENTIAL_ENERGY=$((POTENTIAL_ENERGY+RES))
			__ABS ${MV[$AXIS]}
			KINETIC_ENERGY=$((KINETIC_ENERGY+RES))
		done
		TOTAL_ENERGY=$((POTENTIAL_ENERGY*KINETIC_ENERGY))
		SUM_TOTAL_ENERGY=$((SUM_TOTAL_ENERGY+TOTAL_ENERGY))
	done
	RES=$SUM_TOTAL_ENERGY
}

function DEBUG_STATE() {
	echo After $STEP steps:
	for (( M=0; M<NUM_MOONS; M++)); do
		MP=(${MOON_POSITIONS[$M]})
		MV=(${MOON_VELOCITIES[$M]})
		printf "pos=<x=%2d, y=%2d, z=%2d>, vel=<x=%2d, y=%2d, z=%2d>\n" ${MP[@]} ${MV[@]}
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
	while [[ -z "${HASHES[$HASH]}" ]]; do
		HASHES[$HASH]=$TRANSFORM_STEP
		# Apply gravity
		for (( M=0; M<COUNT; M++ )); do
			for (( M2=M+1; M2<COUNT; M2++ )); do
				if [[ ${P[$M]} -lt ${P[$M2]} ]]; then
					V[$M]=$((V[M]+1))
					V[$M2]=$((V[M2]-1))
				elif [[ ${P[$M]} -gt ${P[$M2]} ]]; then
					V[$M]=$((V[M]-1))
					V[$M2]=$((V[M2]+1))
				fi
			done
		done
		# Apply Velocity
		for (( M=0; M<COUNT; M++ )); do
			P[$M]=$((P[M]+V[M]))
		done
		# Calculate HASH
		HASH=${P[*]}" "${V[*]}
		TRANSFORM_STEP=$((TRANSFORM_STEP+1))
	done
	FREQ=$(($TRANSFORM_STEP-${HASHES[$HASH]}))
	PHASE=${HASHES[$HASH]}
}

function __MAX() {
	local MAX
	MAX=$1
	shift
	for V in ${@}; do
		if [[ $V -gt $MAX ]]; then
			MAX=$V
		fi
	done
	RES=$MAX
}
function __FACTOR() {
	local N=$1
	local FACTORS=()
	local i
	for (( i=2; i<=N; true )); do
		if [[ $((N%i)) -eq 0 ]]; then
			FACTORS+=($i)
			N=$((N/i))
		else
			i=$((i+1))
		fi
	done
	RES="${FACTORS[*]}"
}

function __LCM() {
	NUMBERS=($@)
	FACTORS=()
	for N in ${NUMBERS[@]}; do
		__FACTOR $N
		echo "$RES"
		FACTORS+=("$RES")
	done
	declare -p FACTORS
	COMMON_FACTORS=()
	for N in ${!NUMBERS[@]}; do
		for F in ${FACTORS[$N]}; do
			for N2 in ${!NUMBERS[@]}; do
				if [[ $N -eq $N2 ]]; then
					continue
				fi
				for F2 in ${FACTORS[$N2]}; do
					if [[ $F2 -eq $F ]]; then
				       		continue 2
				 	fi
				done
				break 2
			done
			# F is a common factor
			COMMON_FACTORS+=($F)
		done
	done
	LCM=1
	for N in ${NUMBERS[@]}; do
		LCM=$((LCM*N))
	done
	for F in ${COMMON_FACTORS[@]}; do
		LCM=$((LCM/F))
	done
	RES=$LCM
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
#SEARCH_FREQ_PHASE_INTERSECTION $FREQ_X $FREQ_Y $FREQ_Z $PHASE_X $PHASE_Y $PHASE_Z
LCM(231614,96236,193052)==537881600740876
# Prime factorization largest power method: expr 115807 \* 2 \* 2 \* 7 \* 7 \* 491 \* 17 \* 17 \* 167
