{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.graphicalSession;
in
with lib; {
  imports = [
    ./alacritty.nix
    ./dirs.nix
    ./fonts.nix
    ./gtk.nix
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

      alacritty.enable = true;
      zathura.enable = true;
    };

    home.packages = with pkgs; [
      xfce.xfce4-volumed-pulse
      redshift-wlr
      dex

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
  };
}
