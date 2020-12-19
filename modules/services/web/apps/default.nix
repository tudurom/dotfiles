{ config, lib, pkgs, ... }:
{
  imports = [
    ./bitwarden_rs.nix
    ./cgit.nix
    ./site.nix
  ];
}
