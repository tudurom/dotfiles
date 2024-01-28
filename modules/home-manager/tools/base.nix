{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.homeModules.tools.base;
in {
  options = {
    homeModules.tools.base = {
      enable = mkEnableOption "Enable base utilities";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dos2unix
      fd
      file
      htop
      jq
      ripgrep
      tmux
      tree
      unrar
      unzip
      zip
      zlib
    ];
  };
}
