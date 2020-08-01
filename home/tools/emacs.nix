{ config, lib, pkgs, ... }:
with import <nixpkgs> {
  overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];
};
let
  cfg = config.tudor.tools.emacs;
  emacsKind = emacsUnstable;
in
with lib; {
  options = {
    tudor.tools.emacs = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls

      # extra doom deps
      fd
      imagemagick
      zstd

      # :checkers grammar
      languagetool
      # :tools editorconfig
      editorconfig-core-c
      # fancy icons
      emacs-all-the-icons-fonts

      libvterm
    ];

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [ epkgs.emacs-libvterm ];
      package = emacsKind;
    };
    tudor.hax.wrappers = [ "${emacsKind}/bin/emacs" ];
    tudor.tools.aspell.enable = true;
  };
}
