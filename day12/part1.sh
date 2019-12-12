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
MOON_POSITIONS=()
MOON_VELOCITIES=()
REGEX='^<x=(.*), y=(.*), z=(.*)>$'
while IFS= read LINE; do
	if [[ $LINE =~ $REGEX ]]; then
		X=${BASH_REMATCH[1]}
		Y=${BASH_REMATCH[2]}
		Z=${BASH_REMATCH[3]}
		MOON_POSITIONS+=("$X $Y $Z")
		MOON_VELOCITIES+=(0 0 0)
	fi
done
NUM_MOONS=${#MOON_POSITIONS[@]}

STEP=0
DEBUG_STATE
for ((STEP=1; STEP<=$NUM_STEPS; STEP++ )); do
	# update velocity (apply gravity)
	apply_gravity
	# update position (apply velocity)
	apply_velocity
	DEBUG_STATE
done
calculate_energy
echo $RES
