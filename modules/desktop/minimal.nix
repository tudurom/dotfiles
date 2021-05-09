{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.graphicalSession.minimal;
in
with lib; {
  options = {
    tudor.graphicalSession.minimal.enable =
      mkEnableOption "Graphical session without programs and with no display manager";
  };

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    };

    tudor.desktop = {
      fonts.enable = true;
      gtk.enable = true;
    };

    # No desktop without  s o u n d
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    services.geoclue2.enable = true;
    services.xserver.enable = true;

    services.flatpak.enable = true;
    programs.dconf.enable = true;

    systemd.user.services.dbus.wantedBy = [ "default.target" ];
  };
}
