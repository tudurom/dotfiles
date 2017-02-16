# install zgen if needed
[ ! -d ~/.zgen ] && git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
source "$HOME/.zgen/zgen.zsh"

if ! zgen saved; then
	zgen oh-my-zsh "plugins/colored-man-pages"
	zgen oh-my-zsh "plugins/sudo"
	zgen oh-my-zsh "plugins/git"
	zgen load "supercrabtree/k"

	zgen save
fi
