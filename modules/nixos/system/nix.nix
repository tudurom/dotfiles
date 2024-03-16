{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
with lib; let
  cfg = config.systemModules.nix;
in {
  options.systemModules.nix = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

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

      registry.nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        to = {
          path = "${flake.inputs.nixpkgs}";
          type = "path";
        };
      };
    };
  };
}
