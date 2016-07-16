export PATH="$PATH:$HOME/.scripts"
export BSPWM_STATE="/tmp/bspwm-state.json"
export PANEL_FIFO="/tmp/panel-fifo"
test -f $HOME/.iotoken && export IOUP_TOKEN="$(cat ~/.iotoken)"
test -f $HOME/.srtoken && export SHRT_TOKEN="$(cat ~/.srtoken)"

export GOROOT="/usr/lib/go"

test -f $HOME/.scripts/wmrc && . $HOME/.scripts/wmrc
test -f $HOME/.scripts/panelsrc && . $HOME/.scripts/panelsrc
test -f $HOME/.scripts/iconsrc && . $HOME/.scripts/iconsrc

. $HOME/.shell.d/export.sh
