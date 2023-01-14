{ config, pkgs, lib, inputs, ... }:
let
  cfg = config.systemModules.services.pong;
in
with lib;
{
  options.systemModules.services.pong = {
    enable = mkEnableOption "telnet pong";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 42069 ];
    systemd.services.pong = {
      enable = true;
      description = "telnet pong";
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = "${pkgs.tudor.pong}/bin/pong";
        DynamicUser = "yes";
      };
    };
  };
}
