{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  i18n.defaultLocale = "ro_RO.UTF-8";
  time.timeZone = "Europe/Bucharest";

  boot.supportedFilesystems = [ "btrfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "anton"; # Define your hostname.
  networking.networkmanager.enable = true;

  # no need for dhcp, network manager manages it for us
  networking.useDHCP = false;
  networking.interfaces.enp37s0.useDHCP = false;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh.enable = true;

  tudor.system.eraseRoot = {
    enable = true;
    rootUuid = "7a636e47-33b4-4181-a08a-4a66c6e7f98e ";
  };
  tudor.system.virtualisation.enable = true;

  tudor.graphicalSession.enable = true;
  tudor.graphicalSession.sway.enable = true;
  tudor.graphicalSession.gnome.enable = true;
  tudor.tools.emacs.enable = true;
  #tudor.tools.neuron.enable = true;
  tudor.langs.langSupport.enable = true;

  systemd.services.systemd-udev-settle.enable = false;

  tudor.printing.enable = true;

  boot.plymouth.enable = true;

  #virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "tudor" ];
  tudor.home.home.packages = [ pkgs.packer ];
}
