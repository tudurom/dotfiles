{ config, lib, flake, ... }:
let
  cfg = config.homeModules.tools.nix;
in
with lib; {
  options = {
    homeModules.tools.nix = {
      enable = mkEnableOption "Nix user settings";
    };
  };

  config = mkIf cfg.enable {
    nix.registry.stable.flake = flake.inputs.nixpkgs;
  };
}
