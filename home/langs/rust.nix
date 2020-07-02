{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    rustup
  ];

  home.sessionVariables = {
    RUST_SRC_PATH = "$(rustc --print sysroot)/lib/rustlib/src/rust/src";
  };
}
