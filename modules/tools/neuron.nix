{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.tools.neuron;
  sources = import ../../nix/sources.nix { };
in
with lib; {
  options = {
    tudor.tools.neuron = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home.home.packages = [
      (import sources.neuron {})
    ];
  };
}
