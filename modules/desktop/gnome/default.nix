{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.graphicalSession.gnome;
  username = config.tudor.username;
in
with lib; {
  options = {
    tudor.graphicalSession.gnome.enable = mkEnableOption "Gnome Desktop Environment";
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.gnome3.enable = true;
    services.gnome3.chrome-gnome-shell.enable = true;

    # Open ports for KDE Connect
    networking.firewall.allowedTCPPorts = [
      1714 1715 1716 1717 1718 1719
      1720 1721 1722 1723 1724 1725 1726 1727 1728 1729
      1730 1731 1732 1733 1734 1735 1736 1737 1738 1739
      1740 1741 1742 1743 1744 1745 1746 1747 1748 1749
      1750 1751 1752 1753 1754 1755 1756 1757 1758 1759
      1760 1761 1762 1763 1764
    ];
    networking.firewall.allowedUDPPorts = [
      1714 1715 1716 1717 1718 1719
      1720 1721 1722 1723 1724 1725 1726 1727 1728 1729
      1730 1731 1732 1733 1734 1735 1736 1737 1738 1739
      1740 1741 1742 1743 1744 1745 1746 1747 1748 1749
      1750 1751 1752 1753 1754 1755 1756 1757 1758 1759
      1760 1761 1762 1763 1764
    ];
    environment.systemPackages = with pkgs.gnomeExtensions; [
      gsconnect
    ];

    tudor.home = {
      dconf.settings = {
        "org/gnome/desktop/background" = {
          picture-uri = "file:///home/${username}/wallpapers/street.png";
        };

        "org/gnome/desktop/wm/keybindings" = let
          wsBindings = ws': let ws = toString ws'; in {
            "switch-to-workspace-${ws}" = ["<Alt>${ws}"];
            "move-to-workspace-${ws}" = ["<Alt><Shift>${ws}"];
          };
          genWsBindings = wss: foldl (a: b: a // b) {} (map wsBindings wss);
        in {
          close = ["<Super>w"];
        } // genWsBindings [ 1 2 3 4 5 6 ];

        "org/gnome/shell" = {
          enabled-extensions = [
            "dash-to-dock@micxgx.gmail.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "gsconnect@andyholmes.github.io"
          ];
          favorite-apps = [
            "firefox.desktop"
            "org.gnome.Geary.desktop"
            "org.gnome.Nautilus.desktop"
            "spotify.desktop"
            "org.telegram.desktop.desktop"
          ];

        };

        "org/gnome/shell/extensions/dash-to-dock" = {
          dock-position = "BOTTOM";
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          tap-to-click = true;
          two-finger-scrolling-enabled = true;
        };
      };

      home.packages = with pkgs.gnomeExtensions; [
        appindicator
        dash-to-dock
      ];
    };
  };
}
