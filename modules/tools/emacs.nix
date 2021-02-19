{ config, lib, pkgs, ... }:
let
  sources = import ../../nix/sources.nix;
in
with import sources.nixpkgs-unstable {
  overlays = [
    (let
      sources = import ../../nix/sources.nix;
      fetchGitHubArchive = { owner, repo, rev, sha256 }: builtins.fetchTarball {
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
        inherit sha256;
      };
    in import (fetchGitHubArchive {
      inherit (sources.emacs-overlay) owner repo rev sha256;
    }))
  ];
};
let
  cfg = config.tudor.tools.emacs;
  emacsKind = emacsPgtkGcc;
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
    tudor.home = {
      home.packages = with pkgs; [
        # doom dependencies
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

        unstable.libgccjit

        # for org-roam
        sqlite
      ];

      programs.emacs = {
        enable = true;
        extraPackages = epkgs: [ epkgs.vterm ];
        package = emacsKind;
      };
    };
    tudor.tools.aspell.enable = true;
  };
}
