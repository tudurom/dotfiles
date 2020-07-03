# Tudor's dotfiles

My dotfiles are managed using [home-manager](https://github.com/rycee/home-manager) and [Nix](https://nixos.org/).
My OS is NOT NixOS. As such, my configs have some slight hacks to allow them to work on every Linux system (graphical apps too).

## Installation

For non-NixOS:

1. Install Nix
2. Install home-manager
3. Clone this repo somewhere (let's say `~/dotfiles`)
4. In the `machines` folder, link the corresponding machine file to `current.nix`.
4. `cd ~/.config/nixpkgs && ln -s ../../dotfiles/home.nix home.nix`
5. `home-manager switch`

This setup also sets up some symlinks "manually": wallpapers, Doom Emacs config and misc shell scripts.
Make sure that `~/wallpapers`, `~/bin` and `~/.doom.d` don't exist before applying the config.

## Caveats

1. Firefox has shit font rendering if using it from Nix. Install it from your distro or using Flatpak.
