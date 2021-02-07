{ config, lib, pkgs, ... }:
{
  imports = [
    ./erase-root.nix
    ./printing.nix
    ./virtualisation.nix
  ];

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="0850|0852|0853|0854|0856|0858|085a|085b", TAG+="uaccess"
  '';
}
