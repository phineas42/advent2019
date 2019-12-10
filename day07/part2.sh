#!/bin/bash


MAX_VAL=-1
MAX_SET=
RES=
function TEST() {
	A=$1
	B=$2
	C=$3
	D=$4
	coproc {
       		./IntCode.sh input.txt $A 0 | ./IntCode.sh input.txt $B | ./IntCode.sh input.txt $C | ./IntCode.sh input.txt $D | ./IntCode.sh input.txt $E
	}
	while read OUTPUT <&${COPROC[0]}; do
		# echo FEEDBACK $OUTPUT >&2
		echo $OUTPUT >&${COPROC[1]}
		RES=$OUTPUT
	done
}

for A in 5 6 7 8 9; do
	for B in 5 6 7 8 9; do
		if [[ $B -eq $A ]]; then
			continue
		fi
		for C in 5 6 7 8 9; do
			if [[ $C -eq $A || $C -eq $B ]]; then
				continue
			fi
			for D in 5 6 7 8 9; do
				if [[ $D -eq $A || $D -eq $B || $D -eq $C ]]; then
					continue
				fi
				for E in 5 6 7 8 9; do
					if [[ $E -eq $A || $E -eq $B || $E -eq $C || $E -eq $D ]]; then
						continue
					fi
					TEST $A $B $C $D $E
					# echo RES $RES
					if [[ $RES -gt $MAX_VAL ]]; then
						MAX_VAL=$RES
						MAX_SET="$A $B $C $D $E"
					fi
				done
			done
		done
	done
done

echo $MAX_VAL
# echo $MAX_SET
