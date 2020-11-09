{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.desktop.extraApps;
in
with lib; {
  options = {
    tudor.desktop.extraApps = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home.home.packages = with pkgs; [
      anki
      gimp
      pavucontrol
      spotify
      tdesktop
      teams
      thunderbird-bin
      treesheets
    ];
  };
}
