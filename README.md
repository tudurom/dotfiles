tudurom's dotfiles
==================

> you are your dotfiles

A mix of style and usability, these are my dotfiles. This repo is structured in a way first-time Linux users and ricers can understand what's going on, with explications for each directory.

Managing
--------

I manage my dotfiles using GNU Stow. [Here's a neat article about managing your dotfiles with stow](http://blog.xero.nu/managing_dotfiles_with_gnu_stow).

Directory structure
-------------------

```
.
├── README.md
├── alsa - sound config for linux
├── asciiart - ascii art bin
├── bspwm - old rice, keeping it for historical purposes
├── compton - window compositor
├── cwm - window manager of choice
├── firefox - theme for firefox
├── git - global git config
├── gtk - theme
├── mpd - music player daemon
├── ncmpcpp - client for mpd. theme file is here
├── npm - Node.js package manager. i have a simple config for installing packages in the home folder
├── nvim - text editor that i use
├── ports - CRUX ports
├── pre_magic.sh - script that does magic after stowing the files
├── scripts
├── shell - configuration files for mksh
├── st - the terminal emulator i use
├── startpage - startpage for firefox
├── tmux - configs for Terminal MUltipleXer
├── vimperator - cool firefox addon i use for vim style keybindings
├── wallpapers
├── wmrc - wmutils scripts
├── x - x resources and .xinitrc
├── xdg
└── xmodmap - keybind changes and fixes for media keys under freebsd
```

24 directories, 2 files

Backups
-------

In case of fire, my dotfiles are mirrored on a number of servers:

- [GitHub](https://github.com/tudurom/dotfiles)
- [notabug](https://notabug.org/tudurom/dotfiles)
- [sr.ht](https://gogs.sr.ht/xenogenesis/dotfiles)
- [gitgud](https://gitgud.io/tudurom/dotfiles_backup)
- [my server](http://thetudor.ddns.net/git/dotfiles/log.html)

