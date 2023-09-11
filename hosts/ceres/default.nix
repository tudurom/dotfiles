{ config, pkgs, lib, vars, ...}:
{
  imports = [ ../_all ./hardware.nix ];

  systemModules.basePackages.enable = true;
  systemModules.services = {
    ssh.enable = true;
    web = {
      nginx.enable = true;
      cgit.enable = false;
      gitea.enable = true;
      site.enable = true;
      vaultwarden.enable = true;
      miniflux.enable = true;
    };
    ipforward.enable = true;
    tailscale.enable = true;
    pong.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Bucharest";

  boot.supportedFilesystems = [ "zfs" ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/disk/by-id/ata-Hitachi_HTS725025A9A364_100625PCK200VJHNKPPJ";
  };

  networking = {
    hostName = "ceres";
    useDHCP = false;
    hostId = "23247628"; # for zfs
    interfaces.enp0s25.useDHCP = true;

    firewall.enable = true;

    extraHosts = ''
      192.168.12.115 ceres.localdomain
      192.168.12.200 truenas.localdomain
    '';
  };

  age.secrets = {
    tudor-password = {
      file = ../../secrets/ceres/tudor-password.age;
    };
    miniflux-credentials = {
      file = ../../secrets/ceres/miniflux-credentials.age;
    };
  };

  users.users.${vars.username} = {
    passwordFile = config.age.secrets.tudor-password.path;
    openssh.authorizedKeys.keys = [
      (builtins.readFile ../../id_ed25519.pub)
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  services.zfs.autoSnapshot.enable = true;
  services.zfs.autoScrub.enable = true;
  home-manager.users.tudor = ../../users/tudor;
}
