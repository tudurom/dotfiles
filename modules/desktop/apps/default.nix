{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./extraapps.nix
    ./firefox.nix
    ./libreoffice.nix
    ./zathura.nix
  ];
}
