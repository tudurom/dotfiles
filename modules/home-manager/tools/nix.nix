{
  config,
  pkgs,
  lib,
  flake,
  ...
}: let
  cfg = config.homeModules.tools.nix;
in
  with lib; {
    options = {
      homeModules.tools.nix = {
        enable = mkEnableOption "Nix user settings";
        installAttic = mkEnableOption "Install attic client";
      };
    };

    config = mkIf cfg.enable {
      nix.registry.stable.flake = flake.inputs.nixpkgs;
      nixpkgs.overlays = mkIf cfg.installAttic [
        flake.inputs.attic.overlays.default
      ];
      home.packages = with pkgs;
        mkIf cfg.installAttic [
          attic
        ];
    };
  }
