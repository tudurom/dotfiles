export PATH="$PATH:$HOME/.scripts"
export BSPWM_STATE="/tmp/bspwm-state.json"
export PANEL_FIFO="/tmp/panel-fifo"
export IOUP_TOKEN="$(cat ~/.iotoken)"

export GOROOT="/usr/lib/go"

. $HOME/.scripts/wmrc
. $HOME/.scripts/panelsrc
. $HOME/.scripts/iconsrc
