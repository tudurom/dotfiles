{ inputs, config, lib, pkgs, ... }:
let
  cfg = config.tudor.tools.emacs;
  langCfg = config.tudor.langs;
  emacsKind = pkgs.unstable.emacsNativeComp;
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
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];
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

        libgccjit
      ] ++ (optionals (langCfg.c.enable) [
        bear
        ccls
      ]);

      programs.emacs = {
        enable = true;
        extraPackages = epkgs: with epkgs; [ vterm pdf-tools ];
        package = emacsKind;
      };
    };
    tudor.tools.aspell.enable = true;
  };
}
