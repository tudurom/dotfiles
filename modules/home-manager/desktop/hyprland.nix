{ config, pkgs, lib, options, inputs, ... }:
let
  cfg = config.homeModules.desktop.hyprland;
in
with lib; {
  options = {
    homeModules.desktop.hyprland = {
      enable = mkEnableOption "Enable Hyprland";
      nixGLSupport = mkEnableOption "Use NixGL when starting Hyprland";
      wallpaperPath = mkOption {
        description = "Path to wallpaper to apply";
        type = types.str;
        default = "/usr/share/backgrounds/f38/default/f38-01-day.png";
      };
    };
  };

  config = mkIf cfg.enable {
    services.mako.enable = true;

    home.packages = [
      pkgs.xdg-desktop-portal-hyprland
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      xwayland.enable = true;

      package = let
        system = pkgs.stdenv.hostPlatform.system;

        # make sure Hyprland uses the same mesa as NixGL,
        # which is the stable nixpkgs mesa.
        mesa = pkgs.mesa;
        origPkg = inputs.hyprland.packages.${system}.default.override {
          enableXWayland = config.wayland.windowManager.hyprland.xwayland.enable;
          mesa = mesa;
          wlroots = inputs.hyprland.packages.${system}.wlroots-hyprland.override {
            wlroots = pkgs.unstable.wlroots.override {
              mesa = mesa;
            };
          };
        };
        nixGL = pkgs.nixgl.nixGLIntel;
      in if cfg.nixGLSupport then (pkgs.runCommand "hyprland-nixgl-wrapper" {} ''
        mkdir $out
        ln -s ${origPkg}/* $out
        rm $out/bin
        mkdir $out/bin
        ln -s ${origPkg}/bin/* $out/bin/
        rm $out/bin/Hyprland
        cat > $out/bin/Hyprland <<EOF
          . "\$HOME/.profile"
          exec ${lib.getExe nixGL} ${origPkg}/bin/Hyprland \$@
        EOF
        chmod +x $out/bin/Hyprland
      '') else origPkg;
      extraConfig = let
        playerctl = lib.getExe pkgs.playerctl;
        brightnessctl = lib.getExe pkgs.brightnessctl;
        grimblast = lib.getExe pkgs.grimblast;
        pamixer = lib.getExe pkgs.pamixer;
        ksshaskpass = lib.getExe pkgs.ksshaskpass.out;
        mako = lib.getExe config.services.mako.package;
        swaybg = lib.getExe pkgs.swaybg;
        wofi = lib.getExe pkgs.wofi;
        foot = lib.getExe config.programs.foot.package;
        dex = lib.getExe pkgs.dex;
        volStep = toString 5;
        brightStep = toString 5;
      in ''
      env = SSH_ASKPASS,${ksshaskpass}
      exec-once = ${pkgs.swaybg}/bin/swaybg -i ${cfg.wallpaperPath}
      exec-once = /usr/libexec/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh
      exec-once = ${mako}
      exec-once = /usr/libexec/kf5/polkit-kde-authentication-agent-1
      exec-once = ${dex} -a -e Hyprland

      general {
        gaps_in = 2
        gaps_out = 4
      }

      input {
        kb_layout = ro

        touchpad {
          # having this not the default is absolutely evil
          natural_scroll = true
        }
      }

      decoration {
        blur {
          enabled = false
        }
        drop_shadow = false
      }

      misc {
        vfr = true
        disable_hyprland_logo = true
        disable_splash_rendering = true
      }

      animations {
        # why don't I use sway at this point
        enabled = false
      }

      xwayland {
        force_zero_scaling = true
      }

      monitor = desc:LG Electronics LG HDR 4K 0x0008D101,preferred,0x0,2
      # main monitor is 4k, but because it has 2x scaling, it takes 1920 logical pixels
      monitor = eDP-1,preferred,1920x0,1
      monitor = ,preferred,auto,1

      $mainMod = SUPER
      bind = $mainMod, Return, exec, ${foot}
      bind = $mainMod, M, exit,
      bind = $mainMod, space, exec, ${wofi} --show drun -i
      bind = $mainMod, Q, killactive,
      bind = $mainMod SHIFT, F, togglefloating,
      # requires swaylock being installed.
      # on non nixos setups, it must be installed by the system package manager
      bind = $mainMod, L, exec, swaylock

      bind=,XF86AudioPlay,exec,${playerctl} play
      bind=,XF86AudioPause,exec,${playerctl} pause
      bind=,XF86AudioPrev,exec,${playerctl} previous
      bind=,XF86AudioNext,exec,${playerctl} next
      bind=,XF86AudioStop,exec,${playerctl} stop

      bind=,XF86AudioRaiseVolume,exec,${pamixer} --increase ${volStep}
      bind=,XF86AudioLowerVolume,exec,${pamixer} --decrease ${volStep}
      bind=,XF86AudioMute,exec,${pamixer} --toggle-mute
      bind=,XF86AudioMicMute,exec,${pamixer} --default-source --toggle-mute

      bind=,XF86MonBrightnessUp,exec,${brightnessctl} set +${brightStep}%
      bind=,XF86MonBrightnessDown,exec,${brightnessctl} set ${brightStep}%-

      bind=,Print,exec,${grimblast} --notify copy screen
      bind = SHIFT,Print,exec,${grimblast} --notify copy area
      bind = ALT,Print,exec,${grimblast} --notify copy active

      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10
      '';
    };
  };
}
