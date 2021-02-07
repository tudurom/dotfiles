{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.system.virtualisation;
in
with lib; {
  options.tudor.system.virtualisation.enable = mkEnableOption "virtualisation support";

  config = mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    environment.systemPackages = with pkgs; [
      virt-manager
    ];
  };
}
