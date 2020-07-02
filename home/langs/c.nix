{ config, pkgs, ... }: {
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
}
