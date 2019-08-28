. $HOME/.profile

## STYLE

setopt prompt_subst

# print error if no match for filename
setopt nomatch
# notify about background jobs
setopt notify
# enable comments in interactive mode
setopt interactive_comments

autoload -U colors && colors
autoload -U zmv
autoload compdef

# A simple arrow
# Cyan on exit success, red otherwise
PROMPT='%{$fg[red]%(? $fg[cyan] )%}> %f'

setopt extendedglob
setopt nocaseglob
setopt no_hup

## ALIASES
alias :q=exit
alias ls="ls -F"
alias ll="ls -alF"
alias rm="rm -I"
alias clip="xclip -selection clipboard"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias go="CC=gcc CXX=g++ go"
test "$(uname)" = "FreeBSD" && alias tput="/usr/local/bin/tput"

## COMPLETION

autoload -Uz compinit && compinit
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt COMPLETE_ALIASES
setopt correct

## MISC ENVIRONMENT VARIABLES

if which ruby > /dev/null 2>&1; then
    ruby_ver="$(ls -1 $HOME/.gem/ruby | sort -nr | head -n 1)"
    export PATH="$HOME/.gem/ruby/$ruby_ver/bin:$PATH"
	unset ruby_ver
fi

## HISTORY

HISTFILE="$HOME/.zhistory"
setopt append_history
HISTSIZE=1200
SAVEHIST=1000
setopt hist_expire_dups_first
setopt extended_history
setopt share_history

## KEYBINDS

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

## HOOKS

autoload -Uz add-zsh-hook
function xterm_title_precmd () {
	print -Pn '\e]2;%n@%m %1~\a'
}

function xterm_title_preexec () {
	print -Pn '\e]2;%n@%m %1~ %# '
	print -n "${(q)1}\a"
}

if [[ "$TERM" == (screen*|xterm*|rxvt*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

## FUNCTIONS

# lmao
paw() {
	pkill -f telegram-desktop
}

nvim() {
	# Set the name of neovim's socket
	local fn="$(mktemp -u "/tmp/nvimsocket-XXXXXXX")"
	NVIM_LISTEN_ADDRESS=$fn /usr/bin/nvim $@
}

testnet() {
    ping duckduckgo.com
}

ghclone() {
    git clone https://github.com/${1}.git ${2}
}

transfer() {
    local tmpfile="$(mktemp -t tranferXXX)"
    curl --progress-bar --upload-file $1 "https://transfer.sh/$(basename $1)" >> $tmpfile
    cat $tmpfile
    rm -rf $tmpfile
    unset tmpfile
}

pi() {
    ssh tudoo $@
}

push() {
    local branch="${1:-master}"
    git remote | while read -r line; do
        git push $line $branch
    done
}

# Just for fun
tehno() {
    mpv http://radio.2f30.org:8000/live.mp3
}

trinitas() {
	# mostly used as a joke.
	# trinitas is the radio of the romanian orthodox church
    mpv http://live.radiotrinitas.ro:8003
}

les() {
    if [[ "$#" -gt 0 ]]; then
        test -d "$1" && ls -al "$1" || less "$1"
    else
        ls
    fi
}

x0st() {
    curl -F"file=@${1}" https://0x0.st
}

up() {
	test $# -eq 0 && cd .. && return
	local i=0
	local p=""
	while [ $i -lt $1 ]; do
		p="../$p"
		i=$((i + 1))
	done

	cd $p
}

man() {
	env \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			man "$@"
}

## EMACS
if [[ -n "$INSIDE_EMACS" ]]; then
	print -P "\033AnSiTu %n"
	print -P "\033AnSiTc %d"
fi

## FZF

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
_fzf_compgen_path() {
	ag -g "" "$1"
}

# Added by Krypton
export GPG_TTY=$(tty)

export RUST_BACKTRACE=1
