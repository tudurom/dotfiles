{ config, lib, pkgs, ... }:
{
  imports = [
    ./vaultwarden.nix
    ./cgit
    ./site.nix
  ];
}
