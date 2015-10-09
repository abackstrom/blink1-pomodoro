#!/bin/bash
# makes blink(1) turn red for $pomodoro_length minutes and then green for $break_length minutes

blink_path=$(which blink1-tool)
if [ -z "$blink_path" ] ; then
	blink_path="../blink1-tool"
fi

pomodoro_color="255,0,0"
break_color="0,255,0"

pomodoro_length=25 # length of tomato in minutes

break_length=5 # length of break in minutes

let pomodoro_secs=$pomodoro_length*60
let break_secs=$break_length*60

function setColor {
	$blink_path --rgb $1 --blink 4 > /dev/null 2>&1
	$blink_path --rgb $1 > /dev/null 2>&1
}

function setWork {
	setColor $pomodoro_color
}

function setRest {
	setColor $break_color
}

pomodoro=0

while true; do
	echo "$pomodoro_secs"
	let pomodoro+=1
	echo "Now beginning pomodoro # $pomodoro"
	setWork
	sleep $pomodoro_secs
	setRest
	sleep $break_secs
done
