tudurom's dotfiles
==================

> you are your dotfiles

A mix of style and usability, these are my dotfiles. This repo is structured in a way first-time Linux users and ricers can understand what's going on, with explications for each directory.

Managing
--------

I manage my dotfiles using GNU Stow. [Here's a neat article about managing your dotfiles with stow](http://blog.xero.nu/managing_dotfiles_with_gnu_stow).

List of programs
-----------------

* **Operating System**: [CRUX](http://crux.nu)
* **Text editor**: [neovim](http://neovim.io)
  * See `nvim/.config/nvim/init.vim` for plugins
* **Color scheme**: [cloudy](https://github.com/tudurom/dotfiles/blob/master/x/.xres/colors/cloudy)
* **Shell**: [mksh](https://www.mirbsd.org/mksh.htm)
  * Also using [tmux](https://wiki.archlinux.org/index.php/tmux).
* **Terminal emulator**: [suckless st](https://wiki.archlinux.org/index.php/St)
* **Window manager**: [wmutils](http://wmutils.io) + [my scripts](https://github.com/tudurom/dotfiles/tree/master/wmrc/.scripts)
  * **Panel**: [lemonbar](https://wiki.archlinux.org/index.php/Lemonbar) (see `wmrc/.scripts/*bar`)
* **Browser**: Firefox
  * **Theme**: Twily's modified
* **Music player**: [mpd](https://wiki.archlinux.org/index.php/Music_Player_Daemon) + [ncmpcpp](https://wiki.archlinux.org/index.php/Ncmpcpp)
* **Special Sauce**: [Rainbou](https://github.com/tudurom/rainbou) (configration
  file generator)

Directory structure
-------------------

```bash
~
─── tree -L 1
```

```
. <- you're here
├── alsa - Advanced Linux Sound Architecture config
├── asciiart - Random asciiart from everywhere
├── bspwm - old bspwm rice
├── cava - configs for cava, a sound visualizer
├── compton - configuration for compton, the best window compozitor
├── git - configuration file for git, the version control system
├── gtk - config for gtk and a micro stylesheet to avoid some bugs with some gtk themes
├── herbstluftwm - old herblasfhjasdklwm rice
├── i3 - ancient i3 (n00b) rice
├── mksh - Mir Korn SHell - my shell config. very simple shell
├── mpd - Music Player Daemon configuration
├── ncmpcpp - configration file for ncmpcpp, an ncurses Music Player Daemon (MPD) client
├── neofetch - neofetch config. very cool project
├── npm - small config for the Node Package Manager. i save all the packages in the home directory
├── nvim - configuration files for Neovim, the best text editor known to the mankind
├── README.md - README, the novel, written by tudurom
├── scripts - all my shell scripts used in my workflow
├── startpage - startpage
├── tmux - Terminal MUltipleXer configuration file and status bar script
├── vimperator - config for a neat extension for firefox. theme included
├── wallpapers - collection of wallpapers
├── wmrc - all files related to my wmutils setup - scripts and sxhkd config
└── x - x resources and xinitrc

21 directories, 1 file
```

TODO
----

- [ ] Document this setup more
  - [x] This README
  - [ ] A big article at the `gh-pages` branch

Backups
-------

In case of fire, these dotfiles are mirrored on a number of servers:

- [GitHub](https://github.com/tudurom/dotfiles)
- [notabug](https://notabug.org/tudurom/dotfiles)
- [sr.ht](https://gogs.sr.ht/xenogenesis/dotfiles)
- [gitgud](https://gitgud.io/tudurom/dotfiles_backup)
- [my server](http://thetudor.ddns.net/git/dotfiles/log.html)

