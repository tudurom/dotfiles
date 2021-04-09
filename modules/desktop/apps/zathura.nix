{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.desktop.zathura;
in
with lib; {
  options = {
    tudor.desktop.zathura = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home.programs.zathura = {
      enable = true;
      options.smoothScroll = true;
    };
  };
}
