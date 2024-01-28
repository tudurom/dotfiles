{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homeModules.shell.bash;
  opCfg = config.homeModules.tools.op;
in
{
  options.homeModules.shell.bash = {
    enable = mkOption {
      default = true;
      type = types.bool;
    };

    execOtherShell = mkEnableOption "Start another shell if interactive shell";
    shellToExecPackage = mkOption {
      type = types.package;
      default = pkgs.fish;
      defaultText = literalExpression "pkgs.fish";
      description = "The package for the shell to start";
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      initExtra = let
        shellName = builtins.baseNameOf (lib.getExe cfg.shellToExecPackage);
        in opCfg.bashInitExtra +
        (if cfg.execOtherShell then ''
          # start ${shellName} if interactive
          if [[ $(basename "$(ps --no-header --pid=$PPID --format=cmd)") != "${shellName}" ]]; then
            [[ -z "$BASH_EXECUTION_STRING" ]] && exec ${lib.getExe cfg.shellToExecPackage}
          fi
        '' else "")
      ;
    };

    programs.direnv.enableBashIntegration = true;
  };
}
