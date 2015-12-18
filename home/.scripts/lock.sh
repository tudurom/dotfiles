#!/bin/bash
playerctl pause
scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
[[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
playerctl pause
i3lock -u -i /tmp/screen.png
systemctl suspend
rm /tmp/screen.png

