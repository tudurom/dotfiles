{ config, pkgs, sources, ... }: {
  imports = [ ./aspell.nix ./git.nix ./neovim.nix ./emacs.nix ./nix.nix ./gpg.nix ];
}
