{ config, lib, ... }:
let
  cfg = config.homeModules.tools.neovim;
in
with lib; {
  options = {
    homeModules.tools.neovim = {
      enable = mkEnableOption "Enable Neovim";
      defaultEditor = mkOption {
        type = types.bool;
        description = "Set EDITOR and VISUAL to nvim";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
    };

    home.sessionVariables = if cfg.defaultEditor then {
      EDITOR = "nvim";
      VISUAL = "nvim";
    } else {};
  };
}
