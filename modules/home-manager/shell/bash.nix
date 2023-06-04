{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homeModules.shell.bash;
  direnvCfg = config.homeModules.tools.direnv;
  opCfg = config.homeModules.tools.op;
in
{
  options.homeModules.shell.bash = {
    enable = mkOption {
      default = true;
      type = types.bool;
    };

    execFish = mkEnableOption "Start fish if interactive shell";
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      initExtra =
        opCfg.bashInitExtra +
        (if cfg.execFish then ''
          # start fish if interactive
          if [[ $(basename "$(ps --no-header --pid=$PPID --format=cmd)") != "fish" ]]; then
            [[ -z "$BASH_EXECUTION_STRING" ]] && exec ${pkgs.fish}/bin/fish
          fi
        '' else "") +
        (if direnvCfg.enable then ''
          eval "$(${pkgs.direnv}/bin/direnv hook bash)"
        '' else "")
      ;
    };
  };
}
