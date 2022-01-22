{ config, lib, pkgs, ... }:
{
  environment.variables = {
    NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
      stdenv.cc.cc
      gcc-unwrapped.lib
    ];
    NIX_LD = pkgs.binutils.dynamicLinker;
  };
}
