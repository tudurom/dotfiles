{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homeModules.desktop.common;
  inherit (config.homeModules.desktop.fonts) themeFont;
in
  with lib; {
    options = {
      homeModules.desktop.common = {
        enable = mkEnableOption "Enable common desktop settings";
        nixGLPackage = mkOption {
          type = types.nullOr types.package;
          default = null;
          description = ''
            Start the Wayland compositor with a nixGL variant. Useful for Non-NixOS systems.
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
      home.packages = with pkgs; [
        wl-clipboard
      ];

      systemd.user.targets.wl-session = {
        Unit = {
          Description = "wayland compositor session";
          BindsTo = ["graphical-session.target"];
          Wants = ["graphical-session-pre.target" "xdg-desktop-autostart.target"];
          After = ["graphical-session-pre.target"];
          Before = ["xdg-desktop-autostart.target"];
        };
      };

      # notification daemon
      services.mako.enable = true;

      # clipboard manager. keeps the contents once the original program quits.
      services.copyq = {
        enable = true;
        systemdTarget = "wl-session.target";
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

      systemd.user.services.swayidle = {
        Service = {
          # hack to make calling swaylock with /usr/bin/env work
          # for both NixOS and non-NixOS
          # See: https://github.com/nix-community/home-manager/blob/05649393ac1f34980a5cf6a6e89de77626c9182b/modules/services/swayidle.nix#L124-L125
          Environment = mkForce [
            "PATH=${makeBinPath [pkgs.bash]}:/usr/bin"
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

      services.swayidle = let
        swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
        niri = "${config.programs.niri.package}/bin/niri";
        # if running nixos: make sure swaylock is enabled system-wide in the system config!
        # if not: make sure you either have swaylock installed via the system package manager,
        # or you have a valid PAM config for it.
        # otherwise, it will not be able to unlock the screen!
        swaylock = "/usr/bin/env swaylock";
        swaylockCmd = "${swaylock} -c 000000 -fF";
      in {
        enable = true;
        systemdTarget = "wl-session.target";
        events = [
          # make sure the screen is locked before going to sleep
          {
            event = "before-sleep";
            command = swaylockCmd;
          }
          {
            event = "lock";
            command = swaylockCmd;
          }
          # stop the screen locker if loginctl says it's time to unlock
          # (you can test by running loginctl unlock-session).
          # regarding the sigusr1 thing, see swaylock(1).
          {
            event = "unlock";
            command = "pkill -USR1 swaylock";
          }
        ];
        timeouts = [
          {
            timeout = 600;
            command = "${swaymsg} \"output * power off\" || ${niri} msg action power-off-monitors";
            resumeCommand = "${swaymsg} \"output * power on\" || true";
          }
        ];
      };
    };
  }
