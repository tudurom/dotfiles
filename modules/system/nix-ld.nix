{ config, lib, pkgs, ... }:
let
  sources = import ../../nix/sources.nix;
in
{
  imports = [ "${sources.nix-ld}/modules/nix-ld.nix" ];
}
