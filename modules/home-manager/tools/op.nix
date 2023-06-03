{ config, lib, pkgs, configName, ... }:
let
  cfg = config.homeModules.tools.op;
in
with lib; {
  options = {
    homeModules.tools.op = {
      enable = mkEnableOption "Enable 1Password CLI";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      _1password
    ];
    home.shellAliases.op = if configName == "wsl2" then "op.exe" else "";
  };
}
