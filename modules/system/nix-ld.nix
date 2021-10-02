{ config, lib, pkgs, ... }:
let
  sources = import ../../nix/sources.nix;
in
{
  imports = [ "${sources.nix-ld}/modules/nix-ld.nix" ];

  environment.variables = {
    NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
      stdenv.cc.cc
      gcc-unwrapped.lib
    ];
    NIX_LD = builtins.readFile "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
  };
}
