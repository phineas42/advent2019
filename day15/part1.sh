#!/bin/bash
. ../stdlib.bash

declare -A MAP=([0 0]=.)

TARGET_CELL=
#function PROBE() {
#	CELL_LIST=($CELL)
#	X=${CELL_LIST[0]}
#	Y=${CELL_LIST[1]}
#	case "$PROBE_DIR" in
#		1) TARGET_CELL=$X\ $((Y-1)) ;;
#		2) TARGET_CELL=$X\ $((Y+1)) ;;
#		3) TARGET_CELL=$((X-1))\ $Y ;;
#		4) TARGET_CELL=$((X+1))\ $Y ;;
#	esac
#	#DEBUG INPUTTING\ $PROBE_DIR
#	echo $PROBE_DIR >&${COPROC[1]}
#	LAST_ACTION=PROBE
#}

function MOVE() {
	CELL_LIST=($CELL)
	X=${CELL_LIST[0]}
	Y=${CELL_LIST[1]}
	case "$MOVE_DIR" in
		1) TARGET_CELL=$X\ $((Y-1)) ;;
		2) TARGET_CELL=$X\ $((Y+1)) ;;
		3) TARGET_CELL=$((X-1))\ $Y ;;
		4) TARGET_CELL=$((X+1))\ $Y ;;
	esac
	#DEBUG INPUTTING\ $MOVE_DIR
	echo $MOVE_DIR >&${COPROC[1]}
	LAST_ACTION=MOVE
}

# 
# function RETURN() {
# 	RETURN_DIR=$((((PROBE_DIR-1)^1)+1))
# 	#DEBUG INPUTTING\ $RETURN_DIR
# 	echo $RETURN_DIR >&${COPROC[1]}
# 	LAST_ACTION=RETURN
# }
# 

function REDRAW() {
	local MAP_CELL
	{
		for MAP_CELL in "${!MAP[@]}"; do
			echo $(("${MAP_CELL% *}"+10000))
			echo "${MAP_CELL#* }"
			echo ${MAP[$MAP_CELL]}
		done
		# Display current location
		echo $(("${CELL% *}"+10000))
		echo "${CELL#* }"
		echo D
	} | ./ArcadeScreen.sh
	DEBUG "Current Cell: $CELL"
	declare -p MAP
}

coproc {
	../IntCode.sh input.txt --stdout-prompt
}

CELL="0 0"
PROBE_DIR=1
MOVE_DIR=
LAST_ACTION=
NEXT_ACTION=PROBE

exec 4<&0
while IFS= read LINE; do
	DEBUG "$LINE"
	case "$LINE" in
		INPUT:)
			MANUAL=
			while [[ ! $MANUAL =~ ^[1234]$ ]]; do
				read MANUAL <&4
			done
			MOVE_DIR=$MANUAL
			MOVE
			;;
		0)
			# Wall
			MAP[$TARGET_CELL]=1
			REDRAW
			;;
		1)
			# Empty space
			MAP[$TARGET_CELL]=.
			CELL=$TARGET_CELL
			REDRAW
			;;
		2)
			# Oxygen
			MAP[$TARGET_CELL]=4
			CELL=$TARGET_CELL
			REDRAW
			;;
	esac
done <&${COPROC[0]}
