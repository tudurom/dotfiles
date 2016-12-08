mkdir -p "$HOME/tmp/downloads"

for f in $HOME/.zsh.d/*.zsh; do
    . $f
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
