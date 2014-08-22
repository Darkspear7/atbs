#!/bin/bash

dir=~/Pictures

cd $dir


while true; do
	list=($(find . -maxdepth 1 -type f | shuf))
	n=${#list[@]}
	
	primaryPicture="${list[RANDOM % n]}"
	secondaryPicture="${list[RANDOM % n]}"
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s $dir/$primaryPicture
	xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor1/image-path -s $dir/$secondaryPicture
	
	sleep 60 # sleep for one minute
done
