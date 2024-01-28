{ config, flake, lib, pkgs, ... }:
let
  cfg = config.homeModules.desktop.sway;
  inherit (config.homeModules.desktop.fonts) themeFont;
in
with lib; {
  options = {
    homeModules.desktop.sway = {
      enable = mkEnableOption "Enable sway";
      nixGLPackage = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = ''
          Start sway with a nixGL variant. Useful for Non-NixOS systems.
          If null (default), sway will be started normally.
        '';
      };

      wallpaperPath = mkOption {
        description = "Path to wallpaper to apply";
        type = types.path;
        # https://unsplash.com/photos/ZlzWbHC86B8
        default = ./wallpaper.jpg;
      };

      terminal = mkOption {
        description = "Terminal emulator to use: foot or wezterm";
        type = types.str;
        default = "wezterm";
      };
    };
  };

  config = mkIf cfg.enable {    
    nixpkgs.overlays = [
      flake.inputs.hypr-contrib.overlays.default
    ];

    homeModules.desktop = {
      # terminal emulator
      wezterm.enable = cfg.terminal == "wezterm";
      fonts.enable = cfg.terminal == "foot";
      # status bar
      waybar = {
        enable = true;
        systemdTarget = "sway-session.target";
      };
    };

    home.packages = with pkgs; [
      wl-clipboard
    ];

    # notification daemon
    services.mako.enable = true;
    # dynamic display configuration.
    # to be enabled by each config inidividually,
    # this key is set here only to make it start when sway starts.
    services.kanshi.systemdTarget = "sway-session.target";

    # clipboard manager. keeps the contents once the original program quits.
    services.copyq = {
      enable = true;
      systemdTarget = "sway-session.target";
    };

    # blue light remover. adjusts the red tint based on the time of day.
    services.gammastep = {
      enable = true;
      provider = "manual";
      # https://maps.app.goo.gl/wrftdjP96bKDu5FW7
      latitude = "52.36308";
      longitude = "4.88372";
      tray = true;
    };

    # does things if the computer is left untouched for a while
    services.swayidle = let
      swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
      # if running nixos: make sure swaylock is enabled system-wide in the system config!
      # if not: make sure you either have swaylock installed via the system package manager,
      # or you have a valid PAM config for it.
      # otherwise, it will not be able to unlock the screen!
      swaylock = "/usr/bin/env swaylock";
      swaylockCmd = "${swaylock} -c 000000 -fF";
    in {
      enable = true;
      systemdTarget = "sway-session.target";
      events = [
        # make sure the screen is locked before going to sleep
        { event = "before-sleep"; command = swaylockCmd; }
        { event = "lock"; command = swaylockCmd; }
        # stop the screen locker if loginctl says it's time to unlock
        # (you can test by running loginctl unlock-session).
        # regarding the sigusr1 thing, see swaylock(1).
        { event = "unlock"; command = "pkill -USR1 swaylock"; }
      ];
      timeouts = [
        {
          timeout = 600;
          command = "${swaymsg} \"output * power off\"";
          resumeCommand = "${swaymsg} \"output * power on\"";
        }
        # TODO: suspend after a longer while
      ];
    };

    systemd.user.services.swayidle = {
      Service = {
        # hack to make calling swaylock with /usr/bin/env work
        # for both NixOS and non-NixOS
        # See: https://github.com/nix-community/home-manager/blob/05649393ac1f34980a5cf6a6e89de77626c9182b/modules/services/swayidle.nix#L124-L125
        Environment = mkForce [
          "PATH=${makeBinPath [ pkgs.bash ]}:/usr/bin"
        ];
      };
    };

    # fuzzy-finding application launcher
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          # in case you don't see it: that's the eyes emoji,
          # followed by the U+FE0F "Variation selector-6" character.
          # That magic character tells the text rendering system to use
          # the colour version of the emoji, instead of the outline version.
          # You can also force the outline version with U+FE0E "Variation selector-5".
          prompt = "\"👀️ \"";
          font = "${themeFont.family}:size=${builtins.toString (builtins.floor themeFont.size)},Noto Color Emoji,Noto Emoji";
        };
      };
    };

    # the belly of the beast
    wayland.windowManager.sway = {
      enable = true;
      package = let
        origPkg = pkgs.sway;
        nixGL = cfg.nixGLPackage;
      in if nixGL != null then (pkgs.runCommand "sway-nixgl-wrapper" {} ''
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
      '') else origPkg;
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
        };
        input."type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        output = {
          "*" = {
            bg = "${cfg.wallpaperPath} fill";
            adaptive_sync = "on";
          };
        };
        workspaceAutoBackAndForth = true;
        startup = [
          { command = "/usr/libexec/polkit-gnome-authentication-agent-1"; }
          { command = lib.getExe' config.services.mako.package "mako"; }
          { command = "1password --silent"; }
          { command = lib.getExe' pkgs.emote "emote"; }
          { command = "systemctl --user restart waybar.service kanshi.service"; always = true; }
        ];
        fonts = {
          inherit (themeFont) style size;
          names = [ themeFont.family ];
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
        in lib.mkOptionDefault {
          "${mod}+Return" = if cfg.terminal == "wezterm"
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
      extraConfig = ''
        title_align center
      '';
    };
  };
}
