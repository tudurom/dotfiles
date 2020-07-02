{ config, pkgs, options, ... }: {
  imports = [ ./wrappers.nix ];
  targets.genericLinux.enable = true;
  programs.man.enable = true;
}
