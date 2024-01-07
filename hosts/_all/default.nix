{ flake, vars, ... }:

{
  imports = [
    ../../modules/nixos
  ];

  systemModules = {
    nix.enable = true;
  };

  i18n.supportedLocales = [
    "en_GB.UTF-8/UTF-8"
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

  users.mutableUsers = false;

  system.stateVersion = vars.stateVersion;
  system.configurationRevision = flake.self.rev or "dirty";
}
