# ┏━╸┏━┓┏━┓┏━┓┏━┓┏━┓╻ ╻
# ┃  ┣┳┛┃ ┃┗━┓┗━┓┗━┓┣━┫
# ┗━╸╹┗╸┗━┛┗━┛┗━┛┗━┛╹ ╹
# by tudurom
# bits shared between different shells (bash, mksh, zsh)

if [[ $- == *i* ]] && [[ -z "$TMUX" ]]; then
  if [[ $(tmux ls | grep -v "attached" | wc -l) -gt 0 ]]; then
    # Auto-attach to the first detached one
    exec tmux a -t $(tmux ls | grep -v "attached" | head -n 1 | awk -F: '{print $1}')
  else
    exec tmux
  fi
fi

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
alias rm="rm -i"
alias fkh="fortune khaled"
alias ls="ls -N"
export LESS='-F -g -i -M -R -S -w -X -z-4'

#source ~/.scripts/base16-ocean.dark.sh
source "$HOME/.homesick/repos/homeshick/homeshick.sh"

# The Fuck is real
eval $(thefuck --alias)

#fortune | lolcat

# Remove unnecessary packages
pclean() {
  sudo pacman -Rsn $(pacman -Qdtq)
}

testnet() {
  while true; do
    ping google.com
  done
}

cless() {
  pygmentize -f terminal "$1" | less -R
}

ghclone() {
  git clone https://github.com/${1}.git
}

fortune khaled | echo "$(toilet -f term --gay)\n"
