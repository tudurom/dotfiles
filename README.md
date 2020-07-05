# Tudor's dotfiles

My dotfiles are managed using [home-manager](https://github.com/rycee/home-manager) and [Nix](https://nixos.org/).
My OS is NOT NixOS. As such, my configs have some slight hacks to allow them to work on every Linux system (graphical apps too).

## Installation

For non-NixOS:

1. Install Nix
2. Install home-manager
3. Clone this repo somewhere (let's say `~/dotfiles`)
4. In the `machines` folder, link the corresponding machine file to `current.nix`.
4. `cd ~/.config/nixpkgs && ln -s ../../dotfiles/home/default.nix home.nix`
5. `home-manager switch`

This setup also sets up some symlinks "manually": wallpapers, Doom Emacs config and misc shell scripts.
Make sure that `~/wallpapers`, `~/bin` and `~/.doom.d` don't exist before applying the config.

## Note regarding hacks

To make this work on non-NixOS systems, the `hax` module in `home/hax` does some magic, such as:

* Setting `targets.genericLinux.enable`;
* Letting home-manager manage `man`;
* Generating wrappers for graphical programs.

The wrappers run the program with the required environment variables to make OpenGL / Vulkan (courtesy of [NixGL](https://github.com/guibou/nixGL)) and fontconfig work correctly.

## Caveats

1. Firefox has shit font rendering if using it from Nix. Install it from your distro or using Flatpak.
