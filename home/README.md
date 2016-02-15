# ~

## Home

### Explanation

* `.asoundrc` - ALSA configuration. Trying to use PulseAudio as less as possible.
* `.compton.conf` - Compton config. Compton is a "window compozitor" - is the program that draws the windows on the screen and applies effects like shadows and opacity.
* `.crosssh.sh` - configuration for `ksh`-based shells, like `mksh`, `bash` and `zsh`. Mainly aliases.
* `.gtkrc-2.0` - GTK config. This is where I specify global fonts and theme.
* `.i3blocks.conf` - from the day I was using i3. Bar config.
* `.mkshrc` - actual shell config. I'm now using `bash` or `zsh` but `mksh`, because it's simple and fast.
* `.tmux.conf` - tmux config. TerMinal MultipleXer. A window manager for the shell with the ability to detach sessions (to run them in background and then resume them)
* `.xinitrc` - bash script executed by `startx` when starting the X session (duh).

### Directory structure

If a directory is not included here then check the README in the corresponding directory.

```
.
├── .ncmpcpp - ncmpcpp is a client for MPD, a music server
│   └── config
├── Pictures - Wallpapers. See for yourself.
├── .tmux
    └── bin
        └── statusline - tmux statusline, yeah. That's a bash script
├── .vimperator
    └── colors
        └── ocean.vimp - vimperator theme
└── .Xresources
```
