{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.homeModules.shell.fish;
  direnvCfg = config.homeModules.tools.direnv;
in
{
  options.homeModules.shell.fish = {
    enable = mkOption {
      default = false;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      shellAliases = {
        ls = "ls --color=auto -F";
        ll = "ls --color=auto -alF";
        rm = "rm -I";
      };
      interactiveShellInit = ''
        #test -f /run/nixoswsl.env && set -x -a PATH (grep PATH /run/nixoswsl.env | cut -d'=' -f2-)
      '' + (if direnvCfg.enable then ''
        eval (${pkgs.direnv}/bin/direnv hook fish)
      '' else "");
    };
  };
}
