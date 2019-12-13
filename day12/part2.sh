#!/bin/bash

. stdlib.bash

FREQ=
PHASE=

# TRANSFORM_AXIS
# Given a Position and Velocity state for a single axis (e.g. just X from X Y Z),
# This function reduces the axis state to a frequency (how often a state repeats on the one axis)
# A phase is also returned, in case the initial condition somehow does not repeat
# PRECONDITION: $1 is the initial position data for all objects, $2 is velocity for all
#               Each is a string, a space-separated list of their values
# POSTCONDITION: FREQ := number of STEPS in a complete cycle
#                PHASE := number of STEPS before the first step that repeats
function TRANSFORM_AXIS() {
	local P V COUNT HASH TRANSFORM_STEP M M2
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

# TRANSFORM_AXIS_0_PHASE
# Given a Position and Velocity state for a single axis (e.g. just X from X Y Z),
# This function reduces the axis state to a frequency (how often a state repeats on the one axis)
# It is assumed that the initial condition will repeat, so no phase is calculated.
# PRECONDITION: $1 is the initial position data for all objects, $2 is velocity for all
#               Each is a string, a space-separated list of their values
# POSTCONDITION: FREQ := number of STEPS in a complete cycle
function TRANSFORM_AXIS_0_PHASE() {
	local P V COUNT INITIAL_HASH HASH TRANSFORM_STEP M M2
	P=($1)
	V=($2)
	COUNT=${#P[@]}
	INITIAL_HASH=${P[*]}" "${V[*]}
	TRANSFORM_STEP=0
	while [[ "$INITIAL_HASH" != "$HASH" ]]; do
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
	FREQ=$TRANSFORM_STEP
}

# MAIN Program begins:

# Read inputs
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

# pivot data from POSITION[<moon>]:<axis>
#              to POSITION[<axis>]:<moon>
# likewise pivot VELOCITIES
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


TRANSFORM_AXIS_0_PHASE "$POSITIONS_X" "$VELOCITIES_X"
echo TRANSFORM X: FREQ=$FREQ
FREQ_X=$FREQ

TRANSFORM_AXIS_0_PHASE "$POSITIONS_Y" "$VELOCITIES_Y"
echo TRANSFORM Y: FREQ=$FREQ
FREQ_Y=$FREQ

TRANSFORM_AXIS_0_PHASE "$POSITIONS_Z" "$VELOCITIES_Z"
echo TRANSFORM Z: FREQ=$FREQ
FREQ_Z=$FREQ

# ASSERT: PHASES Can't be 0. (LCM method does not work for non-zero phases)
__LCM $FREQ_X $FREQ_Y $FREQ_Z
echo Result: $RES

#FREQ_X=231614
#PHASE_X=0
#FREQ_Y=96236
#PHASE_Y=0
#FREQ_Z=193052
#PHASE_Z=0
#LCM(231614,96236,193052)==537881600740876
