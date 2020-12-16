{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.printing;
in
with lib; {
  options.tudor.printing.enable = mkEnableOption "printing";

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [
      brgenml1lpr
      brgenml1cupswrapper
    ];
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    services.avahi.publish.enable = true;
    services.avahi.publish.userServices = true;

    hardware.sane.enable = true;
    hardware.sane.extraBackends = with pkgs; [ sane-airscan ];
  };
}
