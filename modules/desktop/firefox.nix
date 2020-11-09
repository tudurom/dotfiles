{ config, pkgs, lib, ... }:
let
  cfg = config.tudor.desktop.firefox;
in
with lib; {
  options = {
    tudor.desktop.firefox = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home = {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-bin;

        #profiles = {
        #  default = {
        #    isDefault = true;
        #    id = 0;
        #  };
        #};
      };

      home.sessionVariables."BROWSER" = "firefox";
    };
  };
}
