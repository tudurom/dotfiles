{ config, pkgs, lib, options, inputs, ... }:
let
  cfg = config.homeModules.desktop.waybar;
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
      inter
    ];

    programs.waybar = {
      enable = true;
      package = pkgs.waybar;

      systemd.enable = cfg.systemdTarget != "";
      systemd.target = cfg.systemdTarget;

      style = builtins.readFile ./style.css;

      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "battery" "pulseaudio" ];

        battery = {
          format-charging = " {capacity}%";
          format = "{icon} {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = [ "" "" "" ];
          format-muted = " {volume}% (Muted)";
          on-click = "pactl set-sink-mute 0 toggle";
        };

        tray.show-passive-items = true;
      };
    };
  };
}
