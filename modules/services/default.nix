{ config, pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./syncthing.nix
    ./tailscale.nix
    ./web
  ];
}
