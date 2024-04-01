{
  config,
  flake,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeModules.desktop.niri;
  cfgCommon = config.homeModules.desktop.common;
in
  with lib; {
    options = {
      homeModules.desktop.niri = {
        enable = mkEnableOption "Enable niri";
      };
    };

    config = let
      origPkg = config.programs.niri.package;
      nixGL = cfgCommon.nixGLPackage;
      patchedNiri =
        if nixGL != null
        then
          (pkgs.runCommand "niri-nixgl-wrapper" {} ''
            mkdir $out
            ln -s ${origPkg}/* $out
            rm $out/bin
            mkdir $out/bin
            ln -s ${origPkg}/bin/* $out/bin/
            rm $out/bin/niri
            cat > $out/bin/niri <<EOF
              . "\$HOME/.profile"
              exec ${lib.getExe nixGL} ${origPkg}/bin/niri \$@
            EOF
            chmod +x $out/bin/niri
          '')
        else origPkg;
      prefNiri = patchedNiri;
    in
      mkIf cfg.enable {
        nixpkgs.overlays = [
          flake.inputs.niri.overlays.niri
        ];

        homeModules.desktop = {
          common.enable = true;
          waybar = {
            enable = true;
          };
        };

        home.packages = [prefNiri pkgs.cage];

        # niri doesn't support xwayland
        systemd.user.services.copyq.Service.Environment = lib.mkAfter ["QT_QPA_PLATFORM=wayland"];

        programs.niri.settings = {
          # please no
          animations.window-open = null;

          input = {
            keyboard.xkb.layout = "ro";
            touchpad = {
              tap = true;
              tap-button-map = "left-right-middle";
              natural-scroll = true;
              dwt = true;
              dwtp = true;
            };
            focus-follows-mouse = true;
            warp-mouse-to-focus = true;
            workspace-auto-back-and-forth = true;
          };

          spawn-at-startup = [
            {
              command = [
                "${pkgs.dbus}/bin/dbus-update-activation-environment"
                "--systemd"
                "DISPLAY"
                "WAYLAND_DISPLAY"
                "SWAYSOCK"
                "XDG_CURRENT_DESKTOP"
                "XDG_SESSION_TYPE"
                "NIXOS_OZONE_WL"
                "XCURSOR_THEME"
                "XCURSOR_SIZE"
                "XDG_DATA_DIRS"
              ];
            }
            {
              command = [
                "/usr/libexec/polkit-gnome-authentication-agent-1"
              ];
            }
            {
              command = [
                (lib.getExe' config.services.mako.package "mako")
              ];
            }
            {
              command = [
                "systemctl"
                "--user"
                "start"
                "wl-session.target"
              ];
            }
            {
              command = [
                (lib.getExe pkgs.swaybg)
                "-i"
                "${cfgCommon.wallpaperPath}"
                "-m"
                "fill"
              ];
            }
            {
              command = [
                "1password"
                "--enable-features=UseOzonePlatform"
                "--ozone-platform=wayland"
                "--silent"
              ];
            }
          ];

          binds = with config.lib.niri.actions; let
            exe = lib.getExe;
            exe' = lib.getExe';

            wpctl = "${pkgs.wireplumber}/bin/wpctl";
          in
            lib.mkOptionDefault ({
                "Mod+Shift+E".action = quit;
                "Mod+Shift+Slash".action = show-hotkey-overlay;

                "Mod+Shift+Q".action = close-window;

                "Mod+H".action = focus-column-left;
                "Mod+J".action = focus-window-down;
                "Mod+K".action = focus-window-up;
                "Mod+L".action = focus-column-right;

                "Mod+Shift+H".action = move-column-left;
                "Mod+Shift+J".action = move-window-down;
                "Mod+Shift+K".action = move-window-up;
                "Mod+Shift+L".action = move-column-right;

                "Mod+Ctrl+H".action = focus-monitor-left;
                "Mod+Ctrl+J".action = focus-monitor-down;
                "Mod+Ctrl+K".action = focus-monitor-up;
                "Mod+Ctrl+L".action = focus-monitor-right;

                "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
                "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
                "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
                "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

                "Mod+Comma".action = consume-window-into-column;
                "Mod+Period".action = expel-window-from-column;

                "Mod+R".action = switch-preset-column-width;
                "Mod+F".action = maximize-column;
                "Mod+Shift+F".action = fullscreen-window;
                "Mod+C".action = center-column;

                "Print".action = screenshot-screen;
                "Shift+Print".action = screenshot;
                "Alt+Print".action = screenshot-window;

                "Mod+Return".action = spawn (exe config.programs.foot.package);
                "Mod+D".action = spawn (exe pkgs.fuzzel);
                "Mod+semicolon".action = spawn (exe' pkgs.emote "emote");

                "XF86AudioRaiseVolume".action = spawn wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+";
                "XF86AudioLowerVolume".action = spawn wpctl "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-";

                "XF86MonBrightnessUp".action = spawn (exe pkgs.brightnessctl) "set" "5%+";
                "XF86MonBrightnessDown".action = spawn (exe pkgs.brightnessctl) "set" "5%-";
              }
              // (lib.attrsets.mergeAttrsList (map (x: let
                xStr = builtins.toString x;
              in {
                "Mod+${xStr}".action = focus-workspace x;
                "Mod+Shift+${xStr}".action = move-column-to-workspace x;
              }) [1 2 3 4 5 6 7 8 9])));

          layout = {
            preset-column-widths = [
              {proportion = 1.0 / 3.0;}
              {proportion = 1.0 / 2.0;}
              {proportion = 2.0 / 3.0;}
            ];

            default-column-width = {proportion = 1.0 / 2.0;};
          };

          prefer-no-csd = true;

          outputs = {
            "eDP-1" = {
              # scale = 1.25;
              scale = 1.0;
              position = {
                x = 1080 + 1920;
                y = 0;
              };
            };

            "DP-6" = {
              scale = 2.0;
              position = {
                x = 0;
                y = 0;
              };
              transform.rotation = 90;
            };

            "DP-9" = {
              scale = 2.0;
              position = {
                x = 1080;
                y = 0;
              };
            };
          };
        };
      };
  }
