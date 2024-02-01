{
  pkgs,
  lib,
  flake,
  ...
}: {
  imports = with flake.inputs.nixos-hardware.nixosModules; [
    common-pc
    common-pc-hdd
    common-cpu-intel
    common-cpu-intel-cpu-only
  ];

  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = ["ata_generic" "uhci_hcd" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "rpool/root/nixos";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "rpool/nix";
    fsType = "zfs";
    neededForBoot = true;
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8d11e1ec-50db-4aa3-a920-788e7f88b68e";
    fsType = "ext4";
  };

  # there's also rpool/root/podman for container storage

  swapDevices = [];

  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
