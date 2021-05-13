{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.graphicalSession;
in
with lib; {
  imports = [
    ./apps
    ./dirs.nix
    ./fonts.nix
    ./gnome
    ./gtk.nix
    ./mako.nix
    ./minimal.nix
    ./rofi.nix
    ./sway.nix
    ./waybar.nix
  ];

  options = {
    tudor.graphicalSession = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable applications needed for a graphical session.
          You should enable a DE / compositor separately.
        '';
      };

      sway.enable = mkEnableOption "Sway";
    };
  };

  config = mkIf cfg.enable {
    tudor.graphicalSession.minimal.enable = true;

    tudor.desktop = {
      fonts.enable = true;
      gtk.enable = true;

      extraApps.enable = true;

      alacritty.enable = true;
      firefox.enable = true;
      zathura.enable = true;
      libreoffice.enable = true;
    } // (if cfg.sway.enable then {
      sway.enable = true;

      mako.enable = true;
      rofi.enable = true;
    } else {});

    services.xserver.displayManager.gdm.enable = true;

    tudor.home = {
      home.packages = with pkgs; [
        cmus
        grim
        pamixer
        playerctl
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


      xdg.configFile."Yubico/u2f_keys".text = ''
        tudor:6z1rDX9CR6q8zAhfgisdiCTDEZScKB5dAY-Dp8btpYHEmQTBgaouZJe466C2RTDkzlLVihGxlPRUpZyXF1zLmkqdCMaXTWDQypFGvWZUcWHy6tXxjEA3Op6kTuVOqhPi,0462b90521391a2ab60d2f97eb44ea01d72ad65a336821bf7ecc135b1f41005632190be044cc84ee9047e2778fe310c8c2368f34a9cada46ae4ea9eacc040f19c4
      '';
    };
  };
}
