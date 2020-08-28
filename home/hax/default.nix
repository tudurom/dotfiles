{ config, lib, pkgs, options, ... }:
let
  cfg = config.tudor.hax;
in
with lib; {
  imports = [ ./wrappers.nix ];

  options = {
    tudor.hax = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    targets.genericLinux.enable = true;
    programs.man.enable = true;
    home.packages = [ pkgs.glibcLocales ];
  };
}
