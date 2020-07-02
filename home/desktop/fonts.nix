{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    corefonts
    dejavu_fonts
    noto-fonts
    roboto
    roboto-slab
    liberation_ttf_v2
    jetbrains-mono

    fontconfig.out
  ];
  fonts.fontconfig.enable = true;
}
