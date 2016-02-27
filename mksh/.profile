export PATH="$PATH:$HOME/.scripts"
export BSPWM_STATE="/tmp/bspwm-state.json"
export PANEL_FIFO="/tmp/panel-fifo"
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
