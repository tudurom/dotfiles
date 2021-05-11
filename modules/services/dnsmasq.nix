{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.services.dnsmasq;
in
with lib;
{
  options.tudor.services.dnsmasq.enable = mkEnableOption "dnsmasq DNS server";

  config = mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;
      servers = [ "1.1.1.1" "1.0.0.1" ];
      extraConfig = ''
        cache-size=1000
        #local=/localdomain/
        #domain=localdomain
        no-resolv
      '';
    };
    networking.firewall.allowedTCPPorts = [ 53 ];
    networking.firewall.allowedUDPPorts = [ 53 ];
  };
}
