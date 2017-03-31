export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export BROWSER=chromium
export LS_COLORS=''
export CC=clang
export MAKEFLAGS=-j5

exists() {
	which "$1" > /dev/null
}

# Golang specific variables
export GOPATH=$HOME/gopath
export PATH="$PATH:$GOPATH/bin"

# Ruby
if exists ruby; then
    ruby_ver="$(ls -1 $HOME/.gem/ruby | sort -nr | head -n 1)"
    export PATH="$HOME/.gem/ruby/$ruby_ver/bin:$PATH"
	unset ruby_ver
fi

# Source local scripts
export PATH="$PATH:$HOME/bin"

# Python packages
export PATH="$PATH:$HOME/.local/bin"

# local
export PATH="$PATH:/usr/local/bin"

# I totally forgot what all these flags do
export LESS='-F -g -i -M -R -S -w -X -z-4'
