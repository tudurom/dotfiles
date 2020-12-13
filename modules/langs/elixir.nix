{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.elixir;
in
with lib; {
  options = {
    tudor.langs.elixir = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    tudor.home.home.packages = with pkgs; [
      elixir
      inotify-tools
    ];
  };
}
