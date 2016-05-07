# ┏━╸┏━┓┏━┓┏━┓┏━┓┏━┓╻ ╻
# ┃  ┣┳┛┃ ┃┗━┓┗━┓┗━┓┣━┫
# ┗━╸╹┗╸┗━┛┗━┛┗━┛┗━┛╹ ╹
# by tudurom
# bits shared between different shells (bash, mksh, zsh)

# if [[ $- == *i* ]] && [[ -z "$TMUX" ]]; then
#   if [[ $(tmux ls | grep -v "attached" | wc -l) -gt 0 ]]; then
#     # Auto-attach to the first detached one
#     exec tmux a -t $(tmux ls | grep -v "attached" | head -n 1 | cut -d: -f1)
#   else
#     exec tmux
#   fi
# fi

export EDITOR=nvim
export VISUAL=nvim

# Golang specific variables
if [ -d /usr/local/go ]; then
    export GOPATH=$HOME/gopath
    export GOROOT=/usr/local/go
    export PATH="$GOROOT/bin:$PATH"
    export PATH="$GOPATH/bin:$PATH"
fi

# Ruby
if [ -f /usr/bin/ruby ]; then
    export PATH=$HOME/.node/bin:$PATH
    ruby_ver="$(ls -1 $HOME/.gem/ruby | sort -nr | head -n 1)"
    export PATH=$HOME/.gem/ruby/$ruby_ver/bin:$PATH
fi

# Source local scripts
export PATH="$HOME/bin/clint:$HOME/bin:$PATH"

# Aliases aka hacks
alias :q=exit
alias irb=pry
alias ccat=pygmentize
alias problemhelper="time problemhelper"
alias ph=problemhelper
alias tls="tmux ls"
alias tswitch="tmux switch -t"
alias tkill="tmux kill-session -t"
alias rm="rm -I"
alias fkh="fortune khaled"
alias ls="ls -N"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Remove unnecessary packages
pclean() {
    sudo pacman -Rns $(pacman -Qdtq)
}

testnet() {
    ping duckduckgo.com
}

cless() {
    pygmentize -f terminal "$1" | less -R
}

ghclone() {
    git clone https://github.com/${1}.git
}

transfer() {
    local tmpfile="$(mktemp -t tranferXXX)"
    curl --progress-bar --upload-file $1 "https://transfer.sh/$(basename $1)" >> $tmpfile
    cat $tmpfile
    rm -rf $tmpfile
    unset tmpfile
}

pi() {
    ssh tudoo $1
}

