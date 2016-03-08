export PATH="$PATH:$HOME/.scripts"
export BSPWM_STATE="/tmp/bspwm-state.json"
export PANEL_FIFO="/tmp/panel-fifo"
export IOUP_TOKEN="$(cat ~/.iotoken)"
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
