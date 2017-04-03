alias :q=exit
alias ls="ls -F"
alias ll="ls -alF"
alias rm="rm -I"
alias clip="xclip -selection clipboard"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
test "$(uname)" = "FreeBSD" && alias tput="/usr/local/bin/tput"

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
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			man "$@"
}
