{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.desktop.gtk;
in
with lib; {
  options = {
    tudor.desktop.gtk = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home = {
      gtk = {
        enable = true;
        font = {
          package = null;
          name = "Roboto Condensed:size=12";
        };
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = "Papirus";
        };
        theme = {
          name = "Adwaita-dark";
        };
        gtk3.extraCss = ''
          VteTerminal, vte-terminal {
            padding: 20px;
          }
        '';

        # gtk3.extraConfig = {
        #   gtk-xft-antialias = 1;
        #   gtk-xft-hinting = 1;
        #   gtk-xft-hintstyle = "hintslight";
        #   gtk-xft-rgba = "none";
        # };
      };
    };
    programs.dconf.enable = true;
  };
}
