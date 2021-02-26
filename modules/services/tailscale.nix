{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.services.tailscale;
in
with lib;
{
  options.tudor.services.tailscale.enable = mkEnableOption "tailscale";

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
