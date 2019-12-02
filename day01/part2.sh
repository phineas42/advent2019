#!/bin/bash

function recreq() {
	mass=$1
	((simplefuel= (mass/3-2 > 0) ? (mass/3-2) : 0))
	if [[ simplefuel -gt 0 ]]; then
		((extrafuel=$(recreq simplefuel)))
	else
		((extrafuel=0))
	fi
	echo $((simplefuel+extrafuel))
}

sum=0

while IFS= read mass; do
	fuel=$(recreq $mass)
	((sum+=fuel))
done
echo $sum
