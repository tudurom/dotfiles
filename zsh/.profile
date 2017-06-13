## Self-explanatory
LANG="en_US.UTF-8"
LC_TIME="ro_RO.UTF-8"

## Programs to use
EDITOR=nvim
VISUAL=nvim
PAGER=less
BROWSER=chromium
CC=clang

## Settings
LS_COLORS=''
MAKEFLAGS=-j5
MANWIDTH=80
LESS='-F -g -i -M -R -S -w -X -z-4'
GOPATH="$HOME/gopath"
SUDO_PROMPT="[sudo] auth $(tput bold)$(tput setaf 1)%U$(tput sgr0) "
FZF_DEFAULT_OPTS='--color=16'
FZF_DEFAULT_COMMAND='git ls-tree -r --name-only HEAD || ag -g ""'

PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin/core_perl:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/.node/bin"

# download folder is on ramdisk
test -d "$HOME/tmp/downloads" || mkdir "$HOME/tmp/downloads"

export LANG LC_TIME EDITOR VISUAL PAGER BROWSER CC LS_COLORS MAKEFLAGS MANWIDTH LESS GOPATH SUDO_PROMPT FZF_DEFAULT_OPTS FZF_DEFAULT_COMMAND PATH
