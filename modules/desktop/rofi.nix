{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.desktop.rofi;
in
with lib; {
  options = {
    tudor.desktop.rofi = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home.programs.rofi = {
      enable = true;

      terminal = "${pkgs.alacritty}/bin/alacritty";
      theme = "gruvbox-light-hard";
    };
  };
}
