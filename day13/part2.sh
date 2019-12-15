#!/bin/bash

. ../stdlib.bash

# a screen and auto-joystick for IntCode Arcade Cabinet

MIN_X=0
MIN_Y=0
MAX_X=0
MAX_Y=0
declare -A COORD_BUFFER
declare -A SPRITES=([0]=" " [1]="#" [2]="+" [3]="_" [4]="o")

SCORE=0
declare -a SCREEN_BUFFER
function REDRAW() {
	SCREEN_BUFFER=""
	for (( Y=MIN_Y; Y<=MAX_Y; Y++ )); do
		for ((X=MIN_X; X<=MAX_X; X++ )); do
			SPRITE_REF=${COORD_BUFFER[$X,$Y]}
			if [[ -z $SPRITE_REF ]]; then
				SPRITE_REF=0
			fi
			SPRITE=${SPRITES[$SPRITE_REF]}
			if [[ -z $SPRITE ]]; then
				echo no sprite $SPRITE_REF >&2
				exit 1
			fi
			SCREEN_BUFFER+=$SPRITE
		done
		SCREEN_BUFFER+=$'\n'
	done
	clear
	echo "$SCREEN_BUFFER"
	echo "Display: $SCORE"
}

BALL_POSITION_X=-1
PADDLE_POSITION_X=-1
function JOYSTICK() {
	local NEXT_JOYSTICK_DIRECTION=0
	if [[ $BALL_POSITION_X -ne -1 && $PADDLE_POSITION_X -ne -1 ]]; then
		if [[ $BALL_POSITION_X -gt $PADDLE_POSITION_X ]]; then
			NEXT_JOYSTICK_DIRECTION=1
		elif [[ $BALL_POSITION_X -lt $PADDLE_POSITION_X ]]; then
			NEXT_JOYSTICK_DIRECTION=-1
		fi
	fi
	#read -p JOYSTICK_IN NEXT_JOYSTICK_DIRECTION
	echo $NEXT_JOYSTICK_DIRECTION >&${COPROC[1]}
}

PARENT_PID=$$
coproc {
	# insert a quarter
	sed -E "s/^([0-9]*)/2/" input.txt > input2.txt
	# start the game
	../IntCode.sh input2.txt --stdout-prompt
}

while IFS= read X; do
	if [[ $X == "INPUT:" ]]; then
		JOYSTICK
		continue
	fi
	IFS= read Y
	IFS= read A
	COORD="$X,$Y"
	if [[ $COORD == "-1,0" ]]; then
		SCORE=$A
		echo SCORE: $A
	else
		if [[ $A -eq 3 ]]; then
			PADDLE_POSITION_X=$X
		elif [[ $A -eq 4 ]]; then
			BALL_POSITION_X=$X
		fi
		COORD_BUFFER[$COORD]=$A
		__MIN $MIN_X $X
		MIN_X=$RES
		__MAX $MAX_X $X
		MAX_X=$RES
		__MIN $MIN_Y $Y
		MIN_Y=$RES
		__MAX $MAX_Y $Y
		MAX_Y=$RES
	fi
done <&${COPROC[0]}

