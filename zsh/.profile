export PATH="$PATH:/usr/local/bin:/sbin:$HOME/bin"
export BSPWM_STATE="/tmp/bspwm-state.json"
export PANEL_FIFO="/tmp/panel-fifo"
export LANG="en_US.UTF-8"
export LC_TIME="ro_RO.UTF-8"
test -f $HOME/.iotoken && export IOUP_TOKEN="$(cat ~/.iotoken)"

export GOROOT="/usr/lib/go"

#test -f "$HOME/bin/wmrc" && . $HOME/bin/wmrc
#test -f "$HOME/bin/panelsrc" && . $HOME/bin/panelsrc
#test -f "$HOME/bin/iconsrc" && . $HOME/bin/iconsrc

. $HOME/.zsh.d/export.zsh
