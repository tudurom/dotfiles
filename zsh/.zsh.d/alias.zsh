alias :q=exit
alias tls="tmux ls"
alias ls="ls -F"
alias ll="ls -alF"
alias tswitch="tmux switch -t"
alias tkill="tmux kill-session -t"
alias rm="rm -I"
alias clip="xclip -selection clipboard"
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias rnb="toilet -f future"
test "$(uname)" = "FreeBSD" && alias tput="/usr/local/bin/tput"

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
    ssh tudoo $1
}

push() {
    local branch="${1:-master}"
    git remote | while read -r line; do
        git push $line $branch
    done
}

tehno() {
    mpv http://radio.2f30.org:8000/live.mp3
}

trinitas() {
	# mostly used as a joke.
	# trinitas is the radio of the romanian orthodoc church
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

mtp() {
    sudo simple-mtpfs /mnt -o allow_other
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
