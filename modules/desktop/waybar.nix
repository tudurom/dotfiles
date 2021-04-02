{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.desktop.waybar;
in
with lib;
{
  options = {
    tudor.desktop.waybar.enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    tudor.home = {
      programs.waybar.enable = true;
      programs.waybar.settings = [{
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ ];
        modules-right = [ "tray" "clock" ];

        modules = {
          "tray" = {
            icon-size = 20;
            spacing = 10;
          };

          "clock" = {
            format = "{:%Y-%m-%d %T}";
            interval = 1;
          };
        };
      }];
      programs.waybar.style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: 'JetBrains Mono';
          font-size: 14pt;
          min-height: 0;
        }

        window#waybar {
          background-color: #282828;
          color: #fbf1c7;
        }

        #workspaces button {
          padding: 0 4px;
          background-color: #3c3836;
        }

        #workspaces button:hover {
          background-color: #3c3836;
        }

        #workspaces button.focused {
          background-color: #689d6a;
        }

        #workspaces button:hover.focused {
          background-color: #689d6a;
        }

        #tray {
          padding: 0 10px;
        }

        #clock {
          padding: 0 10px;
        }
      '';
    };
  };
}
