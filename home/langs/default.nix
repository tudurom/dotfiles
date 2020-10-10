{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.langSupport;
in
with lib; {
  imports = [ ./c.nix ./elixir.nix ./go.nix ./python.nix ./rust.nix ./tex.nix ];

  options = {
    tudor.langs.langSupport = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable support for all programming languages;
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.langs = {
      c.enable = true;
      elixir.enable = true;
      go.enable = true;
      python.enable = true;
      rust.enable = true;
      tex.enable = true;
    };

    # for nix itself
    home.packages = [
      pkgs.nixfmt
    ];
  };
}
