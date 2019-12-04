#!/bin/bash
IFS=- read BEGIN END <<< $1

ERR=
function VALIDATE() {
	N=$1
	# IS_SIX
	if [[ $N -lt 100000 ]]; then
		ERR=TOO_SMALL
		return 1
	elif [[ $N -ge 1000000 ]]; then
		ERR=TOO_LARGE
		return 1
	fi
	HAS_ADJACENCY=0
	REP_COUNT=0
	PREVIOUS=${N:0:1}
	for DIGIT_INDEX in {1..5}; do
		CURRENT=${N:$DIGIT_INDEX:1}
		if [[ $PREVIOUS -gt $CURRENT ]]; then
			ERR=NOT_MONOTONIC_INCREASING
			return 1
		elif [[ $PREVIOUS -eq $CURRENT ]]; then
			((REP_COUNT=REP_COUNT+1))
		else
			if [[ $REP_COUNT -eq 1 ]]; then
				HAS_ADJACENCY=1
			fi
			REP_COUNT=0
		fi
		PREVIOUS=$CURRENT
	done
	if [[ $REP_COUNT -eq 1 ]]; then
		HAS_ADJACENCY=1
	fi
	if [[ $HAS_ADJACENCY -eq 0 ]]; then
		ERR=NO_ADJACENCY
		return 1
	else
		return 0
	fi
}
	
N=$BEGIN
COUNT=0
while [[ $N -le $END ]]; do
	if VALIDATE $N; then
		echo $N
		((COUNT=COUNT+1))
	else
		case $ERRNO in
			TOO_SMALL)
				N=99999
				;;
			TOO_LARGE)
				# This shouldn't happen
				N=$END
				;;
			NOT_MONOTONIC_INCREASING)
				# Area to improve on algorithm
				:
				;;
			NO_ADJACENCY)
				# Area to improve on algorithm
				:
				;;
		esac
	fi
	((N=N+1))
done
echo $COUNT
