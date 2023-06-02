{ config, pkgs, lib, ...}:
{
  imports = [ ../_all ./hardware.nix ];

  systemModules.basePackages.enable = true;
  systemModules.services = {
    ssh.enable = true;
    web = {
      nginx.enable = true;
      cgit.enable = true;
      site.enable = true;
      vaultwarden.enable = true;
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

  services.zfs.autoSnapshot.enable = true;
  home-manager.users.tudor = ../../users/tudor/home.nix;
}
