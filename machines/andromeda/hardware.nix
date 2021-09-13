{ config, lib, pkgs, modulesPath, ... }:

let
  sources = import ../../nix/sources.nix;
in {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      "${sources.nixos-hardware}/lenovo/thinkpad/t440s"
      "${sources.nixos-hardware}/common/pc/ssd"
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "mitigations=off" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7046fa58-8982-4189-8b49-e89ad52d2205";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/7046fa58-8982-4189-8b49-e89ad52d2205";
      fsType = "btrfs";
      options = [ "subvol=home" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/7046fa58-8982-4189-8b49-e89ad52d2205";
      fsType = "btrfs";
      options = [ "subvol=nix" "noatime" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/7046fa58-8982-4189-8b49-e89ad52d2205";
      fsType = "btrfs";
      options = [ "subvol=log" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/26C4-045D";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/1f0dd7b2-d1c5-40c2-bc3c-a0deaa7ba92c"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
}
