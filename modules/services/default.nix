{ config, pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./tailscale.nix
    ./web
  ];
}
