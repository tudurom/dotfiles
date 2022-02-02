{ config, pkgs, ... }:
{
  tudor.home = {
    home.packages = with pkgs; [ niv ];
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      nix-direnv.enableFlakes = true;
    };
  };
}
