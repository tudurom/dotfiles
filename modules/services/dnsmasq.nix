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
      extraConfig = ''
        interface=wg0
        interface=tailscale0
        cache-size=1000
        local=/localdomain/
        domain=localdomain
      '';
    };
  };
}
