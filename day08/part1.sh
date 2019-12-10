#!/bin/bash

width=25
height=6
LAYERLENGTH=$((width*height))
LAYERS=()
read DATA

OFFSET=0
MIN_ZEROS=200
MIN_ZERO_LAYER=
CURRENT_LAYER=0
set -x
while [[ ${#DATA} -gt 0 ]]; do
	LAYER=${DATA:$OFFSET:$LAYERLENGTH}
	DATA=${DATA:$((OFFSET+$LAYERLENGTH))}
	LAYERS+=($LAYER)
	ZEROS=$(grep -o 0 <<<$LAYER | wc -l)
	if [[ $ZEROS -lt $MIN_ZEROS ]]; then
		MIN_ZEROS=$ZEROS
		MIN_ZERO_LAYER=$CURRENT_LAYER
	fi
	((CURRENT_LAYER=CURRENT_LAYER+1))
done
set +x
echo $MIN_ZEROS $MIN_ZERO_LAYER
ONES=$(grep -o 1 <<<${LAYERS[$MIN_ZERO_LAYER]} | wc -l)
TWOS=$(grep -o 2 <<<${LAYERS[$MIN_ZERO_LAYER]} | wc -l)
echo $((ONES*TWOS))
