#!/bin/bash

sum=0
while IFS= read mass; do
	((fuel=mass/3-2))
	((sum+=fuel))
done
echo $sum
