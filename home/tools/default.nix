{ config, pkgs, sources, ... }: {
  imports = [ ./neovim.nix ./emacs.nix ./nix.nix ./gpg.nix ];
}
