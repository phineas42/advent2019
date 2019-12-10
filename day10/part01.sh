#!/bin/bash

DATA=()
while IFS= read LINE; do
	SPLIT=""
	for (( i=0; i<${#LINE}; i++)); do
		SPLIT="$SPLIT "${LINE:i:1}
	done
	DATA+=("$SPLIT")
done

RET=
row0=(${DATA[0]})
width=${#row0[@]}
height=${#DATA[@]}
MAX=0
MAX_VECTOR=
for ((y=0; y<$height; y++ )); do
	STATION_ROW=(${DATA[y]})
	for ((x=0; x<$width; x++ )); do
		STATION_CELL=${STATION_ROW[x]}
		if [[ $STATION_CELL != "#" ]]; then
			printf "|%4s" " "
			continue
		fi
		declare -A VECTORS
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
					((COUNTALL++))
					# asteroid located
					((num=y-y2))
					if [[ $num -lt 0 ]]; then
						sign_num='-'
						num=$((-num))
					else
						sign_num=''
					fi
					((den=x-x2))
					if [[ $den -lt 0 ]]; then
						sign_den='-'
						den=$((-den))
					else
						sign_den=''
					fi
					# Reduce the fraction defined by num/den and store in RET
					for (( i=2; i<=$den || i<=$num; true )); do
						if [[ $(((den/$i)*$i)) -eq $den && $(((num/$i)*$i)) -eq $num ]]; then
							((num=num/$i))
							((den=den/$i))
						else
							((i=i+1))
						fi
					done
					RET="$sign_num$num $sign_den$den"
					vector=$RET
					if [[ -z "${VECTORS[$vector]}" ]]; then
						VECTORS[$vector]=1
						((COUNT++))
					fi
				fi
			done
		done
		unset VECTORS
		printf "|%4d" $COUNT
		if [[ $COUNT -gt $MAX ]]; then
			MAX=$COUNT
			MAX_VECTOR="$x $y"
		fi
	done
	echo "|"
done
echo MAX: $MAX
echo MAX_VECTOR: $MAX_VECTOR

