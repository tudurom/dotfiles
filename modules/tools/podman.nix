{ config, lib, pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
