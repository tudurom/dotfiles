{ config, lib, pkgs, ... }:
{
  imports = [
    ./bitwarden_rs.nix
    ./cgit
    ./site.nix
  ];
}
