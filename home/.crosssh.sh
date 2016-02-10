export EDITOR=nvim
export VISUAL=nvim
export GOPATH=$HOME/Go
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$HOME/.scripts:.scripts/clint:$GOPATH/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Aliases aka hacks
alias :q=exit
alias irb=pry
alias ccat=pygmentize
alias problemhelper="time problemhelper"
alias ph=problemhelper
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

