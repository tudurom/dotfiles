{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.desktop.sway;

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
    programs.sway.enable = true;

    tudor.home = {
      wayland.windowManager.sway = let
        modifier = "Mod4";
        terminal = "alacritty";
        menu = "rofi -show drun";

        workspaces = [ 1 2 3 4 5 6 7 8 9 ];
        wallpaper = "~/wallpapers/street.png";
        lockWallpaper = wallpaper;

        locker = ''swaylock -f --clock -i "${lockWallpaper}" \
                    --effect-blur 5x5 --timestr "%I:%M"'';

        systemMode = "system: (l) lock (s) suspend (r) reboot (p) poweroff";
        launchMode = "launch: (f) firefox (e) emacs (n) nautilus";

        # gruvbox light
        colors = {
          bg = "#3c3836"; # fg 15 (it is named bg because it's used as a bg color for the different elements here)
          bgd = "#282828"; # fg0
          fg = "#fbf1c7"; # bg 0
          hl = "#689d6a"; # aqua 6
          urg = "#9d0006"; # red 9
        };
      in {
        enable = true;
        wrapperFeatures.gtk = true;

        config = {
          startup = [
            { command = "mako"; }
            { command = "xfce4-volumed-pulse"; }
            { command = "dex -a -e NOTHING"; }
            { command = ''
              swayidle -w \
                timeout 300 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                timeout 600 '${locker}' \
                before-sleep '${locker}'
            ''; }
            { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
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

          modifier = modifier;
          terminal = terminal;
          menu = menu;

          keybindings = let
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
            "${modifier}+Return" = "exec ${terminal}";
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
            "${modifier}+semicolon" = ''mode "${launchMode}"'';
            "${modifier}+Shift+semicolon" = ''mode "${systemMode}"'';

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

            "${launchMode}" = {
              "f" = ''exec firefox'';
              "e" = ''exec emacs'';
              "n" = ''exec nautilus'';

              "Return" = ''mode "default"'';
              "Escape" = ''mode "default"'';
            };

            "${systemMode}" = {
              "l" = ''exec ${locker}; mode "default";'';
              "s" = "exec systemctl suspend";
              "r" = "exec systemctl reboot";
              "p" = "exec systemctl poweroff";

              "Return" = ''mode "default"'';
              "Escape" = ''mode "default"'';
            };
          };

          bars = [{
            position = "top";
            statusCommand = "while date +'%Y-%m-%d %l:%M:%S %p'; do sleep 1; done";
            fonts = [ "JetBrains Mono 14" ];

            colors = rec {
              separator = colors.fg;
              statusline = colors.fg;
              background = colors.bgd;
              focusedWorkspace = {
                background = colors.hl;
                text = colors.fg;
                border = colors.hl;
              };

              activeWorkspace = {
                background = colors.bg;
                text = colors.fg;
                border = colors.bg;
              };
              inactiveWorkspace = activeWorkspace;
              bindingMode = {
                background = colors.bgd;
                text = colors.fg;
                border = colors.bgd;
              };
              urgentWorkspace = {
                background = colors.urg;
                text = colors.fg;
                border = colors.urg;
              };
            };
          }];

          colors = rec {
            focusedInactive = {
              background = colors.bg;
              text = colors.fg;
              indicator = colors.bg;
              border = colors.bg;
              childBorder = colors.bg;
            };
            focused = {
              background = colors.hl;
              text = colors.fg;
              indicator = colors.hl;
              border = colors.hl;
              childBorder = colors.hl;
            };
            unfocused = focusedInactive;
            urgent = {
              background = colors.urg;
              text = colors.bgd;
              indicator = colors.urg;
              border = colors.urg;
              childBorder = colors.urg;
            };
            background = colors.hl;
          };
        };
      };

      home.packages = with pkgs; [
        unstable.swaylock-effects
        swayidle
        xwayland

        dex
        mako
        pamixer
        playerctl
        rofi
        xfce.xfce4-volumed-pulse
      ];

      systemd.user.sessionVariables = {
        "_JAVA_AWT_WM_NONREPARENTING" = 1;
        "AWT_TOOLKIT" = "MToolkit";

        "MOZ_ENABLE_WAYLAND" = 1;
        # https://mastransky.wordpress.com/2020/03/16/wayland-x11-how-to-run-firefox-in-mixed-environment/
        "MOZ_DBUS_REMOTE" = 1;

        "SAL_USE_VCLPLUGIN" = "gtk3";
        "QT_WAYLAND_FORCE_DPI" = "physical";
      };
    };
  };

}
