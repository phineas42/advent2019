#!/bin/bash

(for NOUN in $(seq 0 99); do for VERB in $(seq 0 99); do RES=$(./part2.sh $NOUN $VERB <input.txt | tail -n1); if [[ RES -eq 19690720 ]]; then echo $NOUN $VERB $RES; exit 0; fi; done; done)
