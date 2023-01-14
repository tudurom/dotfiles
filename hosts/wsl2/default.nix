{ config, pkgs, ... }:
{
  imports = [ ../_all ];

  systemModules = {
    basePackages.enable = true;
  };

  i18n.defaultLocale = "ro_RO.UTF-8";
  time.timeZone = "Europe/Amsterdam";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "tudor";
    startMenuLaunchers = true;
  };

  home-manager.users.tudor = ../../users/tudor/home.nix;
}
