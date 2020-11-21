{ config, pkgs, lib, ... }:
{
  imports = [
    ./nginx.nix
    ./apps
  ];
}
