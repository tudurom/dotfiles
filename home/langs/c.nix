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
      (pkgs.hiPrio clang_10)
      clang-tools
      cmake
      gcc
      gdb
      gnumake
      meson
      ninja
    ];

    home.sessionVariables = {
      "CC" = "clang";
      "CXX" = "clang++";
    };
  };
}
