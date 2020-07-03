{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.desktop.sway;

  modifier = "Mod4";
  terminal = "alacritty";
  menu = "rofi -show drun";

  workspaces = [ 1 2 3 4 5 6 7 8 9 ];
  wallpaper = "~/wallpapers/street.png";
in
with lib; {
  options = {
    tudor.desktop.sway = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable Sway.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      config = {
        startup = [
          { command = "mako"; }
          { command = "xfce4-volumed-pulse"; }
          { command = "redshift"; }
          { command = "dex -a -e NOTHING"; }
          { command = "pulseeffects --gapplication-service"; }
        ];

        fonts = [ "JetBrains Mono 14" ];

        window = {
          border = 3;
          titlebar = true;
        };

        output = {
          "*" = {
            bg = "${wallpaper} fill";
          };
        };

        input = {
          "type:keyboard" = {
            xkb_layout = "ro";
            # the good one
            xkb_variant = "comma";
          };
        };

        modifier = "Mod4";
        terminal = "alacritty";
        menu = "rofi -show drun";

        keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
          term = config.wayland.windowManager.sway.config.terminal;
          menu = config.wayland.windowManager.sway.config.menu;

          genWSBind = (ws: let wsnum = (toString ws); in {
            "${modifier}+${wsnum}" = "workspace ${wsnum}";
            "${modifier}+Shift+${wsnum}" = "move container to workspace ${wsnum}";
          });
        in {
          # media keys
          "XF86AudioRaiseVolume" = "exec pamixer --increase 10";
          "XF86AudioLowerVolume" = "exec pamixer --decrease 10";
          "XF86AudioMute" = "exec pamixer --toggle-mute";
          "XF86AudioMicMute" = "exec pamixer --default-source --toggle-mute";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioPlay" = "exec playerctl play-pause";

          # screenshots
          "Print" = "exec $HOME/bin/grimshot save screen";
          "Shift+Print" = "exec $HOME/bin/grimshot save area";

          # launching programs
          "${modifier}+p" = "exec bwmenu";
          "${modifier}+Return" = "exec ${term}";
          "${modifier}+d" = "exec bash -l -c '${menu}'";

          # reload and exit
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Chiar vrei să ieși, rege?' -b 'Da vțm' 'swaymsg exit'";

          "${modifier}+w" = "kill";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+s" = "layout stacking";
          "${modifier}+t" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+f" = "fullscreen";
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+r" = ''mode "resize"'';
        } // (builtins.foldl' (x: y: x // y) {} (map genWSBind workspaces));

        modes = {
          "resize" = {
            "h" = "resize shrink width 20px";
            "j" = "resize grow height 20px";
            "k" = "resize shrink height 20px";
            "l" = "resize grow width 20px";

            "Left" = "resize shrink width 20px";
            "Down" = "resize grow height 20px";
            "Up" = "resize shrink height 20px";
            "Right" = "resize grow width 20px";

            "Return" = ''mode "default"'';
            "Escape" = ''mode "default"'';
          };
        };

        bars = [{
          position = "top";
          statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
          fonts = [ "JetBrains Mono 14" ];

          colors = {
            statusline = "#ebdbb2";
            background = "#282828";
            inactiveWorkspace = {
              background = "#32323200";
              border = "#32323200";
              text = "#ebdbb2";
            };
          };
        }];
      };
    };

    home.packages = with pkgs; [
      swaylock
      swayidle
      xwayland

      rofi
    ];

    systemd.user.sessionVariables = {
      "_JAVA_AWT_WM_NONREPARENTING" = 1;
      "AWT_TOOLKIT" = "MToolkit";

      "MOZ_ENABLE_WAYLAND" = 1;
      # https://mastransky.wordpress.com/2020/03/16/wayland-x11-how-to-run-firefox-in-mixed-environment/
      "MOZ_DBUS_REMOTE" = 1;

      "SAL_USE_VCLPLUGIN" = "gtk";
      "QT_WAYLAND_FORCE_DPI" = "physical";
    };
    my.hax.glWrappers = [ "${pkgs.sway}/bin/sway" ];
  };

}
