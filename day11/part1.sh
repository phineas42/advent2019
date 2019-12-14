#!/bin/bash

# Hull painting robot
declare -A PAINT
LOC="0 0"
DIR=N
PAINT[$LOC]="0"

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
echo ${#PAINT[@]}
