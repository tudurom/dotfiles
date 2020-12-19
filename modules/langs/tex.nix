{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.tex;
in
with lib; {
  options = {
    tudor.langs.tex = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home = {
      home.packages = with pkgs; [ texlive.combined.scheme-full ];

      home.file.".latexmkrc".text = ''
        $pdf_mode = 1;
        $pdflatex = 'xelatex --shell-escape -interaction=nonstopmod %O %S -file-line-error -synctex=1';
      '';

      home.sessionVariables = {
        "TEXMFHOME" = "~/.texmf";
        "TEXMFVAR" = "~/.texmf-var";
        "TEXMFCONFIG" = "~/.texmf-config";
      };
    };
  };
}
