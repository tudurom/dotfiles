{ config, pkgs, sources, ... }: {
  imports = [
    ./aspell.nix
    ./git.nix
    ./neovim.nix
    ./emacs.nix
    ./nix.nix
    ./gpg.nix
    ./podman.nix
  ];

  tudor.home.home.packages = with pkgs; [
    sqlite-interactive
  ];
}
