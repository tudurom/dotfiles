{ config, lib, ... }:
let
  cfg = config.systemModules.services.ssh;
in
with lib;
{
  options.systemModules.services.ssh = {
    enable = mkEnableOption "ssh";
    enableMosh = mkEnableOption "mosh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };
    programs.mosh.enable = cfg.enableMosh;
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
