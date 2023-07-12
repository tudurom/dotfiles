{ config, pkgs, lib, options, inputs, ... }:
let
  cfg = config.homeModules.desktop.waybar;
in
with lib; {
  options = {
    homeModules.desktop.waybar = {
      enable = mkEnableOption "Enable Waybar";
      hyprland = mkEnableOption "Auto-start with hyprland systemd session";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      font-awesome_6
      inter
    ];

    programs.waybar = let
      enableSystemd = cfg.hyprland == true;
      systemdTarget = if cfg.hyprland then "hyprland-session.target" else "";
    in {
      enable = true;
      package = pkgs.waybar-hyprland;
      systemd.enable = enableSystemd;
      systemd.target = systemdTarget;

      style = builtins.readFile ./style.css;

      settings.mainBar = {
        layer = "top";
        position = "top";
        height = 45;
        modules-left = [ "wlr/workspaces" ];
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

        "wlr/workspaces" = {
          on-click = "activate";
          all-outputs = true;
        };

        tray.show-passive-items = true;
      };
    };
  };
}
