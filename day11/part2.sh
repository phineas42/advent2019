#!/bin/bash

# Hull painting robot
declare -A PAINT
LOC="0 0"
DIR=N
PAINT[$LOC]="1"

function DEBUGF() {
        FORMAT=$1
        shift
	printf "$FORMAT" "$@"
}
function DEBUG() {
        DEBUGF "%s\n" "$@"
}

coproc {
	./IntCode.sh input.txt ${PAINT[$LOC]}
}

while read COLOR <&${COPROC[0]}; do
	#DEBUG "[$LOC $DIR][${PAINT[$LOC]}]"
	#DEBUG "  COLOR: $COLOR"
	read TURN <&${COPROC[0]}
	#DEBUG "  TURN: $TURN"
	PAINT[$LOC]=$COLOR
	case $DIR in
		N)
			if [[ $TURN == 0 ]]; then
				DIR=W
			else
				DIR=E
			fi
			;;
		E)
			if [[ $TURN == 0 ]]; then
				DIR=N
			else
				DIR=S
			fi
			;;
		S)
			if [[ $TURN == 0 ]]; then
				DIR=E
			else
				DIR=W
			fi
			;;
		W)
			if [[ $TURN == 0 ]]; then
				DIR=S
			else
				DIR=N
			fi
			;;
	esac
	LOC_ARRAY=($LOC)
	case $DIR in
		N)
			LOC=${LOC_ARRAY[0]}" "$((LOC_ARRAY[1]+1))
			;;
		E)
			LOC=$((LOC_ARRAY[0]+1))" "${LOC_ARRAY[1]}
			;;
		S)
			LOC=${LOC_ARRAY[0]}" "$((LOC_ARRAY[1]-1))
			;;
		W)
			LOC=$((LOC_ARRAY[0]-1))" "${LOC_ARRAY[1]}
			;;
	esac
	if [[ -n ${PAINT[$LOC]} ]]; then
		echo ${PAINT[$LOC]} >&${COPROC[1]}
	else
		echo 0 >&${COPROC[1]}
	fi
done
MIN_X=0
MIN_Y=0
MAX_X=0
MAX_Y=0
for coord in "${!PAINT[@]}"; do
	DEBUG "$coord"
	PAIR=($coord)
	X=${PAIR[0]}
	Y=${PAIR[1]}
	if [[ $X -lt $MIN_X ]]; then
		MIN_X=$X
	elif [[ $X -gt $MAX_X ]]; then
		MAX_X=$X
	fi
	if [[ $Y -lt $MIN_Y ]]; then
		MIN_Y=$Y
	elif [[ $Y -gt $MAX_Y ]]; then
		MAX_Y=$Y
	fi
done
WIDTH=$((MAX_X+1-MIN_X))
HEIGHT=$((MAX_Y+1-MIN_Y))
declare -a DATA
for coord in "${!PAINT[@]}"; do
	PAIR=($coord)
	X=${PAIR[0]}
	Y=${PAIR[1]}
	COLOR=${PAINT[$coord]}
	DATA[$(((Y-MIN_Y)*WIDTH+(X-MIN_X)))]=$COLOR
done
for ((Y=0; Y<$HEIGHT; Y++ )); do
	for ((X=0; X<$WIDTH; X++ )); do
		COLOR=${DATA[$((Y*WIDTH+X))]}
		if [[ $COLOR == 1 ]]; then
			printf "%1s" '#'
		else
			printf "%1s" ' '
		fi
	done
	echo
done

