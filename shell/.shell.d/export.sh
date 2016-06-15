export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# Golang specific variables
if [ -f /usr/bin/go ]; then
    export GOPATH=$HOME/gopath
    export GOROOT=/usr/lib/go
    export PATH="$PATH:$GOROOT/bin"
    export PATH="$PATH:$GOPATH/bin"
fi

# Ruby
if [ -f /usr/bin/ruby ]; then
    ruby_ver="$(ls -1 $HOME/.gem/ruby | sort -nr | head -n 1)"
    export PATH="$PATH:$HOME/.gem/ruby/$ruby_ver/bin"
fi

# JS
if [ -f /usr/bin/node ]; then
    export PATH="$PATH:$HOME/.node/bin"
fi

# Source local scripts
export PATH="$PATH:$HOME/bin/clint:$HOME/bin"

# Python packages
export PATH="$PATH:$HOME/.local/bin"

# I totally forgot what all those flags do
export LESS='-F -g -i -M -R -S -w -X -z-4'
