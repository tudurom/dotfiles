{ config, pkgs, ... }:
{
  imports = [ ../_all ];

  systemModules = {
    basePackages.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "nl_NL.UTF-8";
  };
  time.timeZone = "Europe/Amsterdam";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "tudor";
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

  home-manager.users.tudor = ../../users/tudor/home.nix;
}
