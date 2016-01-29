#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# bumblebee stuff
#optirun true
#intel-virtual-output

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

xset +fp ~/.fonts
xset fp rehash

#xrandr --output VIRTUAL1 --off --output LVDS1 --mode 1600x900 --pos 1920x180 --rotate normal --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
#xrandr --output VIRTUAL1 --off --output LVDS1 --mode 1600x900 --pos 2128x180 --rotate normal --output VGA1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
sh ~/.screenlayout/layout.sh
compton -b &
mpd &
mpDris2 &
#exec i3
#exec herbstluftwm
exec wm
#exec gnome-session
