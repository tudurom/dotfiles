{ ... }:
{
  imports = [
    ./dyndns.nix
    ./ipforward.nix
    ./pong.nix
    ./ssh.nix
    ./tailscale.nix
    ./web
  ];
}
