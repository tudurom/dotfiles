{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.js;
in
with lib; {
  options.tudor.langs.js.enable = mkEnableOption "NodeJS";

  config = mkIf cfg.enable {
    tudor.home.home.packages = with pkgs; [
      nodejs
      yarn
    ];
  };
}
