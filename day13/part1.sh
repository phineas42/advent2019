#!/bin/bash
# count the number of blocks
../IntCode.sh input.txt | ./ArcadeUI.sh | grep -o + | wc -l
