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

      # :checkers spell
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      aspellDicts.ro
      # :checkers grammar
      languagetool
      # :tools editorconfig
      editorconfig-core-c
      # fancy icons
      emacs-all-the-icons-fonts
    ];

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [ epkgs.vterm ];
      package = emacsKind;
    };
    my.hax.wrappers = [ "${emacsKind}/bin/emacs" ];
  };
}
