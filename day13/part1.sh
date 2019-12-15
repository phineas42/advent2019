#!/bin/bash
# count the number of blocks
../IntCode.sh input.txt | ./ArcadeScreen.sh | grep -o + | wc -l
