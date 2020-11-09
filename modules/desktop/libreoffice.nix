{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.desktop.libreoffice;
in
with lib; {
  options = {
    tudor.desktop.libreoffice = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home = {
      home.packages = with pkgs; [
        libreoffice-fresh
      ];
    };
  };
}
