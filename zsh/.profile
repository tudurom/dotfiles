## Self-explanatory
LANG="en_US.UTF-8"
LC_TIME="ro_RO.UTF-8"

## Programs to use
EDITOR=nvim
VISUAL=nvim
PAGER=less
BROWSER=firefox-developer
CC=clang
CXX=clang++

## Settings
LS_COLORS=''
MAKEFLAGS=-j3
MANWIDTH=80
LESS='-F -g -i -M -R -S -w -X -z-4'
GOPATH="$HOME/gopath"
SUDO_PROMPT="[sudo] auth $(tput bold)$(tput setaf 1)%U$(tput sgr0) "
FZF_DEFAULT_OPTS='--color=16'
FZF_DEFAULT_COMMAND='git ls-tree -r --name-only HEAD || ag -g ""'

PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin/core_perl:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$HOME/.node/bin:$HOME/build/bin"

export LANG LC_TIME EDITOR VISUAL PAGER BROWSER CC LS_COLORS MAKEFLAGS MANWIDTH LESS GOPATH SUDO_PROMPT FZF_DEFAULT_OPTS FZF_DEFAULT_COMMAND PATH

# cyber by tudurom

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P00e1f22"
    echo -en "\e]P1a85659"
    echo -en "\e]P2668e8c"
    echo -en "\e]P3c3b6a4"
    echo -en "\e]P4326d78"
    echo -en "\e]P5433c32"
    echo -en "\e]P6386e74"
    echo -en "\e]P7e0f2ec"
    echo -en "\e]P81c4b4e"
    echo -en "\e]P9eb8995"
    echo -en "\e]PA82aea9"
    echo -en "\e]PBe1d9ce"
    echo -en "\e]PCa7d2cd"
    echo -en "\e]PDaa9576"
    echo -en "\e]PE90c0bd"
    echo -en "\e]PFf0f8f3"
fi

clear

# vim: set ft=sh :
