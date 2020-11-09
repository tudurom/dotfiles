{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.graphicalSession;
in
with lib; {
  imports = [
    ./alacritty.nix
    ./dirs.nix
    ./extraapps.nix
    ./firefox.nix
    ./fonts.nix
    ./gtk.nix
    ./libreoffice.nix
    ./mako.nix
    ./rofi.nix
    ./sway.nix
    ./systemd.nix
    ./zathura.nix
  ];

  options = {
    tudor.graphicalSession = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable a Wayland graphical session and various apps.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.desktop = {
      sway.enable = true;

      mako.enable = true;
      rofi.enable = true;

      fonts.enable = true;
      gtk.enable = true;

      extraApps.enable = true;

      alacritty.enable = true;
      firefox.enable = true;
      zathura.enable = true;
      libreoffice.enable = true;
    };

    # No desktop without  s o u n d
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    services.geoclue2.enable = true;

    services.xserver.enable = true;
    services.xserver.desktopManager.gnome3.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    #services.accounts-daemon.enable = true;

    tudor.home = {
      home.packages = with pkgs; [
        pamixer
        playerctl
        grim
        slurp
        wl-clipboard
      ];

      xsession.pointerCursor = {
        package = pkgs.capitaine-cursors;
        name = "Capitaine Cursors";
      };

      services.redshift = {
        enable = true;
        package = pkgs.redshift-wlr;
        provider = "geoclue2";
      };

    };
  };
}
