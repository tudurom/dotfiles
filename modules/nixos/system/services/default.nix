{...}: {
  imports = [
    ./dyndns.nix
    ./ipforward.nix
    ./ssh.nix
    ./tailscale.nix
    ./web
  ];
}
