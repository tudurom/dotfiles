# Ruby
if which ruby > /dev/null 2>&1; then
    ruby_ver="$(ls -1 $HOME/.gem/ruby | sort -nr | head -n 1)"
    export PATH="$HOME/.gem/ruby/$ruby_ver/bin:$PATH"
	unset ruby_ver
fi
