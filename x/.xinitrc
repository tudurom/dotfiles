#!/bin/sh

#  ╻ ╻╻┏┓╻╻╺┳╸┏━┓┏━╸
#  ┏╋┛┃┃┗┫┃ ┃ ┣┳┛┃
# ╹╹ ╹╹╹ ╹╹ ╹ ╹┗╸┗━╸
# by tudurom
# no login manager since forever

. $HOME/bin/wmrc

# Load X resources
xrdb $HOME/.Xresources

# Load .profile (contains settings)
. $HOME/.profile

# Load fonts
xset +fp ~/.fonts
xset fp rehash

# Start nice programs

xmodmap $HOME/.xmodmaprc
# URxvt clipboard magic
autocutsel -selection clipboard -fork

# Multi monitor
screenlayout
# Github: airblader/unclutter-xfixes
unclutter -b

# Music!
if ! pidof mpd; then
	mpd &
fi
# Set cursor from X to pointer
xsetroot -cursor_name left_ptr &
# Wallpaper
wall-e &

# Java fix
wmname LG3D

startBar() {
	# Start the thing
	minbar &
}

mpDris2 &

wm() {
	# Listen to popup requests
	notifyd &
	# Window compositor
	compton -b
	startBar
	touchpadopts
	exec startwm windowchef
}
wm
#exec gnome-session
