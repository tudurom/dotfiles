{ config, pkgs, vars, ... }:
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
    defaultUser = vars.username;
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

  networking.hostName = "wsl2";

  age.secrets.tudor-password = {
    file = ../../secrets/wsl2/tudor-password.age;
  };

  users.users.${vars.username}.passwordFile = config.age.secrets.tudor-password.path;

  home-manager.users.tudor = ../../users + "/tudor@wsl2";
}
