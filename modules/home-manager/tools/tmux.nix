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
      baseIndex = 1;
      mouse = true;
      clock24 = true; # why does 12h exist
      extraConfig = ''
      set -g default-terminal "tmux-256color"

      set -sg escape-time 0
      set -as terminal-features ",*:RGB"

      # sanity
      setw -g mode-keys vi
      set -g status-keys vi

      bind h split-window -v
      bind v split-window -h
      '';
    };
  };
}
