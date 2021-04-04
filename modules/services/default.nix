{ config, pkgs, ... }:
{
  imports = [
    ./dnsmasq.nix
    ./ssh.nix
    ./syncthing.nix
    ./tailscale.nix
    ./web
  ];
}
