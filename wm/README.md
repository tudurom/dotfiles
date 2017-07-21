# `wm`

## Hand-crafted shell-based mini desktop environment

`wm` is not a window manager on its own, but a set of scripts and configuration
files that assemble a comfortable work flow, like a status bar, window tiler
(for stacking window managers), notification
system and theme switcher.

Supported window managers:

| WM                                                   | Tiling? |
|------------------------------------------------------|---------|
| [bspwm](https://github.com/baskerville/bspwm/)       | Yes     |
| [herbstluftwm](http://herbstluftwm.org/)             | Yes     |
| [windowchef](https://github.com/tudurom/windowchef/) | No      |

## Dependencies

* [wmutils](https://github.com/wmutils/) (core and opt)
* [lemonbar](https://github.com/lemonboy/bar/)
* [dmenu](http://tools.suckless.org/dmenu/)
* [xrq](https://github.com/arianon/xrq/)
* [colort](https://github.com/neeasade/colort/)
* [sxhkd](https://github.com/baskerville/sxhkd/)
* [xqp](https://github.com/baskerville/xqp/)
* [rainbou](https://github.com/tudurom/rainbou/)
* [ruler](https://github.com/tudurom/ruler/)
* [disputils](https://github.com/tudurom/disputils/)
* [nvr](https://github.com/mhinz/neovim-remote/)

There may be more.

## Scripts

### Core

* `wmrc` - central configuration file. Sources values from the currently
selected theme.

### Theming

* `changecolors` - set terminal colors dynamically.
* `swtheme` - change theme and update configuration files dynamically. Uses
mustache templates for its magic.
* `theme_menu` - show the user a nice theme menu

### Information

* `minbar` - minimal status bar. [Screenshot](https://ptpb.pw/Q0ON.png). Shows
the current date, time, song and battery level.
* `notifyd` - Simple FIFO-based notification daemon.
	* `notifyd-musicd` - `notifyd` module. Prints the currently playing song on
	status change.
	* `notifyd-libnotify` - `libnotify` bridge.

### Misc

* `dmenu_wrapper` - Execute dmenu with custom colors.
* `popup` - Pop up a panel with some text. Used by `notifyd` to spawn its
panels.
* `tilew` - Tile windows.
* `touchpadopts` - Configure touchpad driver.
* `windowat` - Get the id of the first window at the given coordinates.
