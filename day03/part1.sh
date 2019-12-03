#!/bin/bash

declare -a GRID
GRID_SIZE_X=20001
GRID_SIZE_Y=20001
((GRID_ORIGIN_X=GRID_SIZE_X/2))
((GRID_ORIGIN_Y=GRID_SIZE_Y/2))
function GRID_GET() {
	X=$1
	Y=$2
	GRID_X=$((X+GRID_ORIGIN_X))
	GRID_Y=$((Y+GRID_ORIGIN_Y))
	if [[ $GRID_X -lt 0 || $GRID_X -ge $GRID_SIZE_X ]]; then
		echo X $X out of bounds
		exit 1
	elif [[ $GRID_Y -lt 0 || $GRID_Y -ge $GRID_SIZE_Y ]]; then
		echo Y $Y out of bounds
		exit 1
	fi
	RES=${GRID[GRID_SIZE_X*(Y+GRID_ORIGIN_Y)+(X+GRID_ORIGIN_X)]}
}
function GRID_SET() {
	X=$1
	Y=$2
	VAL=$3

	# Determine if an intersection happened
	GRID_GET $X $Y

	GRID[GRID_SIZE_X*(Y+GRID_ORIGIN_Y)+(X+GRID_ORIGIN_X)]=$((VAL||RES))
	# Flag if an intersection happened (and not with itself)
	if [[ $RES -gt 0 && $RES -ne $VAL ]]; then
		RES=1
	else
		RES=0
	fi
}
function __ABS() {
	if [[ $1 -lt 0 ]]; then
		((RES=0-$1))
	else
		((RES=$1))
	fi
}
function __DISTANCE() {
	__ABS $1
	X=$RES
	__ABS $2
	Y=$RES
	((RES=X+Y))
}
	
LINE_NO=1
declare -a INTERSECTION_DISTANCES
while IFS=, read -a WIRE; do
	LOC_X=0
	LOC_Y=0
	for PAIR in ${WIRE[@]}; do
		#echo $PAIR
		if [[ $PAIR =~ (.)(..*) ]]; then
			DIRECTION=${BASH_REMATCH[1]}
			DISTANCE=${BASH_REMATCH[2]}
			# echo $DIRECTION $DISTANCE
			for (( i=0; i<$DISTANCE; i++ )); do
				GRID_SET $LOC_X $LOC_Y $LINE_NO
				if [[ $RES -gt 0 && ( $LOC_X -ne 0 || $LOC_Y -ne 0 ) ]]; then
					__DISTANCE $LOC_X $LOC_Y
					echo INTERSECTION $LOC_X $LOC_Y $RES
					INTERSECTION_DISTANCES+=($RES)
				fi
				case $DIRECTION in
					R)
						((LOC_X=LOC_X+1))
						;;
					U)
						((LOC_Y=LOC_Y-1))
						;;
					L)
						((LOC_X=LOC_X-1))
						;;
					D)
						((LOC_Y=LOC_Y+1))
						;;
					default)
						echo BAD DIRECTION
						exit 1
						;;
				esac
			done
		else
			echo BAD PAIR $PAIR
			exit 1
		fi
	done
	((LINE_NO=LINE_NO<<1))
done

MIN_D=0
for D in ${INTERSECTION_DISTANCES[@]}; do
	if [[ $MIN_D -eq 0 || $D -lt $MIN_D ]]; then
		MIN_D=$D
	fi
done
echo MINIMUM DISTANCE $MIN_D

