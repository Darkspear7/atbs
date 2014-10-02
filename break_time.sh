#!/bin/bash

idleTime=$(( 10 * 60 * 1000  )) #(in miliseconds ) default: 10 min
activityTime=$(( 60 * 60 )) #(in seconds) default: 60 min

lastTimeIdle=$(date +%s)
postponeDuration=0

file="/tmp/break_script"

function disableDisplay {
    xset dpms force off
}

function enableDisplay {
    xset dpms force on
    xdotool mousemove 0 0
}

# check arguments
if [ $# -gt 0 ]; then
    case $1 in
        "postpone")
            echo "Break is Off" > $file
            echo "Postponed."
            notify-send "break_time postponed" -t 3000
            ;;
        *)
            echo "No operation for argument."
            ;;
    esac
    exit 0
fi

while sleep 5; do
    now=$(date +%s)
    echo "now: $now"
    echo "xprintidle: $(xprintidle); idleTime: $idleTime"
    if [ $(xprintidle) -gt $idleTime ]; then
        lastTimeIdle=$now
        echo "lastTimeIdle: $lastTimeIdle"
    fi
    activeFor=$(( $now - $lastTimeIdle ))
    echo "activeFor: $activeFor; activityTime: $activityTime + postpone: $postponeDuration"
    
    breakIn=$(( $activityTime + $postponeDuration - $activeFor ))
    if [ $breakIn -le 600 ]; then
        notify-send "Break in $breakIn seconds." -t 5000
    fi

    if [ $activeFor -ge $(( $activityTime + $postponeDuration )) ]; then
        onBreak=0
        breakTime=$(($idleTime / 1000 )) # division is required to get time in seconds
        breakPostponed=0
        disableDisplay
        echo "Break is On" > $file
        while sleep 5; do
            onBreak=$(( $onBreak + 5 ))
            # check file to see if break was postponeda
            if [ "$(cat $file | head -n 1)" != "Break is On" ]; then
                breakPostponed=1
                postponeDuration=$(( $postponeDuration + 5 * 60 ))
                echo "Postponed: $breakPostponed; duration: $postponeDuration"
                break
            fi
            echo "on break for: $onBreak; break time: $breakTime"
            if [ $onBreak -ge $breakTime ]; then
                break
            fi
            disableDisplay
        done
        
        echo "postponed: $breakPostponed"
        # if break was not posponed ( there was a full break )
        if [ $breakPostponed -eq 0 ]; then
            lastTimeIdle=$(date +%s)
            postponeDuration=0
            echo "Break is Off" > $file
        fi
        enableDisplay
    fi
done
