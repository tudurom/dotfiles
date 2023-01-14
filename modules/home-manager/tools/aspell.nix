{ config, lib, pkgs, ... }:
let
  cfg = config.homeModules.tools.aspell;
in
with lib; {
  options = {
    homeModules.tools.aspell = {
      enable = mkEnableOption "Enable spell checking and dictionaries";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [
        en
        en-computers
        en-science
        ro
      ]))
    ];
  };
}
