{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.desktop.fonts;
in
with lib; {
  options = {
    tudor.desktop.fonts = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      corefonts
      dejavu_fonts
      go-font
      jetbrains-mono
      liberation_ttf_v2
      noto-fonts
      roboto
      roboto-slab

      fontconfig.out
    ];
    fonts.fontconfig.enable = true;
  };
}
