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

RENDER=${LAYERS[0]}
LAYERS=("${LAYERS[@]:1}")
for LAYER in ${LAYERS[@]}; do
	for ((i=0; i<$LAYERLENGTH; i++ )); do
		lc=${LAYER:$i:1}
		rc=${RENDER:$i:1}
		if [[ $rc = 2 ]]; then
			RENDER=${RENDER:0:$i}${lc}${RENDER:$((i+1))}
		fi
	done
done

for (( y=0; y<$height; y++)); do
	echo ${RENDER:$((y*$width)):$width}
done
