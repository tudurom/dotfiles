## Self-explanatory
export LANG="ro_RO.UTF-8"
export LC_TIME="ro_RO.UTF-8"

## Programs to use
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export CC=clang
export CXX=clang++

export GOPATH=$HOME/gopath

## Settings
export LS_COLORS=''
export MAKEFLAGS=-j$(( $(grep -c processor /proc/cpuinfo) + 2 ))
export MANWIDTH=80
export SUDO_PROMPT="[sudo] auth $(tput bold)$(tput setaf 1)%U$(tput sgr0) "
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit
export MOZ_ENABLE_WAYLAND=1
# https://mastransky.wordpress.com/2020/03/16/wayland-x11-how-to-run-firefox-in-mixed-environment/
export MOZ_DBUS_REMOTE=1

export PATH="$HOME/.cargo/bin:$GOPATH/bin:$HOME/bin:$HOME/.local/bin:$HOME/.node/bin:$PATH"

export GTK_MODULES=appmenu-gtk-module
export SAL_USE_VCLPLUGIN=gtk

RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
export RUST_SRC_PATH

# vim: set ft=sh :
