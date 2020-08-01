{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.python;
in
with lib; {
  options = {
    tudor.langs.python = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python38
      #python38Packages.black
      python38Packages.ipython
      python38Packages.pip
      python38Packages.pylint
      python38Packages.setuptools
    ];
  };
}
