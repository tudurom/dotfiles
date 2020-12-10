let
  sources = import ../nix/sources.nix;
in
[
  (self: super: with super; rec {
    tudor = {
      bw-git-helper = callPackage ./bw-git-helper.nix {};
      rofi-wayland = callPackage ./rofi-wayland/wrapper.nix {};

      site = import sources.site {};
      blog = import sources.blog;
    };

    rofi = tudor.rofi-wayland;

    unstable = import sources.nixos-unstable { inherit config; };
    nixpkgs-old = import sources.nixpkgs-old { inherit config; };
  })
]
