#!/bin/bash

DATA=()
while IFS= read LINE; do
	SPLIT=""
	for (( i=0; i<${#LINE}; i++)); do
		SPLIT="$SPLIT "${LINE:i:1}
	done
	DATA+=("$SPLIT")
done

# function display_vectors() {
# 	declare -a ROWS TARGETS PAIR
# 	local row KEY TARGET_COORD ax ay
# 	ROWS=()
# 	for (( row=0; row<23; row++)); do
# 		ROWS[$row]="                                                              "
# 	done
# 	for KEY in "${!VECTORS[@]}"; do
# 		TARGETS=("${VECTORS[$KEY]}")
# 		for TARGET_COORD in ${TARGETS[@]}; do
# 			IFS=,
# 			PAIR=($TARGET_COORD)
# 			unset IFS
# 			ax=${PAIR[0]}
# 			ay=${PAIR[1]}
# 			row=${ROWS[$ay]}
# 			row=${row:0:ax}'#'${row:$((ax+1))}
# 			ROWS[$ay]="$row"
# 		done
# 	done
# 	row=${ROWS[$y]}
# 	row=${row:0:x}'@'${row:$((x+1))}
# 	ROWS[$y]="$row"
# 	if [[ $COUNT -gt 20 && $COUNT -lt 40 ]]; then
# 		sleep 0.45
# 	else
# 		sleep 0.01
# 	fi
# 	clear
# 	for row in "${ROWS[@]}"; do
# 		echo "$row"
# 	done > output.txt
# 	diff -y input.txt output.txt
# }

function to_angle() {
	X=$1
	Y=$2
	if [[ $X -lt 0 ]]; then
		sign_X='-'
		mag_X=$((-X))
	else
		sign_X=''
		mag_X=$X
	fi
	if [[ $Y -lt 0 ]]; then
		sign_Y='-'
		mag_Y=$((-Y))
	else
		sign_Y=''
		mag_Y=$Y
	fi
	# Reduce the fraction defined by X/Y
	for (( i=2; i<=$X || i<=$Y; true )); do
		if [[ $(((X/i)*i)) -eq $X && $(((Y/i)*i)) -eq $Y ]]; then
			X=$((X/i))
			Y=$((Y/i))
		else
			i=$((i+1))
		fi
	done
	if [[ $sign_X == '' && $sign_Y == '-' ]]; then
		# upper-right quadrant
		quadrant="1"
		# increasing mag_X -> increasing angle
		# decreasing mag_Y -> increasing angle
		angle=$((10000*mag_X/mag_Y))
		# Y cannot be 0 in this quadrant
	elif [[ $sign_X == '' && $sign_Y == '' ]]; then
		# lower-right quadrant
		quadrant="2"
		# decreasing mag_X -> increasing angle
		# increasing mag_Y -> increasing angle
		if [[ $X == 0 ]]; then
			angle=10000000
		else
			angle=$((10000*mag_Y/mag_X))
		fi
	elif [[ $sign_X == '-' && $sign_Y == '' ]]; then
		# lower-left quadrant
		quadrant="3"
		# increasing mag_X -> increasing angle
		# decreasing mag_Y -> increasing angle
		if [[ $Y == 0 ]]; then
			angle=10000000
		else
			angle=$((10000*mag_X/mag_Y))
		fi
	else
		# upper-left quadrant
		quadrant="4"
		# decreasing mag_X -> increasing angle
		# increasing mag_Y -> increasing angle
		angle=$((10000*mag_Y/mag_X))
	fi
	printf -v RET "%1d%010d" $quadrant $angle
}

RET=
row0=(${DATA[0]})
width=${#row0[@]}
height=${#DATA[@]}
# MAX=0
# MAX_VECTOR=
# for ((y=0; y<$height; y++ )); do
y=11
 	STATION_ROW=(${DATA[y]})
	x=19	
	# for ((x=0; x<$width; x++ )); do
		STATION_CELL=${STATION_ROW[x]}
# 		if [[ $STATION_CELL != "#" ]]; then
# 			printf "|%4s" " "
# 			continue
# 		fi
 		declare -a VECTORS
 		COUNT=0
 		COUNTALL=0
 		
 		for ((y2=0; y2<$height; y2++)); do
 			ROW=(${DATA[y2]})
 			for ((x2=0; x2<$width; x2++)); do
 				if [[ $x == $x2 && $y == $y2 ]]; then
 					continue
 				fi
 				CELL=${ROW[x2]}
 				if [[ $CELL == '#' ]]; then
 					# asteroid located
 					Y=$((y2-y))
 					X=$((x2-x))
 					to_angle $X $Y
					QUADRANT_ANGLE=$RET
					VECTORS[$QUADRANT_ANGLE]+=" $x2,$y2"
 				fi
 			done
 		done
# 	done
# 	echo "|"
# done
# echo MAX: $MAX
# echo MAX_VECTOR: $MAX_VECTOR
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

COUNT=0

while [[ $COUNT -lt 201 ]]; do

	for KEY in "${!VECTORS[@]}"; do
#		display_vectors
		TARGETS=(${VECTORS[$KEY]})
		if [[ ${#TARGETS[@]} -eq 0 ]]; then
			continue
		fi
		NEAREST_TARGET=
		NEAREST_DISTANCE=10000
		for TARGET in ${TARGETS[@]}; do
			#echo "    $TARGET"
			IFS=,
			COORDS=($TARGET)
			unset IFS
			__ABS $((x-${COORDS[0]}))
			Dx=$RES
			__ABS $((y-${COORDS[1]}))
			Dy=$RES
			__DISTANCE $Dx $Dy
			D=$RES
			if [[ $D -lt $NEAREST_DISTANCE ]]; then
				NEAREST_DISTANCE=$D
				NEAREST_TARGET=$TARGET
			fi
		done
		TARGETS=("${TARGETS[@]/$NEAREST_TARGET}")
		VECTORS[$KEY]="${TARGETS[@]}"
		COUNT=$((COUNT+1))
		if [[ $COUNT -eq 200 ]]; then
			echo $COUNT $NEAREST_TARGET
			exit 0
		fi
	done
done
