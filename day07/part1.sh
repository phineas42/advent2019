#!/bin/bash

MAX_VAL=-1
MAX_SET=
for A in 0 1 2 3 4; do
	OUTA=$(./IntCode.sh input.txt <<<$A$'\n'0$'\n')
	for B in 0 1 2 3 4; do
		if [[ $B -eq $A ]]; then
			continue
		fi
		OUTB=$(./IntCode.sh input.txt <<<$B$'\n'$OUTA$'\n')
		for C in 0 1 2 3 4; do
			if [[ $C -eq $A || $C -eq $B ]]; then
				continue
			fi
			OUTC=$(./IntCode.sh input.txt <<<$C$'\n'$OUTB$'\n')
			for D in 0 1 2 3 4; do
				if [[ $D -eq $A || $D -eq $B || $D -eq $C ]]; then
					continue
				fi
				OUTD=$(./IntCode.sh input.txt <<<$D$'\n'$OUTC$'\n')
				for E in 0 1 2 3 4; do
					if [[ $E -eq $A || $E -eq $B || $E -eq $C || $E -eq $D ]]; then
						continue
					fi
					OUTE=$(./IntCode.sh input.txt <<<$E$'\n'$OUTD$'\n')
					if [[ $OUTE -gt $MAX_VAL ]]; then
						MAX_VAL=$OUTE
						MAX_SET="$A $B $C $D $E"
					fi
				done
			done
		done
	done
done

echo $MAX_VAL
echo $MAX_SET
