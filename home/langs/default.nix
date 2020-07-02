{ config, pkgs, ... }: {
  imports = [ ./c.nix ./go.nix ./python.nix ./rust.nix ./tex.nix ];

  # for nix itself
  home.packages = [
    pkgs.nixfmt
  ];
}
