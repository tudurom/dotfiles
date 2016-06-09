export EDITOR=nvim
export VISUAL=nvim

# Golang specific variables
if [ -d /usr/local/go ]; then
    export GOPATH=$HOME/gopath
    export GOROOT=/usr/local/go
    export PATH="$GOROOT/bin:$PATH"
    export PATH="$GOPATH/bin:$PATH"
fi

# Ruby
if [ -f /usr/local/bin/ruby ]; then
    export PATH=$HOME/.node/bin:$PATH
    ruby_ver="$(ls -1 $HOME/.gem/ruby | sort -nr | head -n 1)"
    export PATH=$HOME/.gem/ruby/$ruby_ver/bin:$PATH
fi

# Source local scripts
export PATH="$HOME/bin/clint:$HOME/bin:$PATH"

# Python packages
export PATH="$PATH:$HOME/.local/bin"

# I totally forgot what all those flags do
export LESS='-F -g -i -M -R -S -w -X -z-4'
