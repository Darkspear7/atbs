#!/bin/bash

to_do="enable"

DEVS="$(xinput --list | grep 'slave  pointer' |cut -d= -f2|cut -c1,2)"

for x in $DEVS; do
    if [ $to_do = "disable" ]; then
	xinput disable $x
    elif [ $to_do = "enable" ]; then
	xinput enable $x
    else
	echo "Pass 'disable' or 'enable'."
    fi
done
