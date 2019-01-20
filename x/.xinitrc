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
	# Listen to popup requests
	notifyd &
	# Window compositor
	compton -b
	wm=$1
	sxhkd -c $HOME/.config/sxhkd/sxhkdrc_${wm} $HOME/.config/sxhkd/commons &
	ruler &
	trap "pkill -f musicwrap" EXIT
	pgrep -f lastplayerwrapper || lastplayerwrapper &
	(sleep 1 && swtheme street) &
	wall-e &
	exec $wm
}
gnome() {
	exec gnome-session
}
wm windowchef
#gnome
