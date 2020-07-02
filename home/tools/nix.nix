{ config, pkgs, ... }:
{
  home.packages = with pkgs; [ niv ];
  programs.direnv.enable = true;
  services.lorri.enable = true;
}
