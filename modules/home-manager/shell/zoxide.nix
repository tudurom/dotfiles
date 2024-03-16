{
  config,
  lib,
  ...
}: let
  cfg = config.homeModules.shell.zoxide;
in {
  options.homeModules.shell.zoxide = {
    enable = lib.mkEnableOption "zoxide";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide.enable = true;
  };
}
