{ config, options, lib, inputs, pkgs, ... }:
let
  cfg = config.homeModules.desktop.fonts;
in
with lib; {
  options = {
    homeModules.desktop.fonts = {
      enable = mkEnableOption "Enable fonts";
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
  };
}
