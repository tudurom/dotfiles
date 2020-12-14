{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware.nix ];

  i18n.defaultLocale = "ro_RO.UTF-8";
  time.timeZone = "Europe/Bucharest";

  boot.supportedFilesystems = [ "btrfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "andromeda"; # Define your hostname.
  networking.networkmanager.enable = true;

  # no need for dhcp, network manager manages it for us
  networking.useDHCP = false;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh.enable = true;

  tudor.graphicalSession.enable = true;
  tudor.graphicalSession.sway.enable = true;
  tudor.graphicalSession.gnome.enable = true;
  services.xserver.displayManager.defaultSession = "gnome";
  tudor.tools.emacs.enable = true;
  #tudor.tools.neuron.enable = true;
  tudor.langs.langSupport.enable = true;

  systemd.services.systemd-udev-settle.enable = false;

  services.tlp.enable = false;

  tudor.printing.enable = true;

  boot.plymouth.enable = true;

  security.pam.u2f = {
    enable = true;
    control = "sufficient";
    cue = true;
  };
}
