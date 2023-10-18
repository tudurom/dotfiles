{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.desktop.sway;
  themeFont = config.homeModules.desktop.fonts.themeFont;
in
with lib; {
  options = {
    homeModules.desktop.sway = {
      enable = mkEnableOption "Enable sway";
      nixGLSupport = mkEnableOption "Use NixGL when starting sway";
      wallpaperPath = mkOption {
        description = "Path to wallpaper to apply";
        type = types.path;
        # https://unsplash.com/photos/ZlzWbHC86B8
        default = ./wallpaper.jpg;
      };
      outputs = mkOption {
        type = types.attrsOf (types.attrsOf types.str);
        default = {};
        description = "See home-manager and sway-output";
      };
    };
  };

  config = mkIf cfg.enable {    
    services.mako.enable = true;
    services.kanshi.systemdTarget = "sway-session.target";

    homeModules.desktop.waybar = {
      enable = true;
      systemdTarget = "sway-session.target";
    };

    services.gammastep = {
      enable = true;
      provider = "manual";
      # https://maps.app.goo.gl/wrftdjP96bKDu5FW7
      latitude = "52.36308";
      longitude = "4.88372";
      tray = true;
    };

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
      extraArgs = ["-d"];
      events = [
        { event = "before-sleep"; command = swaylockCmd; }
        { event = "lock"; command = swaylockCmd; }
        { event = "unlock"; command = "pkill -USR1 swaylock"; }
      ];
      timeouts = [
        {
          timeout = 600;
          command = "${swaymsg} \"output * power off\"";
          resumeCommand = "${swaymsg} \"output * power on\"";
        }
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

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          prompt = "\"👀 \"";
          font = "${themeFont.family}:size=${builtins.toString (builtins.floor themeFont.size)}";
        };
      };
    };

    # Remove once next NixOS / home-manager is released
    # https://github.com/nix-community/home-manager/blob/6bba64781e4b7c1f91a733583defbd3e46b49408/modules/services/window-managers/i3-sway/sway.nix#L480-L491
    systemd.user.targets.sway-session = {
      Unit = {
        Wants = ["xdg-desktop-autostart.target"];
        Before = "xdg-desktop-autostart.target";
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      package = let
        origPkg = pkgs.sway;
        nixGL = pkgs.nixgl.nixGLIntel;
      in if cfg.nixGLSupport then (pkgs.runCommand "sway-nixgl-wrapper" {} ''
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
      # Uncomment when the next Nixpkgs / home-manager is released
      # systemd = {
      #   enable = true;
      #   xdgAutostart = true;
      # };
      systemdIntegration = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod4";
        input."*" = {
          xkb_layout = "ro";
        };
        input."type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        output = cfg.outputs // {
          "*" = {
            bg = "${cfg.wallpaperPath} fill";
          };
        };
        workspaceAutoBackAndForth = true;
        startup = [
          { command = "/usr/libexec/polkit-gnome-authentication-agent-1"; }
          { command = lib.getExe config.services.mako.package; }
          { command = "1password --silent"; }
        ];
        fonts = {
          names = [ themeFont.family ];
          style = themeFont.style;
          size = themeFont.size;
        };
        keybindings = let
          mod = config.wayland.windowManager.sway.config.modifier;

          playerctl = lib.getExe pkgs.playerctl;
          pamixer = lib.getExe pkgs.pamixer;
          brightnessctl = lib.getExe pkgs.brightnessctl;
          grimblast = lib.getExe pkgs.grimblast;

          volStep = toString 5;
          brightStep = toString 5;
        in lib.mkOptionDefault {
          # fuzzel is enabled above, should be in path
          "${mod}+d" = "exec fuzzel";

          "${mod}+ctrl+l" = "exec loginctl lock-session";

          "XF86AudioPlay" = "exec ${playerctl} play";
          "XF86AudioPause" = "exec ${playerctl} pause";
          "XF86AudioPrev" = "exec ${playerctl} previous";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioStop" = "exec ${playerctl} stop";

          "XF86AudioRaiseVolume" = "exec ${pamixer} --increase ${volStep}";
          "XF86AudioLowerVolume" = "exec ${pamixer} --decrease ${volStep}";
          "XF86AudioMute" = "exec ${pamixer} --toggle-mute";
          "XF86AudioMicMute" = "exec ${pamixer} --default-source --toggle-mute";

          "XF86MonBrightnessUp" = "exec ${brightnessctl} set +${brightStep}%";
          "XF86MonBrightnessDown" = "exec ${brightnessctl} set ${brightStep}%-";

          "Print" = "exec ${grimblast} --notify copy screen";
          "shift+Print" = "exec ${grimblast} --notify copy area";
          "alt+Print" = "exec ${grimblast} --notify copy active";
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
