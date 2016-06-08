#!/bin/sh

#  ╻ ╻╻┏┓╻╻╺┳╸┏━┓┏━╸
#  ┏╋┛┃┃┗┫┃ ┃ ┣┳┛┃
# ╹╹ ╹╹╹ ╹╹ ╹ ╹┗╸┗━╸
# by tudurom
# no login manager since forever

# Strange things from the default .xinitrc {{{
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
# }}}

# Load fonts
xset +fp ~/.fonts
xset fp rehash

# Start nice programs {{{

xmodmap ~/.xmodmaprc
# URxvt clipboard magic
autocutsel -selection clipboard -fork

# Multi monitor
screenlayout
# Github: airblader/unclutter-xfixes
# unclutter -b

# Music!
if ! pidof musicpd; then
  musicpd &
fi
# Set cursor from X to pointer
xsetroot -cursor_name left_ptr &
# Listen to popup requests
notifyd &
# Window compositor
compton -b
# Wallpaper
wall-e &

# }}}

statusbar &
exec startwm cwm
