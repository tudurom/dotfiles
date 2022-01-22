{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware.nix ./wireguard.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Bucharest";

  boot.kernelPackages = lib.mkOverride 99 pkgs.linuxPackages_5_10;
  boot.supportedFilesystems = [ "zfs" ];

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Hitachi_HTS725025A9A364_100625PCK200VJHNKPPJ";

  networking.hostName = "ceres"; # Define your hostname.

  networking.useDHCP = false;
  networking.hostId = "23247628"; # for zfs
  networking.interfaces.enp0s25.useDHCP = true;

  networking.firewall.enable = true;

  services.zfs.autoSnapshot = {
    enable = true;
  };

  tudor.services.dnsmasq.enable = true;
  tudor.services.ssh.enable = true;
  tudor.services.web.nginx.enable = true;
  tudor.services.web.apps = {
    bitwarden_rs.enable = true;
    cgit.enable = true;
    site.enable = true;
  };

  tudor.services.ipforward.enable = true;
  tudor.services.tailscale.enable = true;

  networking.extraHosts = ''
    192.168.12.115 ceres.localdomain
    192.168.12.200 truenas.localdomain
  '';
}
