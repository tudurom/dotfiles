#!/bin/sh
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
autocutsel -selection clipboard -fork

# Multi monitor
screenlayout
# Github: airblader/unclutter-xfixes
unclutter -b

# Set cursor from X to pointer
xsetroot -cursor_name left_ptr &
# Wallpaper
wall-e &

redshift &
mpd &
wm() {
	# Listen to popup requests
	notifyd &
	# Window compositor
	compton -b
	touchpadopts
	Thunar --daemon &
	wm=windowchef
	sxhkd -c $HOME/.config/sxhkd/sxhkdrc_${wm} $HOME/.config/sxhkd/commons &
	test -f "$HOME/.config/ruler/rulerrc_${wm}" && \
	ruler $HOME/.config/ruler/rulerrc_${wm} &
	(sleep 1 && swtheme navyandivory) &
	$wm
}
gnome() {
	mpDris2 &
	exec gnome-session
}
wm
#gnome
