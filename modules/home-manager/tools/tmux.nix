{
  config,
  lib,
  ...
}: let
  cfg = config.homeModules.tools.tmux;
  shellCfg = config.homeModules.shell.default;
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
          set -ag terminal-overrides ",xterm-256color:RGB"

          set -sg escape-time 0

          # sanity
          setw -g mode-keys vi
          set -g status-keys vi

          bind h split-window -v
          bind v split-window -h

          ${
            if shellCfg.package != null
            then "set-option -g default-shell ${lib.getExe shellCfg.package}"
            else ""
          }
        '';
      };
    };
  }
