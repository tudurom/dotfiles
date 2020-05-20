set -xg LANG 'ro_RO.UTF-8'
set -xg LC_TIME 'ro_RO.UTF-8'

## Programs to use
set -xg EDITOR nvim
set -xg VISUAL nvim
set -xg PAGER less
set -xg CC clang
set -xg CXX clang++

set -xg GOPATH $HOME/gopath

## Settings
set -xg LS_COLORS ''
set -xg MAKEFLAGS -j( math (grep -c processor /proc/cpuinfo) + 2 )
set -xg MANWIDTH 80
set -xg SUDO_PROMPT "[sudo] auth "(set_color -o red)"%U"(set_color normal)" "
set -xg _JAVA_AWT_WM_NONREPARENTING 1
set -xg AWT_TOOLKIT MToolkit
set -xg MOZ_ENABLE_WAYLAND 1
# https://mastransky.wordpress.com/2020/03/16/wayland-x11-how-to-run-firefox-in-mixed-environment/
set -xg MOZ_DBUS_REMOTE 1

set -xg PATH "$HOME/.cargo/bin:$GOPATH/bin:$HOME/bin:$HOME/.local/bin:$HOME/.node/bin:$PATH"

set -xg GTK_MODULES appmenu-gtk-module
set -xg SAL_USE_VCLPLUGIN gtk

if type -q rustc
    set -xg RUST_SRC_PATH (rustc --print sysroot)"/lib/rustlib/src/rust/src"
end
set -xg RUST_BACKTRACE 1

alias ls 'ls --color=auto -F'
alias ll 'ls --color=auto -alF'
alias rm 'rm -I'
alias clip 'wl-copy'
alias poweroff 'systemctl poweroff'
alias reboot 'systemctl reboot'
