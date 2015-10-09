#!/bin/bash
# makes blink(1) turn red for 25 minutes (starting on the hour and half-hour) and then green for five minutes

blink_path=$(which blink1-tool)
if [ -z "$blink_path" ] ; then
	blink_path="../blink1-tool"
fi

tomato_color="255,0,0"
break_color="0,255,0"

paplay=$(which paplay)

function doBell {
	if [ ! -z "$paplay" ] ; then
		paplay /usr/share/sounds/KDE-Im-Highlight-Msg.ogg # beep
	fi
}

function setColor {
	$blink_path --rgb $1 --blink 4 > /dev/null 2>&1
	$blink_path --rgb $1 > /dev/null 2>&1
}

function setWork {
	doBell
	setColor $tomato_color
}

function setRest {
	doBell
	setColor $break_color
}

# change colors and beep:
while true ; do
	minutes=$(printf %d $(date +%M))
	seconds=$(printf %d $(date +%S))
	remaining=$((1800 - ($minutes * 60 + $seconds) % 1800))
	echo "remaining is: $remaining"
	if [ $remaining -gt 300 ] ; then
		setWork
		echo "setWork ; sleeping for" $(($remaining - 300))
		sleep $(($remaining - 300))
		setRest
		echo "setRest ; forcing sleep for 300"
		sleep 300
	else
		setRest
		echo "setRest ; sleeping for $remaining"
		sleep $remaining
	fi
done
