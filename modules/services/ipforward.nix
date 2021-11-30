{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.services.ipforward;
in
with lib;
{
  options.tudor.services.ipforward.enable = mkEnableOption "IP Forwarding";

  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = true;
      "net.ipv6.conf.all.forwarding" = true;
    };
  };
}
