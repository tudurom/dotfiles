{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.go;
in
with lib; {
  options = {
    tudor.langs.go = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home.home.packages = with pkgs; [
      go
      goimports
      gomodifytags
      gotests
      gotools
    ];
  };
}
