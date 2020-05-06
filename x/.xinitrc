#!/bin/sh
#  ╻ ╻╻┏┓╻╻╺┳╸┏━┓┏━╸
#  ┏╋┛┃┃┗┫┃ ┃ ┣┳┛┃
# ╹╹ ╹╹╹ ╹╹ ╹ ╹┗╸┗━╸
# by tudurom
# no login manager since forever

. $HOME/.profile

# Load X resources
xrdb $HOME/.Xresources
# Load fonts
refreshfonts
screenlayout &
# Start nice programs
setxkbmap ro comma
xmodmap $HOME/.xmodmaprc
# URxvt clipboard magic
autocutsel -fork
# Github: airblader/unclutter-xfixes
unclutter -b
# Set cursor from X to pointer
xsetroot -cursor_name left_ptr &
redshift &

if [ $1 = '-o' ]; then
	exit
fi

wm() {
	wm=$1

	# Listen to popup requests
	notifyd &
	# Window compositor
	compton -b
	sxhkd -c $HOME/.config/sxhkd/sxhkdrc_${wm} $HOME/.config/sxhkd/commons &
	ruler &
	lastplayer &
	wall-e &
	exec $wm
}
gnome() {
	exec gnome-session
}
wm windowchef
#gnome
