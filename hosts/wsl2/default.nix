{
  config,
  flake,
  ...
}: let
  username = "tudor";
in {
  imports = [../_all flake.inputs.nixos-wsl.nixosModules.wsl];

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
    defaultUser = username;
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

  networking.hostName = "wsl2";

  age.secrets.tudor-password = {
    file = ../../secrets/wsl2/tudor-password.age;
  };

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    uid = 1000;
    home = "/home/${username}";
    hashedPasswordFile = config.age.secrets.tudor-password.path;
  };

  home-manager.users.tudor = ../../users + "/tudor@wsl2";
}
