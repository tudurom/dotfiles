PATH="$PATH:/usr/local/bin:/sbin:$HOME/bin"
LANG="en_US.UTF-8"
LC_TIME="ro_RO.UTF-8"

test -f $HOME/.iotoken && IOUP_TOKEN="$(cat ~/.iotoken)"

export PATH LANG LC_TIME IOUP_TOKEN

. $HOME/.zsh.d/export.zsh
