{ config, pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./web
  ];
}
