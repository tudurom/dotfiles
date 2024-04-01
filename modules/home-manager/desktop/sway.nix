{
  config,
  flake,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeModules.desktop.sway;
  cfgCommon = config.homeModules.desktop.common;
  inherit (config.homeModules.desktop.fonts) themeFont;
in
  with lib; {
    options = {
      homeModules.desktop.sway = {
        enable = mkEnableOption "Enable sway";
      };
    };

    config = mkIf cfg.enable {
      nixpkgs.overlays = [
        flake.inputs.hypr-contrib.overlays.default
      ];

      homeModules.desktop = {
        common.enable = true;
        # terminal emulator
        wezterm.enable = cfgCommon.terminal == "wezterm";
        # status bar
        waybar = {
          enable = true;
          # systemdTarget = "sway-session.target";
        };
      };

      # dynamic display configuration.
      # to be enabled by each config inidividually,
      # this key is set here only to make it start when sway starts.
      services.kanshi.systemdTarget = "sway-session.target";

      # the belly of the beast
      wayland.windowManager.sway = {
        enable = true;
        package = let
          origPkg = pkgs.sway.override {
            extraSessionCommands = "";
            extraOptions = [];
            withBaseWrapper = true;
            withGtkWrapper = false;
          };
          nixGL = cfgCommon.nixGLPackage;
        in
          if nixGL != null
          then
            (pkgs.runCommand "sway-nixgl-wrapper" {} ''
              mkdir $out
              ln -s ${origPkg}/* $out
              rm $out/bin
              mkdir $out/bin
              ln -s ${origPkg}/bin/* $out/bin/
              rm $out/bin/sway
              cat > $out/bin/sway <<EOF
                . "\$HOME/.profile"
                exec ${lib.getExe nixGL} ${origPkg}/bin/sway \$@
              EOF
              chmod +x $out/bin/sway
            '')
          else origPkg;
        systemd = {
          enable = true;
          xdgAutostart = true;
        };

        # starts a systemd-session.target systemd target in the config,
        # so we can easily make various other programs (see above) start
        # when sway starts
        wrapperFeatures.gtk = true;
        config = {
          # the super key
          modifier = "Mod4";
          input."*" = {
            # also called "Romanian (Programmers)" on Windows.
            # it's the us keyboard + various stuff accessible with AltGr
            # https://learn.microsoft.com/en-us/globalization/keyboards/kbdropr
            xkb_layout = "ro";
            xkb_options = "compose:rctrl";
          };
          input."type:touchpad" = {
            tap = "enabled";
            tap_button_map = "lrm";
            natural_scroll = "enabled";
            drag = "enabled";
            drag_lock = "enabled";
          };
          output = {
            "*" = {
              bg = "${cfgCommon.wallpaperPath} fill";
              adaptive_sync = "on";
            };
          };
          workspaceAutoBackAndForth = true;
          startup = [
            {command = "/usr/libexec/polkit-gnome-authentication-agent-1";}
            {command = lib.getExe' config.services.mako.package "mako";}
            {command = "1password --silent";}
            {command = lib.getExe' pkgs.emote "emote";}
            {
              command = "systemctl --user restart waybar.service kanshi.service";
              always = true;
            }
          ];
          fonts = {
            inherit (themeFont) style size;
            names = [themeFont.family];
          };
          keybindings = let
            mod = config.wayland.windowManager.sway.config.modifier;

            # application menu
            fuzzel = lib.getExe config.programs.fuzzel.package;

            # control the currently playing media player
            playerctl = lib.getExe pkgs.playerctl;
            # control the volume
            pamixer = lib.getExe pkgs.pamixer;
            # control the brightness of the laptop's screen
            brightnessctl = lib.getExe pkgs.brightnessctl;
            # take screenshots and show notifications when they're taken
            grimblast = lib.getExe pkgs.grimblast;
            # emoji picker
            emote = lib.getExe' pkgs.emote "emote";

            foot = lib.getExe config.programs.foot.package;
            wezterm = lib.getExe config.programs.wezterm.package;

            volStep = toString 5;
            brightStep = toString 5;
          in
            lib.mkOptionDefault {
              "${mod}+Return" =
                if cfgCommon.terminal == "wezterm"
                then "exec ${wezterm}"
                else "exec ${foot}";

              # fuzzel is enabled above, should be in path
              "${mod}+d" = "exec ${fuzzel}";

              "${mod}+ctrl+l" = "exec loginctl lock-session";

              "XF86AudioPlay" = "exec ${playerctl} play-pause";
              "XF86AudioPrev" = "exec ${playerctl} previous";
              "XF86AudioNext" = "exec ${playerctl} next";
              "XF86AudioStop" = "exec ${playerctl} stop";

              "XF86AudioRaiseVolume" = "exec ${pamixer} --increase ${volStep}";
              "XF86AudioLowerVolume" = "exec ${pamixer} --decrease ${volStep}";
              "XF86AudioMute" = "exec ${pamixer} --toggle-mute";
              "XF86AudioMicMute" = "exec ${pamixer} --default-source --toggle-mute";

              "XF86MonBrightnessUp" = "exec ${brightnessctl} set ${brightStep}%+";
              "XF86MonBrightnessDown" = "exec ${brightnessctl} set ${brightStep}%-";

              "Print" = "exec ${grimblast} --notify copy screen";
              "shift+Print" = "exec ${grimblast} --notify copy area";
              "alt+Print" = "exec ${grimblast} --notify copy active";

              "${mod}+comma" = "exec ${emote}";

              "${mod}+ctrl+shift+l" = "move workspace to output right";
              "${mod}+ctrl+shift+h" = "move workspace to output left";
              "${mod}+ctrl+shift+j" = "move workspace to output down";
              "${mod}+ctrl+shift+k" = "move workspace to output up";
            };
          bars = [];
          window = {
            titlebar = true;
            border = 2;
          };
          colors = let
            main = "#000000";
            mainBorder = "#404040";
            primary = "#ffffff";
            primaryBorder = "#bababa";
            secondary = "#00ff00";
          in {
            focused = {
              background = primary;
              border = primaryBorder;
              childBorder = primaryBorder;
              text = main;
              indicator = primary;
            };
            unfocused = {
              background = main;
              border = mainBorder;
              childBorder = mainBorder;
              text = primary;
              indicator = primary;
            };
            focusedInactive = {
              background = main;
              border = mainBorder;
              childBorder = mainBorder;
              text = secondary;
              indicator = primary;
            };
          };
        };
        extraConfigEarly = ''
          exec "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd XDG_DATA_DIRS"
          exec systemctl --user start wl-session.target
        '';
        extraConfig = ''
          title_align center
        '';
      };
    };
  }
