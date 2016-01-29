#!/bin/sh
#
# info.sh - displays info about wm, font, gtk theme
# copied from z3bra's blog
# modified by tudurom
#
lines=23
clear
c00=$'\e[0;30m'
c01=$'\e[0;31m'
c02=$'\e[0;32m'
c03=$'\e[0;33m'
c04=$'\e[0;34m'
c05=$'\e[0;35m'
c06=$'\e[0;36m'
c07=$'\e[0;37m'
c08=$'\e[1;30m'
c09=$'\e[1;31m'
c10=$'\e[1;32m'
c11=$'\e[1;33m'
c12=$'\e[1;34m'
c13=$'\e[1;35m'
c14=$'\e[1;36m'
c15=$'\e[1;37m'

f0=$'\e[1;30m'
f1=$'\e[1;37m'
f2=$'\e[0;37m'

kernel=$(uname -rmo)
system=$(sed 's/\s*[\(\\]\+.*$//' /etc/issue)

crop_offset="center"
xoffset=400
yoffset=0
imgtempdir="$HOME/.fetchimages"
fontwidth=30
gap=4
img=$(awk '/feh/ {printf $3}' "$HOME/.fehbg" | sed -e "s/'//g")
# Image size is half of the terminal
imgsize=$((((lines - 1) * fontwidth) / 2))
# Padding is half the terminal width + gap
padding=$(($(tput cols) / 2 + gap))
imgname="$crop_offset-${img##*/}"

# This check allows you to resize the image at launch
if [ -f "$imgtempdir/$imgname" ]; then
    imgheight=$(identify -format "%h" "$imgtempdir/$imgname")
    [ $imgheight != $imgsize ] && rm "$imgtempdir/$imgname"
fi

# Check to see if the tempfile exists before we do any cropping.
if [ ! -f "$imgtempdir/$imgname" ]; then
  # Check if the directory exists and create it if it doesn't
  [ ! -d "$imgtempdir" ] && (mkdir "$imgtempdir" || exit)

  # Get wallpaper size so that we can do a better crop
  size=($(identify -format "%w %h" $img))

  # This checks to see if height is geater than width
  # so we can do a better crop of portrait images.
  if [ ${size[1]} -gt ${size[0]} ]; then
    size=${size[0]}
  else
    size=${size[1]}
  fi

  # Crop the image and save it to  the $imgtempdir
  # By default we crop a square in the center of the image which is
  # "image height x image height".
  # We then resize it to the image size specified above.
  # (default 128x128 px, uses var $height)
  # This way we get a full image crop with the speed benefit
  # of a tiny image.
  convert \
    -crop "$size"x"$size"+0+0 \
    -gravity $crop_offset "$img" \
    -resize "$imgsize"x"$imgsize" "$imgtempdir/$imgname"
fi

if [ -n "$DISPLAY" ]; then
    WM=$(xprop -root _NET_SUPPORTING_WM_CHECK)
    wmname=$(xprop -id ${WM//* } _NET_WM_NAME | sed -re 's/.*= "(.*)"/\1/')
    fon=$(xrdb -query | sed -n 's/^UR.*\*font:\s*//p')
    if [[ $fon =~ "xft" ]]; then
        termfn=$(echo $fon | sed -re 's/xft:((\w+\s\w+)+):.*/\1/')
    else
        termfn=$(echo $fon | sed -re 's/^-\w+-(\w+)-.*/\1/')
    fi
    systfn=$(sed -n 's/^.*font.*"\(.*\)".*$/\1/p' ~/.gtkrc-2.0)
    gtktheme=$(sed -n 's/^gtk-theme.*"\(.*\)".*$/\1/p' ~/.gtkrc-2.0)
    icons=$(sed -n 's/^.*icon.*"\(.*\)".*$/\1/p' ~/.gtkrc-2.0)
else
    wmname="none"
    termfn="none"
    systfn="none"
fi

pkgnum=$(pacman -Q | wc -l)
birthd=$(sed -n '1s/^\[\([0-9-]*\).*$/\1/p' /var/log/pacman.log | tr - .)

cat << EOF



    ${c00}▉▉  | ${f1}OS ${f0}........... $f2$system
    ${c08}  ▉▉| ${f1}name ${f0}......... $f2$HOSTNAME
    ${c01}▉▉  | ${f1}birth day${f0}..... $f2$birthd
    ${c09}  ▉▉| ${f1}packages ${f0}..... $f2$pkgnum
    ${c02}▉▉  |
    ${c10}  ▉▉| ${f1}kernel ${f0}....... $f2$kernel
    ${c03}▉▉  | ${f1}wm ${f0}........... $f2$wmname
    ${c11}  ▉▉| ${f1}shell ${f0}........ $f2$SHELL
    ${c04}▉▉  |
    ${c12}  ▉▉| ${f1}terminal ${f0}..... $f2$TERM
    ${c05}▉▉  | ${f1}term font ${f0}.... $f2$termfn
    ${c13}  ▉▉| ${f1}system font ${f0}.. $f2$systfn
    ${c06}▉▉  |
    ${c14}  ▉▉| ${f1}gtk theme ${f0}.... $f2$gtktheme
    ${c07}▉▉  | ${f1}icon theme ${f0}... $f2$icons
    ${c15}  ▉▉|



EOF
img="$imgtempdir/$imgname"
if type -p /usr/lib/w3m/w3mimgdisplay >/dev/null 2>&1; then
  printf "0;1;$xoffset;$yoffset;$imgsize;$imgsize;;;;;$img\n4;\n3;" |\
    /usr/lib/w3m/w3mimgdisplay
fi

