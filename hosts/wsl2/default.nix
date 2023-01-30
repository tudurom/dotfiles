{ config, pkgs, ... }:
{
  imports = [ ../_all ];

  systemModules = {
    basePackages.enable = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
  };
  time.timeZone = "Europe/Amsterdam";

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "tudor";
    startMenuLaunchers = true;
  };

  home-manager.users.tudor = ../../users/tudor/home.nix;
}
