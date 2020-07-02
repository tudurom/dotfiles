{ config, pkgs, ... }:
{
  gtk = {
    enable = true;
    font = {
      package = pkgs.roboto;
      name = "Roboto Condensed 12";
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
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "none";
    };
  };
}
