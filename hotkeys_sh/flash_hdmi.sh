#!/bin/bash

message="Flash audio set to"

if [ -f "/home/dragos/.asoundrc" ]; then
    rm -f "/home/dragos/.asoundrc"
    message=$message" default audio output."
else
    echo "pcm.!default {
    type hw
    card 0
    device 3
}" > /home/dragos/.asoundrc
    message=$message" hdmi audio output."
fi

sudo alsa force-reload
notify-send "$message" -t 5000
