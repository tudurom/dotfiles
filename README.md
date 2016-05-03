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

Screenshots
-----------

### [Sanity](http://pub.iotek.org/p/vBEtVnd.png)

### [2AM Ricing](http://pub.iotek.org/p/VsbSaGT.png)

### [Lost cat](http://pub.iotek.org/p/YdrGGvR.png)

### [First wmutils screenie](http://pub.iotek.org/p/9DIdJjP.png)

### [Previous BSPWM desktop](http://goo.gl/2vj5Yk)

### [Older BSPWM desktop](http://tudurom.github.io/albumify/view.html#eyJ0aXRsZSI6ImJzcHdtIC0gU3ByaW5nIiwiZGVzY3JpcHRpb24iOiIiLCJhbGJ1bSI6W3sicGljU3JjIjoiaHR0cDovL2kuaW1ndXIuY29tL0ZwNGJZTkwucG5nIiwidGl0bGUiOiJJbmZvIn0seyJwaWNTcmMiOiJodHRwOi8vaS5pbWd1ci5jb20vQ2lYQlowRC5wbmciLCJ0aXRsZSI6IlRlcm1zIn0seyJwaWNTcmMiOiJodHRwOi8vaS5pbWd1ci5jb20vbnA4cmRuTC5wbmciLCJ0aXRsZSI6IkNsZWFuIn0seyJwaWNTcmMiOiJodHRwOi8vaS5pbWd1ci5jb20vZGU2UEtJWi5wbmciLCJ0aXRsZSI6IlRlcm1zIHdpdGhvdXQgc3lzaW5mbyJ9XX0=)

### [Herbstluftwm](http://tudurom.github.io/albumify/view.html#eyJ0aXRsZSI6Imhsd20gLSBNb25vZHkgZnQuIFJ1YnkgcG93ZXJlZCBsZW1vbmJhciIsImRlc2NyaXB0aW9uIjoiV2hpbGUgSSB3YXMgcHJlcGFyaW5nIHRvIHB1c2ggYWxsIHRoZSByZW1haW5pbmcgY2hhbmdlcyB0byBnaXRodWIsIEkgcmFuIGBnaXQgcmVzZXQgLS1oYXJkYCBieSBtaXN0YWtlLiBJIGhhZCB0byByZS1tYWtlIGFsbCB0aGUgdGhpbmdzIEkgbWFkZSB0b2RheS4gRGlkIGl0IGluIGFuIGhvdXIhICIsImFsYnVtIjpbeyJwaWNTcmMiOiJodHRwOi8vaS5pbWd1ci5jb20vVzlUWms2eC5wbmciLCJ0aXRsZSI6IlNlbGZpZSB3aXRoIC9yL3VuaXhwb3JuIn0seyJwaWNTcmMiOiJodHRwOi8vaS5pbWd1ci5jb20valZmTE51Vy5wbmciLCJ0aXRsZSI6IkZha2UgZGlydHkifSx7InBpY1NyYyI6Imh0dHA6Ly9pLmltZ3VyLmNvbS9Zc0lteWVOLnBuZyIsInRpdGxlIjoiUm9maSJ9LHsicGljU3JjIjoiaHR0cDovL2kuaW1ndXIuY29tL0ZsMzdqTloucG5nIiwidGl0bGUiOiJDbGVhbiJ9LHsicGljU3JjIjoiaHR0cDovL2kuaW1ndXIuY29tLzU0WThpVnYucG5nIiwidGl0bGUiOiJuY21wY3BwIGFuZCBjYXZhIn0seyJwaWNTcmMiOiJodHRwOi8vaS5pbWd1ci5jb20vTEI2Q1F3OS5qcGciLCJ0aXRsZSI6IldhbGxwYXBlci4gQ3JlZGl0cyB0byBKb3JkYW4gR3JpbW1lciJ9XX0=)

### [i3](http://tudurom.github.io/albumify/view.html#eyJ0aXRsZSI6ImkzIC0gRmlyc3QgcmljZSIsImRlc2NyaXB0aW9uIjoiIiwiYWxidW0iOlt7InBpY1NyYyI6Imh0dHA6Ly9pLmltZ3VyLmNvbS96YVo0dHBoLnBuZyIsInRpdGxlIjoiQ2xlYW4ifSx7InBpY1NyYyI6Imh0dHA6Ly9pLmltZ3VyLmNvbS84blgxSGFlLnBuZyIsInRpdGxlIjoiRGlydHkifSx7InBpY1NyYyI6Imh0dHA6Ly9pLmltZ3VyLmNvbS9lNjVIN21JLnBuZyIsInRpdGxlIjoiQmx1ZSByb2ZpIn0seyJwaWNTcmMiOiJodHRwOi8vaS5pbWd1ci5jb20vOXdQYTA5WC5wbmciLCJ0aXRsZSI6IlNjcmVlbmZldGNoIn1dfQ==)

