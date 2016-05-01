export PATH="$PATH:$HOME/.scripts"
export BSPWM_STATE="/tmp/bspwm-state.json"
export PANEL_FIFO="/tmp/panel-fifo"
export IOUP_TOKEN="$(cat ~/.iotoken)"

export GOROOT="/usr/lib/go"

test -f $HOME/.scripts/wmrc && . $HOME/.scripts/wmrc
test -f $HOME/.scripts/panelsrc && . $HOME/.scripts/panelsrc
test -f $HOME/.scripts/iconsrc && . $HOME/.scripts/iconsrc
