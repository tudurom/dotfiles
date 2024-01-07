{ config, lib, ... }:

with lib;
let
  cfg = config.homeModules.shell.fish;
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
    };

    # automatically true and readonly
    # https://github.com/nix-community/home-manager/blob/6a20e40acaebf067da682661aa67da8b36812606/modules/programs/direnv.nix#L65-L78
    # programs.direnv.enableFishIntegration = true;
  };
}
