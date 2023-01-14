{ config, lib, pkgs, nixpkgs, self, inputs, vars, ... }:

{
  imports = [
    ../../modules/nixos
  ];

  systemModules = {
    nix.enable = true;
  };

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ro_RO.UTF-8/UTF-8"
    "nl_NL.UTF-8/UTF-8"
  ];

  # quick boot
  systemd.services.NetworkManager-wait-online.enable = false;

  documentation = {
    enable = true;
    doc.enable = false;
    info.enable = false;
    nixos.enable = true;
    dev.enable = true;
    man.generateCaches = true;
  };

  users.users.tudor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "scanner" "lp" ];
    uid = 1000;
    home = "/home/tudor";
  };

  system.stateVersion = vars.stateVersion;
  system.configurationRevision = self.rev or "dirty";
}
