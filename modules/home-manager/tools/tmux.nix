{ config, options, pkgs, lib, ... }:
let
  cfg = config.homeModules.tools.tmux;
in
with lib; {
  options = {
    homeModules.tools.tmux = {
      enable = mkEnableOption "Enable Tmux";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      sensibleOnTop = true;
      extraConfig = ''
      set -as terminal-features ",*:RGB"
      '';
    };
  };
}
