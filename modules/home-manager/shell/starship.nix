{
  config,
  options,
  lib,
  ...
}: let
  cfg = config.homeModules.shell.starship;
in {
  options.homeModules.shell.starship = {
    enable = lib.mkEnableOption "Starship";
  };

  config = lib.mkIf cfg.enable {
    programs.starship.enable = true;
  };
}
