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
export GOPATH=$HOME/Go
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$HOME/.scripts:.scripts/clint:$GOPATH/bin:$PATH"
export PATH=$HOME/.node/bin:$PATH

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
export LESS='-F -g -i -M -R -S -w -X -z-4'

# The Fuck is real
eval $(thefuck --alias)

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

