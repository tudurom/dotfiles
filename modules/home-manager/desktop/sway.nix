{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.desktop.sway;
in
with lib; {
  options = {
    homeModules.desktop.sway = {
      enable = mkEnableOption "Enable sway";
      nixGLSupport = mkEnableOption "Use NixGL when starting sway";
      wallpaperPath = mkOption {
        description = "Path to wallpaper to apply";
        type = types.str;
        default = "/usr/share/backgrounds/f38/default/f38-01-day.png";
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

    # Remove once next NixOS / home-manager is released
    # https://github.com/nix-community/home-manager/blob/6bba64781e4b7c1f91a733583defbd3e46b49408/modules/services/window-managers/i3-sway/sway.nix#L480-L491
    systemd.user.targets.sway-session = {
      Unit = {
        Wants = ["xdg-desktop-autostart.target"];
        Before = "xdg-desktop-autostart.target";
      };
    };

    wayland.windowManager.sway = let
      fonts = {
        names = [ "Berkeley Mono" ];
        style = "Regular";
        size = 12.0;
      };
    in {
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
        fonts = fonts;
        keybindings = let
          mod = config.wayland.windowManager.sway.config.modifier;

          wofi = lib.getExe pkgs.wofi;
          playerctl = lib.getExe pkgs.playerctl;
          pamixer = lib.getExe pkgs.pamixer;
          brightnessctl = lib.getExe pkgs.brightnessctl;
          grimblast = lib.getExe pkgs.grimblast;

          volStep = toString 5;
          brightStep = toString 5;
        in lib.mkOptionDefault {
          "${mod}+d" = "exec ${wofi} --show drun -i";

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
        window.titlebar = true;
      };
    };
  };
}
