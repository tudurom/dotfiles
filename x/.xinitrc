#!/bin/sh -x
#  ╻ ╻╻┏┓╻╻╺┳╸┏━┓┏━╸
#  ┏╋┛┃┃┗┫┃ ┃ ┣┳┛┃
# ╹╹ ╹╹╹ ╹╹ ╹ ╹┗╸┗━╸
# by tudurom
# no login manager since forever

. $HOME/.profile
. $HOME/bin/wmrc

# Load X resources
xrdb $HOME/.Xresources

# Load .profile (contains settings)
. $HOME/.profile

# Load fonts
refreshfonts

# Start nice programs
setxkbmap ro comma
xmodmap $HOME/.xmodmaprc
# URxvt clipboard magic
autocutsel -fork

# Multi monitor
screenlayout
# Github: airblader/unclutter-xfixes
unclutter -b

# Set cursor from X to pointer
xsetroot -cursor_name left_ptr &
# Wallpaper
wall-e &

redshift &

startpage &

if [ "$2" = "xfce" ]; then
	echo autobahn > /tmp/current_theme
	compton -b
	startxfce4
	exit
fi

wm() {
	# Listen to popup requests
	notifyd &
	# Window compositor
	compton -b
	wm=$1
	sxhkd -c $HOME/.config/sxhkd/sxhkdrc_${wm} $HOME/.config/sxhkd/commons &
	ruler &
	californium &
	(sleep 1 && swtheme navyandivory) &
	$wm
}
gnome() {
	exec gnome-session
}
wm bspwm
#gnome
