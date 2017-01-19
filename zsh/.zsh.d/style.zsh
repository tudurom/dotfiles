setopt prompt_subst

# vi-style keybinds
bindkey -v

# cd into dir if the command is the name of a dir
# and the command does not exist
setopt autocd
# print error if no match for filename
setopt nomatch
# notify about background jobs
setopt notify
# enable interactive comments in interactive mode
setopt interactive_comments

autoload -U colors && colors
autoload -U zmv

pwdcolor='$fg_bold[black]'
if [ -f "$HOME/bin/wmrc" ] && [ -n "$DISPLAY" ]; then
	. $HOME/bin/wmrc
	if [ "$COLOR_STYLE" = "light" ]; then
		pwdcolor='$fg_bold[white]'
	fi
fi
PROMPT="%{$pwdcolor%}"'[%(4~|.../%3~|%~)] %{$fg[red]%(? $fg[cyan] )%}> %f'

setopt extendedglob
setopt nocaseglob
setopt no_hup
