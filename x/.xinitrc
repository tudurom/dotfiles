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
cmuslauncher
# Set cursor from X to pointer
xsetroot -cursor_name left_ptr &
# Wallpaper
wall-e &

# Java fix
wmname LG3D

mpDris2 &

wm() {
	# Listen to popup requests
	notifyd &
	# Window compositor
	compton -b
	minbar &
	touchpadopts
	wm=windowchef
	sxhkd -c $HOME/.config/sxhkd/sxhkdrc_${wm} $HOME/.config/sxhkd/commons &
	(sleep 1 && swtheme stairs) &
	exec $wm
}
wm
#exec gnome-session
