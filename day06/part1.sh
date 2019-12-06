#!/bin/bash

declare -A ORDERS
declare -A MAP_CHILD
declare -A MAP_PARENT
ORDERS=([COM]=0)

function DEBUG() {
	echo "$1" >&2
}
function DEBUGF() {
	printf "$@" >&2
	echo >&2
}


while IFS=')' read PARENT CHILD; do
	MAP_PARENT[$CHILD]=$PARENT
	MAP_CHILD[$PARENT]+="$CHILD " # multiple children per parent
done
#DEBUG "$(declare -p MAP_CHILD)"
# Calculate orders starting with COM
QUEUE=(COM)
DIRECT_LINKS=0
INDIRECT_LINKS=0
while [[ ${#QUEUE[@]} -gt 0 ]]; do
	NEWQUEUE=""
	for PARENT in ${QUEUE[@]}; do
		PARENT_ORDER=${ORDERS[$PARENT]}
		CHILDREN_STRING=${MAP_CHILD[$PARENT]}
		for CHILD in $CHILDREN_STRING; do
			((DIRECT_LINKS=DIRECT_LINKS+1))
			((INDIRECT_LINKS=INDIRECT_LINKS+PARENT_ORDER))
			ORDERS[$CHILD]=$((PARENT_ORDER+1))
		done
		NEWQUEUE+=$CHILDREN_STRING
	done
	QUEUE=($NEWQUEUE)
done

echo $((INDIRECT_LINKS+DIRECT_LINKS))
