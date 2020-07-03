{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.c;
in
with lib; {
  options = {
    tudor.langs.c = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bear
      ccls
      clang
      clang-tools
      cmake
      cmake
      gdb
      meson
      ninja
      gnumake
    ];

    home.sessionVariables = {
      "CC" = "clang";
      "CXX" = "clang++";
    };
  };
}
