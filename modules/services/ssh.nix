{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.services.ssh;
in
with lib; {
  options.tudor.services.ssh = {
    enable = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Enable ssh and open port 22.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
