# emacs-style keybinds
bindkey -e

if source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}; then
	[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
	[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
	[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
	[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
	[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
	[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
	[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
	[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
	[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
	[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
	[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
else
	echo "Please run zkbd to create a new key file"
fi
