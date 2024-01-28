{ config, lib, ... }:
with lib;
let
  cfg = config.homeModules.tools.direnv;
in {
  options.homeModules.tools.direnv = {
    enable = mkEnableOption "Enable direnv support";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
