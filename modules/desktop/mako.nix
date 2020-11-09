{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.desktop.mako;
in
with lib; {
  options = {
    tudor.desktop.mako = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable the Mako notification daemon.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home = {
      home.packages = [ pkgs.mako pkgs.libnotify ];

      # The mako nix expression does not support selectors afaik
      xdg.configFile."mako/config".text = ''
      markup=1
      default-timeout=5000
      format=<b>%a\n%s</b>\n%b
      group-by=app-name,summary
      icon-path=/usr/share/icons/Adwaita

      [grouped=true]
      format=(%g) <b>%a\n%s</b>\n%b
      '';
    };
  };
}
