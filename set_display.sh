#!/bin/bash

activeOutputs=$(xrandr | grep -e " connected [^(]" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")

execute="xrandr "
target_display="$1"
isOn=false

# check if the target display is connected
check=false
for display in $connectedOutputs; do
    if [ $display == $target_display ]; then
        check=true
    fi
done

if ! $check; then
    echo "Display: $target_display, is not connected." 
    notify-send "Display: $target_display, is not connected." -t 5000
    exit
fi

# turn of all other active displays
# check if the target display is active
for display in $activeOutputs
do
    if [ $display != $target_display ]
    then
        execute=$execute"--output $display --off "
    else
        isOn=true
    fi
done

# if the target display is not active, activate it
if ! $isOn; then
    execute=$execute"--output $target_display --auto"
fi

if [ "$execute" == "xrandr " ]; then
    echo "No changes are necessary."
else
    echo "Resulting Configuration: "
    echo "Command: $execute"
    `$execute`
fi
