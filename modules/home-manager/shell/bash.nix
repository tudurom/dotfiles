{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.homeModules.shell.bash;
in {
  options.homeModules.shell.bash = {
    enable = mkOption {
      default = true;
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
    };

    programs.direnv.enableBashIntegration = true;
  };
}
