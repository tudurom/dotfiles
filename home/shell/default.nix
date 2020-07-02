{ config, pkgs, ... }: {
  imports = [ ./bash.nix ./git.nix ./fish.nix ./vars.nix ];
}
