{
  config,
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
      };
    };

    config = mkIf cfg.enable {
      nix = {
        registry = {
          stable.flake = flake.inputs.nixpkgs;
          unstable.flake = flake.inputs.unstable;
        };
        settings = {
          sandbox = true;
          substituters = [
            "https://nix-community.cachix.org"
            "https://cache.garnix.io"
          ];
          trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          ];
        };
      };
    };
  }
