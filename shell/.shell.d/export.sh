export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

# Golang specific variables
if [ -f /usr/bin/go ]; then
    export GOPATH=$HOME/gopath
    export GOROOT=/usr/lib/go
    export PATH="$GOROOT/bin:$PATH"
    export PATH="$GOPATH/bin:$PATH"
fi

# Ruby
if [ -f /usr/bin/ruby ]; then
    ruby_ver="$(ls -1 $HOME/.gem/ruby | sort -nr | head -n 1)"
    export PATH=$HOME/.gem/ruby/$ruby_ver/bin:$PATH
fi

# JS
if [ -f /usr/bin/node ]; then
    export PATH=$HOME/.node/bin:$PATH
fi

# Source local scripts
export PATH="$HOME/bin/clint:$HOME/bin:$PATH"

# Python packages
export PATH="$PATH:$HOME/.local/bin"

# I totally forgot what all those flags do
export LESS='-F -g -i -M -R -S -w -X -z-4'
