{ config, pkgs, ... }:
{
  imports = [
    ./dnsmasq.nix
    ./ipforward.nix
    ./ssh.nix
    ./syncthing.nix
    ./tailscale.nix
    ./web
  ];
}
