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

STEPS=0
function GRID_TRACE1() {
	X=$1
	Y=$2
	GRID[GRID_SIZE_X*(Y+GRID_ORIGIN_Y)+(X+GRID_ORIGIN_X)]=$STEPS
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
declare -a INTERSECTION_STEPS
while IFS=, read -a WIRE; do
	LOC_X=0
	LOC_Y=0
	STEPS=0
	for PAIR in ${WIRE[@]}; do
		#echo $PAIR
		if [[ $PAIR =~ (.)(..*) ]]; then
			DIRECTION=${BASH_REMATCH[1]}
			DISTANCE=${BASH_REMATCH[2]}
			# echo $DIRECTION $DISTANCE
			for (( i=0; i<$DISTANCE; i++ )); do
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
				((STEPS=STEPS+1))
				if [[ $LINE_NO -eq 1 ]]; then
					GRID_TRACE1 $LOC_X $LOC_Y $STEPS
				else
					GRID_GET $LOC_X $LOC_Y
					if [[ $RES -gt 0 ]]; then
						echo $LOC_X $LOC_Y $RES $STEPS
						INTERSECTION_STEPS+=($((RES+STEPS)))
					fi
				fi
			done
		else
			echo BAD PAIR $PAIR
			exit 1
		fi
	done
	((LINE_NO=LINE_NO<<1))
done

MIN_STEPS=0
for S in ${INTERSECTION_STEPS[@]}; do
	if [[ $MIN_STEPS -eq 0 || $S -lt $MIN_STEPS ]]; then
		MIN_STEPS=$S
	fi
done
echo MINIMUM STEPS $MIN_STEPS

