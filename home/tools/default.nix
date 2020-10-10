{ config, pkgs, sources, ... }: {
  imports = [ ./aspell.nix ./git.nix ./neovim.nix ./neuron.nix ./emacs.nix ./nix.nix ./gpg.nix ];
}
