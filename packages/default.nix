let
  sources = import ../nix/sources.nix;
in
[
  (self: super: with super; rec {
    tudor = {
      bw-git-helper = callPackage ./bw-git-helper.nix {};
      rofi-wayland = callPackage ./rofi-wayland/wrapper.nix {};
    };

    rofi = tudor.rofi-wayland;
  })
]
