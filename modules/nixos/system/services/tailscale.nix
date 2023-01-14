{ config, pkgs, lib, ... }:
let
  cfg = config.systemModules.services.tailscale;
in
with lib;
{
  options.systemModules.services.tailscale = {
    enable = mkEnableOption "tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
