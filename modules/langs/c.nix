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

  config = let
    gcc = pkgs.gcc;
    clang = pkgs.llvmPackages_latest.clang;
  in mkIf cfg.enable {
    tudor.home = {
      programs.fish.shellAliases = {
        gcc = "${gcc}/bin/gcc";
        clang = "${clang}/bin/clang";
      };
      home.packages = with pkgs; [
        clang-tools
        cmake
        gdb
        gnumake
        meson
        ninja
      ];

      home.sessionVariables = {
        "CC" = "${clang}/bin/clang";
        "CXX" = "${clang}/bin/clang++";
      };
    };
  };
}
