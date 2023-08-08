{ config, options, lib, inputs, pkgs, ... }:
let
  cfg = config.homeModules.desktop.nixgl;
in
with lib; {
  options = {
    homeModules.desktop.nixgl = {
      enable = mkEnableOption "Enable NixGL";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.nixgl.nixGLIntel ];
  };
}
