{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.homeModules.desktop.waybar;
  inherit (config.homeModules.desktop.fonts) themeFont;
in
  with lib; {
    options = {
      homeModules.desktop.waybar = {
        enable = mkEnableOption "Enable Waybar";
        systemdTarget = mkOption {
          type = types.str;
          description = "Enable Waybar as part of a systemd target";
          example = "sway-session.target";
          default = "";
        };
      };
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        font-awesome_6
      ];

      programs.waybar = {
        enable = true;
        package = pkgs.waybar;

        systemd.enable = cfg.systemdTarget != "";
        systemd.target = cfg.systemdTarget;

        style = pkgs.substituteAll {
          name = "style.css";
          src = ./style.css;
          fontFamily = themeFont.family;
          fontSize = builtins.toString (builtins.floor (themeFont.size + 1.0));
        };

        settings.mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = ["sway/workspaces" "sway/mode"];
          modules-center = ["clock"];
          modules-right = ["tray" "battery" "pulseaudio"];

          battery = {
            format-charging = " {capacity}%";
            format = "{icon}  {capacity}%";
            format-icons = ["" "" "" "" ""];
          };

          pulseaudio = {
            format = "{icon} {volume}%";
            format-icons = ["" "" ""];
            format-muted = " {volume}% (Muted)";
            on-click = "pactl set-sink-mute 0 toggle";
          };

          tray.show-passive-items = true;
        };
      };
    };
  }
