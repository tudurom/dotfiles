{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware.nix ./wireguard.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Bucharest";

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

  tudor.services.ssh.enable = true;
  tudor.services.web.nginx.enable = true;
  tudor.services.web.apps = {
    bitwarden_rs.enable = true;
    cgit.enable = true;
    site.enable = true;
  };

  tudor.services.tailscale.enable = true;

  networking.nameservers = [
    "100.100.100.100" # tailscale
    "127.0.0.1" # dnsmasq
  ];
  networking.search = [
    "tudurom.gmail.com.beta.tailscale.net"
    "localdomain"
  ];
  networking.resolvconf.useLocalResolver = lib.mkForce false;

  # hack sourced from here
  # https://cs.tvl.fyi/depot@e7c78570ed66cd753add2664b7545d234c947b84/-/blob/users/tazjin/nixos/frog/default.nix#L95-102
  environment.etc."resolv.conf" = with lib; with pkgs; {
    source = writeText "resolv.conf" ''
      ${concatStringsSep "\n" (map (ns: "nameserver ${ns}") config.networking.nameservers)}
      ${concatStringsSep "\n" (map (domain: "search ${domain}") config.networking.search)}
      options edns0
    '';
  };
  networking.extraHosts = ''
    192.168.12.115 ceres.localdomain
    192.168.12.200 truenas.localdomain
  '';
}
