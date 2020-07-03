{ config, lib, pkgs, ... }:
let
  cfg = config.tudor.langs.rust;
in
with lib; {
  options = {
    tudor.langs.rust = {
      enable = mkOption {
        default = false;
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rustup
    ];

    home.sessionVariables = {
      RUST_SRC_PATH = "$(rustc --print sysroot)/lib/rustlib/src/rust/src";
    };
  };
}
