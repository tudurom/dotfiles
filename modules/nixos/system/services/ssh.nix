{ config, pkgs, lib, ... }:
let
  cfg = config.systemModules.services.ssh;
in
with lib;
{
  options.systemModules.services.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
