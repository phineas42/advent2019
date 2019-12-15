#!/bin/bash
# insert a quarter
# count the number of blocks
sed -E "s/^([0-9]*)/2/" input.txt > input2.txt

. ../stdlib.bash

PARENT_PID=$$
coproc {
	../IntCode.sh input2.txt --signal $PARENT_PID | ./ArcadeUI.sh
	echo IntCode exit code $? >&2
}

READY_FOR_INPUT=0
function INPUT_NOTIFY() {
	READY_FOR_INPUT=1
}

BALL_POSITION=-1
PADDLE_POSITION=-1
function JOYSTICK() {
	local NEXT_JOYSTICK_DIRECTION=0
	echo COMPARING BALL_POSITION $BALL_POSITION to PADDLE_POSITION $PADDLE_POSITION >&2
	if [[ $BALL_POSITION -ne -1 && $PADDLE_POSITION -ne -1 ]]; then
		if [[ $BALL_POSITION -gt $PADDLE_POSITION ]]; then
			NEXT_JOYSTICK_DIRECTION=1
		elif [[ $BALL_POSITION -lt $PADDLE_POSITION ]]; then
			NEXT_JOYSTICK_DIRECTION=-1
		fi
	fi
	#read -p JOYSTICK_IN NEXT_JOYSTICK_DIRECTION
	echo $NEXT_JOYSTICK_DIRECTION >&${COPROC[1]}
}

trap INPUT_NOTIFY SIGUSR1

while [[ -n ${COPROC[0]} ]]; do
	read LINE <&${COPROC[0]}
	echo "$LINE"
	__STRINDEX "$LINE" "o"
	if [[ $RES -ne -1 ]]; then
		#echo LINE=\""$LINE"\" >&2
		#echo BALL_POSITION=$RES >&2
		BALL_POSITION=$RES
	fi
	__STRINDEX "$LINE" "_"
	if [[ $RES -ne -1 ]]; then
		#echo PADDLE_POSITION=$RES >&2
		PADDLE_POSITION=$RES
	fi
	if [[ $READY_FOR_INPUT -eq 1 ]]; then
		READY_FOR_INPUT=0
		JOYSTICK
	fi
done
