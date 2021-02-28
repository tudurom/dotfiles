{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.services.syncthing;
in
with lib;
{
  options = {
    tudor.services.syncthing.enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];

    tudor.home.services.syncthing = {
      enable = true;
      tray = true;
    };
  };
}
