{ config, pkgs, lib, ... }:
let
  cfg = config.homeModules.tools.hx;
in
with lib; {
  options = {
    homeModules.tools.hx = {
      enable = mkEnableOption "Enable Helix";
      defaultEditor = mkOption {
        type = types.bool;
        description = "Set EDITOR and VISUAL to hx";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = pkgs.unstable.helix;
      settings = {
        theme = "gruvbox_light";

        editor.bufferline = "multiple";
        editor.true-color = true;
        editor.color-modes = true;

        editor.indent-guides.render = true;
      };
    };

    home.sessionVariables = if cfg.defaultEditor then {
      EDITOR = "hx";
      VISUAL = "hx";
    } else {};
  };
}
